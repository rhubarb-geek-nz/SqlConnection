#!/usr/bin/env pwsh
# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

param($ProjectName,$IntermediateOutputPath,$OutDir,$PublishDir,$TargetFramework)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$compatiblePSEdition = 'Core'
$PowerShellVersion = '7.0'

switch ( $TargetFramework )
{
	'net5.0' { $PowerShellVersion = '7.1' }
	'net6.0' { $PowerShellVersion = '7.2' }
	'net7.0' { $PowerShellVersion = '7.3' }
	'net8.0' { $PowerShellVersion = '7.4' }
	'net9.0' { $PowerShellVersion = '7.5' }
}

function Get-SingleNodeValue([System.Xml.XmlDocument]$doc,[string]$path)
{
    return $doc.SelectSingleNode($path).FirstChild.Value
}

trap
{
	throw $PSItem
}

$xmlDoc = [System.Xml.XmlDocument](Get-Content "$ProjectName.csproj")

$ModuleId = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/PackageId'
$Version = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Version'
$ProjectUri = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/PackageProjectUrl'
$Description = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Description'
$Author = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Authors'
$Copyright = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Copyright'
$AssemblyName = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/AssemblyName'
$CompanyName = Get-SingleNodeValue $xmlDoc '/Project/PropertyGroup/Company'

$moduleSettings = @{
	Path = "$IntermediateOutputPath$ModuleId.psd1"
	RootModule = "$AssemblyName.dll"
	ModuleVersion = $Version
	Guid = '07e04d22-1389-4f44-b87a-2166e4bc7c4c'
	Author = $Author
	CompanyName = $CompanyName
	Copyright = $Copyright
	Description = $Description
	PowerShellVersion = $PowerShellVersion
	CompatiblePSEditions = @($compatiblePSEdition)
	FunctionsToExport = @()
	CmdletsToExport = @("New-$ProjectName")
	VariablesToExport = '*'
	AliasesToExport = @()
	ProjectUri = $ProjectUri
}

New-ModuleManifest @moduleSettings

Import-PowerShellDataFile -LiteralPath "$IntermediateOutputPath$ModuleId.psd1" | Export-PowerShellDataFile | Set-Content -LiteralPath "$PublishDir$ModuleId.psd1"

(Get-Content "../README.md")[0..2] | Set-Content -Path "$PublishDir/README.md"

If (-not($IsWindows))
{
	Get-ChildItem -Path $PublishDir -File | Foreach-Object {
		chmod -x $_.FullName
		If ( $LastExitCode -ne 0 )
		{
			Exit $LastExitCode
		}
	}
}

$LibDir = "$($PublishDir)lib"

if ( Test-Path $LibDir )
{
	Remove-Item -LiteralPath $LibDir -Recurse
}

$null = New-Item -Path $PublishDir -Name 'lib' -ItemType 'directory'

Get-ChildItem -LiteralPath $PublishDir -Filter '*.dll' | ForEach-Object {
	if ( $_.Name -ne  "$AssemblyName.dll" )
	{
		Move-Item $_.FullName $LibDir
	}
}

foreach ($Filter in '??','??-*') {
	Get-ChildItem -LiteralPath $PublishDir -Filter $Filter -Directory | ForEach-Object {
		Remove-Item $_.FullName -Recurse
	}
}

Get-ChildItem -LiteralPath "$PublishDir/runtimes" -Directory | ForEach-Object {
	$Runtime = $_.Name

	$null = New-Item -Path $LibDir -Name $Runtime -ItemType 'directory'

	Get-ChildItem -LiteralPath $_.FullName -Filter '*.dll' -Recurse | ForEach-Object {
		Move-Item $_.FullName "$LibDir/$Runtime"
	}
}

Remove-Item -LiteralPath  "$PublishDir/runtimes" -Recurse
