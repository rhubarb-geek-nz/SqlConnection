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
$Version = "1.0"
$ModuleName = "SqlConnection"
$ZipName ="$ModuleName-$Version.zip"

trap
{
	throw $PSItem
}

foreach ($Name in "$ModuleName", "$ZipName")
{
	if (Test-Path "$Name")
	{
		Remove-Item "$Name" -Force -Recurse
	} 
}

$null = New-Item -Path "$ModuleName" -ItemType Directory

Copy-Item -Path "$ModuleName.psm1" -Destination "$ModuleName"

@"
@{
	RootModule = '$ModuleName.psm1'
	ModuleVersion = '$Version'
	GUID = '07e04d22-1389-4f44-b87a-2166e4bc7c4c'
	Author = 'Roger Brown'
	CompanyName = 'rhubarb-geek-nz'
	Copyright = '(c) Roger Brown. All rights reserved.'
	FunctionsToExport = @('New-$ModuleName')
	CmdletsToExport = @()
	VariablesToExport = '*'
	AliasesToExport = @()
	PrivateData = @{
		PSData = @{
		}
	}
}
"@ | Set-Content -Path "$ModuleName/$ModuleName.psd1"

$content = [System.IO.File]::ReadAllText("LICENSE")

$content.Replace("`u{000D}`u{000A}","`u{000A}") | Out-File "$ModuleName/LICENSE" -Encoding Ascii -NoNewLine

Compress-Archive -Path "$ModuleName" -DestinationPath "$ZipName"
