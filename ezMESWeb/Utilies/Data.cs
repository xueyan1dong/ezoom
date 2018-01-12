using System;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Text;
using System.Configuration;
//using MySql.Data.MySqlClient;
using System.Data.Odbc;

namespace CommonLib.Data.EzSqlClient
{
     
    public enum DbConnectionType:byte
    {
        MySqlADO = 2,
        MySqlODBC =1,
        Unknown =0
    }

    public class EzSqlConnection:IDisposable 
    {
        private DbConnectionType _ezDbConnectionType;
        private string _ezDbConnectionString;
        private DbConnection _ezDbConnection;
        private bool _ezDisposed = false;

        public EzSqlConnection()
        {
            _ezDbConnectionType = DbConnectionType.Unknown; //default type
        }
        public EzSqlConnection (DbConnectionType myType)
        {
            _ezDbConnectionType = myType;
            switch (_ezDbConnectionType)
            {
                case DbConnectionType.MySqlADO:
                    _ezDbConnection = new MySql.Data.MySqlClient.MySqlConnection();

                    break;
                case DbConnectionType.MySqlODBC:
                    _ezDbConnection = new OdbcConnection();

                    break;
            }
        }
        public EzSqlConnection(DbConnectionType myType, string myConnectionString)
        {
            _ezDbConnectionType = myType;
            _ezDbConnectionString = myConnectionString;
            switch (_ezDbConnectionType)
            {
                case DbConnectionType.MySqlADO:
                  using(_ezDbConnection = new MySql.Data.MySqlClient.MySqlConnection(_ezDbConnectionString)) ;

                    break;
                case DbConnectionType.MySqlODBC:
                    _ezDbConnection = new OdbcConnection(_ezDbConnectionString);

                    break;
            }
            
        }

        ~EzSqlConnection()
        {
            Dispose(false);
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        private void Dispose(bool disposing)
        {
            if (!_ezDisposed)
            {
                if (disposing)
                {
                    if (_ezDbConnection != null)
                    {
                        if (_ezDbConnection.State == ConnectionState.Open)
                            _ezDbConnection.Close();
                        _ezDbConnection.Dispose();
                    }
                }
            }
            _ezDisposed = true;
        }


        public void Open()
        {

            _ezDbConnection.Open();
         
        }

        public void Close()
        {
            if (_ezDbConnection.State == ConnectionState.Open)
                _ezDbConnection.Close();
        }


        public DbConnectionType ConnectionType
        {
            get { return _ezDbConnectionType; }
            set { _ezDbConnectionType = value; }
        }
        public string ConnectionString
        {
            get { return _ezDbConnectionString; }
            set { 
                _ezDbConnectionString = value;
                _ezDbConnection.ConnectionString = value;   
            }
        }
        public ConnectionState State
        {
            get {
                if (_ezDbConnection == null)
                    throw new NullReferenceException("Connection is not initialized.") ;
                else
                {
                    return _ezDbConnection.State;
                }
                }

        }

        public DbConnection getDbConnection()
        {
            return _ezDbConnection;
        }

        
    }

    public class EzSqlParameter
    {
        private string _ezParameterName;
        private object _ezValue;
        private ParameterDirection _ezDirection;
        private int _ezParameterIndex;

        public string ParameterName
        {
            get { return _ezParameterName; }
            set { _ezParameterName = value; }
        }
        public object Value
        {
            get { return _ezValue; }
            set { _ezValue = value; }
        }
        public int ParameterIndex
        {
            get { return _ezParameterIndex; }
            set { _ezParameterIndex = value; }
        }
        public ParameterDirection Direction
        {
            get { return _ezDirection; }
            set { _ezDirection = value; }
        }
        public EzSqlParameter(string ParameterName, object Value)
        {
            _ezParameterName = ParameterName;
            _ezValue = Value;
            _ezDirection = ParameterDirection.Input;
            _ezParameterIndex = -1;
        }
        public EzSqlParameter(string ParameterName, object Value, ParameterDirection Direction)
        {
            _ezParameterName = ParameterName;
            _ezValue = Value;
            _ezDirection = Direction;
            _ezParameterIndex = -1;
        }

        public EzSqlParameter(string ParameterName, object Value, int ParameterIndex)
        {
            _ezParameterName = ParameterName;
            _ezValue = Value;
            _ezDirection = ParameterDirection.Input;
            _ezParameterIndex = ParameterIndex;
        }
        public EzSqlParameter(string ParameterName, object Value, ParameterDirection Direction, int ParameterIndex)
        {
            _ezParameterName = ParameterName;
            _ezValue = Value;
            _ezDirection = Direction;
            _ezParameterIndex = ParameterIndex;
        }

    }

