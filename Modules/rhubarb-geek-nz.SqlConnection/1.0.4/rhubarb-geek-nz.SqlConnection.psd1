@{
	RootModule = 'SqlConnection.psm1'
	ModuleVersion = '1.0.4'
	GUID = '07e04d22-1389-4f44-b87a-2166e4bc7c4c'
	Author = 'Roger Brown'
	CompanyName = 'rhubarb-geek-nz'
	Copyright = '2023'
	Description = 'MSSQL Connection Tool'
	FunctionsToExport = @('New-SqlConnection')
	CmdletsToExport = @()
	VariablesToExport = '*'
	AliasesToExport = @()
	PrivateData = @{
		PSData = @{
			ProjectUri = 'https://github.com/rhubarb-geek-nz/SqlConnection'
		}
	}
}
