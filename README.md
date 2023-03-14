# SqlConnection

Very simple `PowerShell` module for creating a connection to an `MSSQL` database.

Build using the `package.ps1` script to create the `SqlConnection.zip` file.

Install by unzipping into a directory on the [PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

Create a test database.

```
$ docker run --env "ACCEPT_EULA=Y" --env "SA_PASSWORD=changeit" --env "MSSQL_PID=Express" --publish 1433:1433 --detach --name=mssql mcr.microsoft.com/mssql/server:latest
```

Run the `test.ps1` to confirm it works.

```

VERSION
-------
Microsoft SQL Server 2022 (RTM) - 16.0.1000.6 (X64) …

```
The following scripts can be used to make formal packages for specific RID.

| Script | RID | Installation Directory |
| ------ | --- | ---------------------- |
| makemsi.ps1 | win | c:\Program Files\WindowsPowerShell\Modules\SqlConnection |
| makeosx.ps1 | osx | /usr/local/share/powershell/Modules/SqlConnection |
| makedeb.ps1 | linux | /opt/microsoft/powershell/7/Modules/SqlConnection |
| makerpm.ps1 | linux | /opt/microsoft/powershell/7/Modules/SqlConnection |
