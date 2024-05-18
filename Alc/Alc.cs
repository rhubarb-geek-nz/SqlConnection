// Copyright (c) 2024 Roger Brown.
// Licensed under the MIT License.

namespace RhubarbGeekNz.SqlConnection
{
    public class SqlConnectionFactory
    {
        static public System.Data.Common.DbConnection CreateInstance(string ConnectionString)
        {
            return new Microsoft.Data.SqlClient.SqlConnection(ConnectionString);
        }
    }
}
