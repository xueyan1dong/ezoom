using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Configuration;
//using MySql.Data.MySqlClient;
using System.Data;
using CommonLib.Data.EzSqlClient;

namespace ezOMMServer
{
    // StudentService is the concrete implmentation of IStudentService.
    public class DispatchService : IDispatchService
    {
        EzSqlConnection ezConn;
        EzSqlCommand ezCmd;
        
         

        // Create  list of students
        public DispatchService()
        {
            //Students.Add(new StudentInformation(1001, "Nikhil", "Vinod"));
            //Students.Add(new StudentInformation(1002, "Joshua", "Hunter"));
            //Students.Add(new StudentInformation(1003, "David", "Sam"));
            //Students.Add(new StudentInformation(1004, "Adarsh", "Manoj"));
            //Students.Add(new StudentInformation(1005, "HariKrishnan", "Vinayan"));
        }

        public string test()
        {
          return "yes";
        }

        // Method returning the details of the student for the studentId
        public LotInformation GetLotInfo(string lotalias)
        {
          System.Data.Common.DbDataReader sqlReader;
            //object response;
            object[] values = new object[30];

            //string lotalias = "";
            //sqlConn = new MySqlConnection("server=localhost;user id=root;Password=meslady;persist security info=True;database=ezmes");
            //sqlConn.Open();
            //sqlCmd = new MySqlCommand();
            //sqlCmd.Connection = sqlConn;
            //sqlCmd.CommandType = CommandType.StoredProcedure;
            //sqlCmd.CommandText = "select_lot_info_for_start_step";

            //sqlCmd.Parameters.AddWithValue("@_lot_id", null);

            //sqlCmd.Parameters.AddWithValue("@_lot_alias", (lotalias.Length > 0) ? lotalias : null);
            //sqlCmd.Parameters.Add("@_response", MySql.Data.MySqlClient.MySqlDbType.VarChar, 255);
            //sqlCmd.Parameters["@_response"].Direction = ParameterDirection.Output;
            //sqlReader = sqlCmd.ExecuteReader();
            //response = sqlCmd.Parameters["@_response"].Value;
            try
            {
              string dbConnKey = ConfigurationManager.AppSettings.Get("DatabaseType");
              string connStr = ConfigurationManager.ConnectionStrings["ezmesConnectionString"].ConnectionString; ;
              DbConnectionType ezType;

              if (dbConnKey.Equals("ODBC"))
              {
                ezType = DbConnectionType.MySqlODBC;

              }
              else if (dbConnKey.Equals("MySql"))
              {
                //ezType = DbConnectionType.MySql;
                ezType = DbConnectionType.MySqlADO;
              }
              else
                ezType = DbConnectionType.Unknown;

              if (ezConn == null)
                ezConn = new EzSqlConnection(ezType, connStr);
              if (ezConn.State != ConnectionState.Open)
                ezConn.Open();
              ezCmd = new EzSqlCommand();
              ezCmd.Connection = ezConn;
              ezCmd.CommandType = CommandType.StoredProcedure;
              ezCmd.CommandText = "select_lot_info_for_start_step";

              ezCmd.Parameters.AddWithValue("@_lot_id", DBNull.Value);

              if (lotalias.Length > 0)
                ezCmd.Parameters.AddWithValue("@_lot_alias", lotalias);
              else
                ezCmd.Parameters.AddWithValue("@_lot_alias", DBNull.Value);
              //ezCmd.Parameters.AddWithValue("@_response", DBNull.Value,ParameterDirection.Output);


              sqlReader = ezCmd.ExecuteReader();


              if (sqlReader.Read())
              {
                sqlReader.GetValues(values);


              }
              sqlReader.Close();

              sqlReader.Dispose();
              //response = ezCmd.Parameters["@_response"].Value;
              ezCmd.Dispose();
              ezConn.Dispose();
            }
            catch (Exception ex)
            {
              values[0] = 0;
              values[4] = 0;
              values[5] = "error:" + ex.Message;
            }
            return new LotInformation(values);
            //if (studentId == 1001)
            //    return new StudentInformation(1001, "Nikhil", "Vinod");
            //else if (studentId == 1002)
            //    return new StudentInformation(1002, "Susan", "Dong");
            //return new StudentInformation(1003, "Weimin", "Li");
        }


    }
}
