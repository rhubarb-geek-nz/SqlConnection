#!/usr/bin/env pwsh
#
#  Copyright 2023, Roger Brown
#
#  This file is part of rhubarb-geek-nz/SqlConnection.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$ModuleName = "SqlConnection"

$xmlDoc = [System.Xml.XmlDocument](Get-Content "$ModuleName.nuspec")

$Version = $xmlDoc.SelectSingleNode("/package/metadata/version").FirstChild.Value
$CompanyName = $xmlDoc.SelectSingleNode("/package/metadata/authors").FirstChild.Value
$ModuleId = $xmlDoc.SelectSingleNode("/package/metadata/id").FirstChild.Value

trap
{
	throw $PSItem
}

foreach ($Name in "$ModuleId")
{
	if (Test-Path "$Name")
	{
		Remove-Item "$Name" -Force -Recurse
	} 
}

$null = New-Item -Path "$ModuleId" -ItemType Directory

Copy-Item -Path "$ModuleName.psm1" -Destination "$ModuleId"

@"
@{
	RootModule = '$ModuleName.psm1'
	ModuleVersion = '$Version'
	GUID = '07e04d22-1389-4f44-b87a-2166e4bc7c4c'
	Author = 'Roger Brown'
	CompanyName = '$CompanyName'
	Copyright = '(c) Roger Brown. All rights reserved.'
	FunctionsToExport = @('New-SqlConnection')
	CmdletsToExport = @()
	VariablesToExport = '*'
	AliasesToExport = @()
	PrivateData = @{
		PSData = @{
		}
	}
}
"@ | Set-Content -Path "$ModuleId/$ModuleId.psd1"

(Get-Content "./README.md")[0..2] | Set-Content -Path "$ModuleId/README.md"

nuget pack "$ModuleName.nuspec"

If ( $LastExitCode -ne 0 )
{
	Exit $LastExitCode
}
