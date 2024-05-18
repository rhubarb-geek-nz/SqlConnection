# SqlConnection

Very simple `PowerShell` module for creating a connection to an `MSSQL` database.

This packages the new [Microsoft.Data.SqlClient](https://www.nuget.org/packages/Microsoft.Data.SqlClient/) into an [AssemblyLoadContext](https://learn.microsoft.com/en-us/powershell/scripting/dev-cross-plat/resolving-dependency-conflicts?view=powershell-7.4) and is instantiated with a cmdlet.

Build the module with

```
$ dotnet publish --configuration Release
```

Install by copying the module into a directory on the [PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

Create a test database.

```
$ docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=changeit" -e "MSSQL_PID=Express" -p 1433:1433 mcr.microsoft.com/mssql/server:latest
```

Run the `test.ps1` to confirm it works.

```
VERSION
-------
Microsoft SQL Server 2022 (RTM-CU12-GDR) (KB5036343) - 16.0.4120.1 (X64) .

```
