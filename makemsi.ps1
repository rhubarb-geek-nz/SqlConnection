#!/usr/bin/env pwsh
#
#  Copyright 2023, Roger Brown
#
#  This file is part of rhubarb-geek-nz/SqlConnection.
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
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

param(
	$ModuleName = "SqlConnection"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

trap
{
	throw $PSItem
}

$env:SOURCEDIR="$ModuleName"
$env:MSSQLVERS=( Import-PowerShellDataFile "$ModuleName/$ModuleName.psd1" ).ModuleVersion

foreach ($List in @(
	@("no","DA300855-1F8E-48B1-AD56-4E1E4DDA3AF2","netstandard2.0","x86","ProgramFilesFolder"),
	@("yes","8AC69EA5-1D5B-4EF6-B99A-14BB9504548F","netstandard2.0","x64","ProgramFiles64Folder")
))
{
	$env:MSSQLISWIN64=$List[0]
	$env:MSSQLUPGRADECODE=$List[1]
	$env:MSSQLFRAMEWORK=$List[2]
	$env:MSSQLPLATFORM=$List[3]
	$env:MSSQLPROGRAMFILES=$List[4]

	$MSINAME = "$ModuleName-$env:MSSQLVERS-$env:MSSQLPLATFORM.msi"

	foreach ($Name in "$MSINAME")
	{
		if (Test-Path "$Name")
		{
			Remove-Item "$Name"
		} 
	}

	& "${env:WIX}bin\candle.exe" -nologo "$ModuleName.wxs"

	if ($LastExitCode -ne 0)
	{
		exit $LastExitCode
	}

	& "${env:WIX}bin\light.exe" -nologo -cultures:null -out "$MSINAME" "$ModuleName.wixobj"

	if ($LastExitCode -ne 0)
	{
		exit $LastExitCode
	}
}
