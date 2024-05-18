// Copyright (c) 2024 Roger Brown.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Data.Common;
using System.IO;
using System.Management.Automation;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Runtime.Loader;

namespace RhubarbGeekNz.SqlConnection
{
    [Cmdlet(VerbsCommon.New, "SqlConnection")]
    [OutputType(typeof(DbConnection))]
    public class NewSqlConnection : PSCmdlet
    {
        [Parameter(
            Mandatory = true,
            Position = 0,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public string ConnectionString { get; set; }

        protected override void ProcessRecord()
        {
            WriteObject(SqlConnectionFactory.CreateInstance(ConnectionString));
        }
    }

    internal class AlcModuleAssemblyLoadContext : AssemblyLoadContext
    {
        private readonly string dependencyDirPath;
        private static readonly Dictionary<string, string> RIDMAP = new Dictionary<string, string>(){
            { "win10-arm", "win-arm" },
            { "win10-arm64", "win-arm64" },
            { "win10-x64", "win-x64" },
            { "win10-x86", "win-x86" },
            { "win-arm", "win-arm" },
            { "win-arm64", "win-arm64" },
            { "win-x64", "win-x64" },
            { "win-x86", "win-x86" }
        };

        public AlcModuleAssemblyLoadContext(string dependencyDirPath)
        {
            this.dependencyDirPath = dependencyDirPath;
        }

        protected override IntPtr LoadUnmanagedDll(string unmanagedDllName)
        {
            if (RIDMAP.TryGetValue(RuntimeInformation.RuntimeIdentifier, out string rid))
            {
                string sniAssemblyPath = Path.Combine(
                      dependencyDirPath,
                      rid,
                      unmanagedDllName);

                if (File.Exists(sniAssemblyPath))
                {
                    return NativeLibrary.Load(sniAssemblyPath);
                }
            }

            return IntPtr.Zero;
        }

        protected override Assembly Load(AssemblyName assemblyName)
        {
            string dllName = assemblyName.Name + ".dll";

            if (RIDMAP.TryGetValue(RuntimeInformation.RuntimeIdentifier, out string rid))
            {
                string winAssemblyPath = Path.Combine(
                    dependencyDirPath,
                    rid,
                    dllName);

                if (File.Exists(winAssemblyPath))
                {
                    return LoadFromAssemblyPath(winAssemblyPath);
                }

                winAssemblyPath = Path.Combine(
                    dependencyDirPath,
                    "win",
                    dllName);

                if (File.Exists(winAssemblyPath))
                {
                    return LoadFromAssemblyPath(winAssemblyPath);
                }
            }
            else
            {
                string unixAssemblyPath = Path.Combine(
                    dependencyDirPath,
                    "unix",
                    dllName);

                if (File.Exists(unixAssemblyPath))
                {
                    return LoadFromAssemblyPath(unixAssemblyPath);
                }
            }

            string assemblyPath = Path.Combine(
                dependencyDirPath,
                dllName);

            if (File.Exists(assemblyPath))
            {
                return LoadFromAssemblyPath(assemblyPath);
            }

            return null;
        }
    }

    public class AlcModuleResolveEventHandler : IModuleAssemblyInitializer, IModuleAssemblyCleanup
    {
        private static readonly string dependencyDirPath;

        private static readonly AlcModuleAssemblyLoadContext dependencyAlc;

        private static readonly Version alcVersion;

        private static readonly string alcName;

        static AlcModuleResolveEventHandler()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            dependencyDirPath = Path.GetFullPath(Path.Combine(Path.GetDirectoryName(assembly.Location), "lib"));
            dependencyAlc = new AlcModuleAssemblyLoadContext(dependencyDirPath);
            AssemblyName name = assembly.GetName();
            alcVersion = name.Version;
            alcName = name.Name + ".Alc";
        }

        public void OnImport()
        {
            AssemblyLoadContext.Default.Resolving += ResolveAlcModule;
        }

        public void OnRemove(PSModuleInfo psModuleInfo)
        {
            AssemblyLoadContext.Default.Resolving -= ResolveAlcModule;
        }

        private static Assembly ResolveAlcModule(AssemblyLoadContext defaultAlc, AssemblyName assemblyToResolve)
        {
            if (alcName.Equals(assemblyToResolve.Name) && alcVersion.Equals(assemblyToResolve.Version))
            {
                return dependencyAlc.LoadFromAssemblyName(assemblyToResolve);
            }

            return null;
        }
    }
}
