#!/usr/bin/env pwsh
# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

param(
	$ConnectionString = 'Data Source=localhost;Integrated Security=False;Persist Security Info=False;User ID=sa;Password=changeit;TrustServerCertificate=True',
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
