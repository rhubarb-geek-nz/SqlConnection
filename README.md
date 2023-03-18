# SqlConnection

Very simple `PowerShell` module for creating a connection to an `MSSQL` database.

Build using the `package.ps1` script to create the module.

Install by copying into a directory on the [PSModulePath](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

Create a test database.

```
$ docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=changeit" -e "MSSQL_PID=Express" -p 1433:1433 mcr.microsoft.com/mssql/server:latest
```

Run the `test.ps1` to confirm it works.

```

VERSION
-------
Microsoft SQL Server 2022 (RTM) - 16.0.1000.6 (X64) …

```