    public class EzSqlParameterCollection
    {
        private List<EzSqlParameter> _parameters;
        public EzSqlParameterCollection()
        {
            _parameters = new List<EzSqlParameter>();
        }
        ~EzSqlParameterCollection()
        {
            _parameters.Clear();
            _parameters = null;
        }
        public EzSqlParameter this[int index]
        {
            get { return _parameters[index]; }
            set { _parameters[index] = value; }
        }
        public EzSqlParameter this[string ParameterName]
        {
            get
            {
                int i = 0;
                while (i < _parameters.Count)
                {
                    if (_parameters[i].ParameterName == ParameterName)
                        return _parameters[i];
                    i++;
                }
                throw new IndexOutOfRangeException("The parameter does not exist.");
            }
            set
            {
                int i = 0;
                while (i < _parameters.Count)
                {
                    if (_parameters[i].ParameterName == ParameterName)
                    {
                        _parameters[i] = value;
                        return;
                    }
                    i++;
                }
                throw new IndexOutOfRangeException("The parameter does not exist.");
            }
        }
        public int Count
        {
            get { return _parameters.Count; }
        }
        public EzSqlParameter AddWithValue(string ParameterName, object Value)
        {
            EzSqlParameter newPara = new EzSqlParameter(ParameterName, Value, _parameters.Count);
            _parameters.Add(newPara);
            return newPara;
        }
        public EzSqlParameter AddWithValue(string ParameterName, object Value, ParameterDirection Direction)
        {
            EzSqlParameter newPara = new EzSqlParameter(ParameterName, Value, Direction, _parameters.Count);
            _parameters.Add(newPara);
            return newPara;
        }
        public EzSqlParameter AddWithValue(string ParameterName, object Value, int ParameterIndex)
        {
            EzSqlParameter newPara = new EzSqlParameter(ParameterName, Value, ParameterIndex);
            _parameters.Add(newPara);
            return newPara;
        }
        public EzSqlParameter AddWithValue(string ParameterName, object Value, ParameterDirection Direction, int ParameterIndex)
        {
            EzSqlParameter newPara = new EzSqlParameter(ParameterName, Value, Direction, ParameterIndex);
            if (ParameterIndex < _parameters.Count)
                _parameters.Insert(ParameterIndex, newPara);
            else
                _parameters.Add(newPara);
            return newPara;
        }
        public void Sort()
        {
            EzSqlParameter tempPara;
            int paraCount = _parameters.Count;
            for (int i = 0; i < paraCount; i++)
            {
                if (_parameters[i].ParameterIndex != i)
                {
                    if (_parameters[i].ParameterIndex > paraCount)
                        throw new IndexOutOfRangeException("Parameters index is out of range.");
                    else
                    {
                        tempPara = _parameters[_parameters[i].ParameterIndex];
                        _parameters[_parameters[i].ParameterIndex] = _parameters[i];
                        _parameters[i] = tempPara;
                    }
                }
            }
        }

        public void Clear()
        {
            _parameters.Clear();
        }
    }
    public class EzSqlDataReader 
        //Not seeing the need for wrapping DbDataReader,
        //thus, this class is not used anywhere.
        //need to interface IDisposable
    {
        private DbDataReader _ezReader;
        private DbConnectionType _ezConnectionType;
        public EzSqlDataReader()
        {
            _ezConnectionType = DbConnectionType.Unknown;
            _ezReader = null;
        }
        public EzSqlDataReader(DbConnectionType myConnectionType, DbDataReader myDataReader )
        {
            _ezReader = myDataReader;
            _ezConnectionType = myConnectionType;
            
        }

        ~EzSqlDataReader()
        {
            _ezReader = null;
        }

        public object this[int index]
        {
           
            get 
            {
                return _ezReader[index];
            }
            
        }
        public bool Read()
        {
            return _ezReader.Read();
        }
        public void Close()
        {
            _ezReader.Close();
        }
    }

    public class ezDataAdapter:IDisposable
    {
        private DbConnectionType _ezConnectionType;
        private DbDataAdapter _ezAdapter;
        private EzSqlCommand _ezCommand;
        private bool _ezDisposed = false;

