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

param(
	$ConnectionString = 'Data Source=10.1.2.12;Integrated Security=False;Persist Security Info=False;User ID=sa;Password=changeit',
	$CommandText = 'SELECT @@VERSION AS VERSION'
)

$ErrorActionPreference = "Stop"

trap
{
	throw $PSItem
}

$Connection = New-SqlConnection -ConnectionString $ConnectionString

try
{
	$Connection.Open()

	$Command = $Connection.CreateCommand()

	$Command.CommandText = $CommandText

	$Reader = $Command.ExecuteReader()

	try
	{
		$DataTable = New-Object System.Data.DataTable

		$DataTable.Load($Reader)

		$DataTable | Format-Table
	}
	finally
	{
		$Reader.Dispose()
	}
}
finally
{
	$Connection.Dispose()
}