        public ezDataAdapter()
        {
            _ezConnectionType = DbConnectionType.Unknown;
            _ezAdapter = null;
            _ezCommand = null;
        }
        ~ezDataAdapter()
        {
            Dispose(false);
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        private void Dispose(bool disposing)
        {
            if (!_ezDisposed)
            {
                if (disposing)
                {
                    _ezAdapter.Dispose();
                }
                if (_ezCommand != null)
                    _ezCommand = null;
            }
            _ezDisposed = true;
        }
        public EzSqlCommand SelectCommand
        {
            get { return _ezCommand; }
            set
            {
                _ezCommand = value;
                //initialize _ezAdapter and _ezConnectionType
                if (_ezConnectionType == DbConnectionType.Unknown)
                {
                    _ezConnectionType = _ezCommand.Connection.ConnectionType;
                    switch (_ezConnectionType)
                    {
                        case DbConnectionType.MySqlADO:
                            _ezAdapter = new MySql.Data.MySqlClient.MySqlDataAdapter();
                            _ezAdapter.SelectCommand = _ezCommand.getDbCommand();
                        break;
                        case DbConnectionType.MySqlODBC:
                            _ezAdapter = new OdbcDataAdapter();
                            _ezAdapter.SelectCommand = _ezCommand.getDbCommand();
                        break;
                        case DbConnectionType.Unknown:
                            throw new NotSupportedException("The connection tyep is not supported.");
                        
                    }
                }
                else if (_ezConnectionType != _ezCommand.Connection.ConnectionType)
                {
                    throw new NotSupportedException("Change of connection type is not supported.");
                }
                else
                {
                    _ezAdapter.SelectCommand = _ezCommand.getDbCommand();
                }

                
            }
        }
        public int Fill(DataSet dataSet)
        {
          int rtv=_ezAdapter.Fill(dataSet);
            SelectCommand.FillOutputParaValue();
            return rtv;
        }
    }
    public class EzSqlCommand:IDisposable
    {
        DbCommand _ezCommand;
        private EzSqlConnection _ezConnection;
        private EzSqlParameterCollection _ezParameters;
        private CommandType _ezCommandType;
        private string _ezCommandText;
        private bool _ezDisposed;

        public EzSqlCommand()
        {
            _ezParameters = new EzSqlParameterCollection();
            _ezCommand = null;
            _ezConnection = null;
            _ezDisposed = false;
        }
        ~EzSqlCommand()
        {
            Dispose(false);
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        private void Dispose(bool disposing)
        {
            if (!_ezDisposed)
            {
                if (disposing)
                {
                    //managed resource
                    _ezParameters.Clear();
                    _ezParameters = null;
                    if (_ezCommand != null)
                        _ezCommand.Dispose();
                    
                }
                //unmanaged resource
                if (_ezConnection != null)
                _ezConnection = null;

            }
            _ezDisposed = true;
        }
        public CommandType CommandType
        {
            set { _ezCommandType = value; }
            get { return _ezCommandType;}
        }
        public string CommandText
        {
            set { _ezCommandText = value; }
            get { return _ezCommandText; }
        }
        public EzSqlConnection Connection
        {
            set { _ezConnection = value; }
            get { return _ezConnection; }
        }
        public EzSqlParameterCollection Parameters
        {
            get { return _ezParameters; }
        }

        public DbCommand getDbCommand()
        {
            if (_ezConnection != null)
            {
                InitCommand();
                return _ezCommand;
            }
            else
                throw new NullReferenceException("No database connection available.");
        }
        private void InitCommand()
        {
            int i = 0;
            EzSqlParameter thePara;
            //call function makes sure _ezConnection is initialized.

         
            switch (_ezConnection.ConnectionType)
            {
                case DbConnectionType.MySqlADO:
                    _ezCommand = new MySql.Data.MySqlClient.MySqlCommand();
                    _ezCommand.Connection = (MySql.Data.MySqlClient.MySqlConnection)_ezConnection.getDbConnection();
                    _ezCommand.CommandText = _ezCommandText;
                    _ezCommand.CommandType = _ezCommandType;
               

                    MySql.Data.MySqlClient.MySqlParameter myPara;
                    i = 0;
                    while (i < _ezParameters.Count)
                    {
                        thePara = _ezParameters[i];
                        myPara = ((MySql.Data.MySqlClient.MySqlCommand)_ezCommand).Parameters.AddWithValue(thePara.ParameterName, thePara.Value);
                        myPara.Direction = thePara.Direction;
                        i++;
                    }
                    break;

                case DbConnectionType.MySqlODBC:

                    _ezCommand = new OdbcCommand();
                    _ezCommand.Connection =
                        (OdbcConnection)_ezConnection.getDbConnection();
                    _ezParameters.Sort();
                    SetInputOutputParaForODBC();
                    _ezCommand.CommandType = CommandType.StoredProcedure;
                    if (_ezCommandType == CommandType.Text)
                        _ezCommand.CommandText = _ezCommandText;
                    else
                    {
                        _ezCommand.CommandText = "{call " + _ezCommandText + "(";
                        if (_ezParameters.Count > 0)
                        {
                            i = 0;
                            while (i < _ezParameters.Count - 1)
                            {
                                if (_ezParameters[i].Direction == ParameterDirection.Input)
                                    _ezCommand.CommandText += "?,";
                                else
                                    _ezCommand.CommandText += _ezParameters[i].ParameterName + ",";
                                i++;
                            }
                            if (_ezParameters[i].Direction == ParameterDirection.Input)
                                _ezCommand.CommandText += "?";
                            else
                                _ezCommand.CommandText += _ezParameters[i].ParameterName;
                        }
                        _ezCommand.CommandText += ")}";
                    }

                    OdbcParameter odbcPara;
                    i = 0;
                    while (i < _ezParameters.Count)
                    {
                        thePara = _ezParameters[i];
                        if (thePara.Direction == ParameterDirection.Input )
                            odbcPara = ((OdbcCommand)_ezCommand).Parameters.AddWithValue(thePara.ParameterName, thePara.Value);
                        i++;
                    }
                    break;

            }

        }
        public void FillOutputParaValue()
        {
            int i = 0;

            EzSqlParameter thePara;
            //call function need to check _ezConnection is initialized
            object result;
            System.Text.ASCIIEncoding asi;
            switch (_ezConnection.ConnectionType)
            {
                case DbConnectionType.MySqlADO:

                    i = 0;
                    while (i < _ezParameters.Count)
                    {
                        thePara = _ezParameters[i];
                        if (thePara.Direction == ParameterDirection.Output ||
                            thePara.Direction == ParameterDirection.InputOutput)
                        {
 
                            thePara.Value = _ezCommand.Parameters[thePara.ParameterName].Value;

                        }
                        i++;
                    }
                    break;

                case DbConnectionType.MySqlODBC:

                    i = 0;
                    while (i < _ezParameters.Count)
                    {
                        thePara = _ezParameters[i];
                        if (thePara.Direction == ParameterDirection.Output ||
                            thePara.Direction == ParameterDirection.InputOutput)
                        {
                            _ezCommand.CommandType = CommandType.Text;
                            _ezCommand.CommandText = "select " + thePara.ParameterName;
                            //thePara.Value = _ezCommand.ExecuteScalar();
                            result = _ezCommand.ExecuteScalar();

                            //this is to deal with MySql5.0 and odbc driver 3.5.1 return system.byte[]
                            //sometimes for integer or decimal type parameters.
                            if (result.GetType().ToString().Contains("System.Byte"))
                            {
                              asi = new System.Text.ASCIIEncoding();
                              thePara.Value = asi.GetString((byte[])result);
                            }
                            else
                              thePara.Value = result;
                        }
                        i++;
                    }
                    break;

            }

        }
        private void SetInputOutputParaForODBC()
        {
            EzSqlParameter thePara;
            int i;
            if (_ezConnection.ConnectionType == DbConnectionType.MySqlODBC)
            {
                i = 0;
                while (i < _ezParameters.Count)
                {
                    thePara = _ezParameters[i];
                    if (thePara.Direction == ParameterDirection.InputOutput)
                    {

                        _ezCommand.CommandType = CommandType.Text;
                        _ezCommand.CommandText = "set " + thePara.ParameterName + "= " + ((thePara.Value==DBNull.Value) ? "null" : ("'"+thePara.Value+"'"));
                         _ezCommand.ExecuteNonQuery();
                    }
                    i++;
                }
            }
 
        }
        public int ExecuteNonQuery()
        {

            int rows = 0;

            if (_ezConnection != null)
            {
                
                InitCommand();
                rows = _ezCommand.ExecuteNonQuery();
                FillOutputParaValue();
                _ezCommand.Dispose();
                return rows;
            }
            else
                throw new NullReferenceException("No database connection available.");
        }
        public DbDataReader ExecuteReader()
        {

            if (_ezConnection != null)
            {
                InitCommand();
                DbDataReader myReader = _ezCommand.ExecuteReader();
                FillOutputParaValue();
                _ezCommand.Dispose();
                return myReader;
            }
            else
                throw new NullReferenceException("No database connection available.");

        }
        public object ExecuteScalar()
        {
            if (_ezConnection != null)
            {
                InitCommand();
                Object myObject = _ezCommand.ExecuteScalar();
                FillOutputParaValue();
                _ezCommand.Dispose();
                return myObject;
            }
            throw new NullReferenceException("No database connection available.");
        }
        
    }


      
   }

   
