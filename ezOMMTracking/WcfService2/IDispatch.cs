using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace ezOMMServer
{
    // Defines IStudentService here
    [ServiceContract ]
    public interface IDispatchService
    {

        // Define the GetStudentInfo OperationContact here….
        [OperationContract]
        LotInformation GetLotInfo(string lotalias);

        [OperationContract]
        string test();

    }


    // Use a data contract as illustrated in the sample below to add composite types to service operations.
    [DataContract]
    public class LotInformation
    {
        int _lotId ;
        string _lotAlias;
        string _status;
        decimal _curQuantity;
        int _uomId;
        string _uomName;
        int _contactId;
        string _contactName;
        int _priorityId;
        string _priorityName;
        int _processId;
        string _processName;
        string _lastSubProcessId;
        string _lastSubProcessName;
        string _lastPositionId;
        string _lastSubPositionId;
        string _lastStepId;
        string _lastStepName;
        string _lastEqId;
        string _lastEqName;
        string _nextSubProcessId;
        string _nextSubProcessName;
        string _nextPositionId;
        string _nextSubPositionId;
        string _nextStepId;
        string _nextStepName;
        string _nextEqUsage;
        string _nextEqId;
        string _nextEqName;
        string _comment;

        public LotInformation(object[] values)
        {
            _lotId = Convert.ToInt32(values[0]);
            _lotAlias = Convert.ToString(values[1]);
            _status = Convert.ToString(values[2]);
            _curQuantity=Convert.ToDecimal(values[3]);
            _uomId = Convert.ToInt32(values[4]);
            _uomName = Convert.ToString(values[5]);
            Int32.TryParse(Convert.ToString(values[6]), out _contactId);
            _contactName = Convert.ToString(values[7]);
            Int32.TryParse(Convert.ToString(values[8]), out _priorityId);
            _priorityName = Convert.ToString(values[9]);
            Int32.TryParse(Convert.ToString(values[10]), out _processId);
            _processName = Convert.ToString(values[11]);
            _lastSubProcessId=Convert.ToString(values[12]);
            _lastSubProcessName = Convert.ToString(values[13]);
            _lastPositionId = Convert.ToString(values[14]);
            _lastSubPositionId = Convert.ToString(values[15]);
            _lastStepId = Convert.ToString(values[16]);
            _lastStepName = Convert.ToString(values[17]);
            _lastEqId = Convert.ToString(values[18]);
            _lastEqName = Convert.ToString(values[19]);
            _nextSubProcessId = Convert.ToString(values[20]);
            _nextSubProcessName = Convert.ToString(values[21]);
            _nextPositionId = Convert.ToString(values[22]);
            _nextSubPositionId = Convert.ToString(values[23]);
            _nextStepId = Convert.ToString(values[24]);
            _nextStepName = Convert.ToString(values[25]);
            _nextEqUsage = Convert.ToString(values[26]);
            _nextEqId = Convert.ToString(values[27]);
            _nextEqName = Convert.ToString(values[28]);
            _comment = Convert.ToString(values[29]);
        }

        [DataMember]
        public int LotId
        {
            get { return _lotId; }
            set { _lotId = value; }
        }

        [DataMember]
        public string LotAlias
        {
            get { return _lotAlias; }
            set { _lotAlias = value; }
        }

        [DataMember]
        public string Status
        {
            get { return _status; }
            set { _status = value; }
        }
        [DataMember]
        public decimal CurQuantity
        {
            get { return _curQuantity; }
            set { _curQuantity = value; }
        }
        [DataMember]
        public int UomId
        {
            get { return _uomId; }
            set { _uomId = value; }
        }
        [DataMember]
        public string UomName
        {
            get { return _uomName; }
            set { _uomName = value; }
        }
        [DataMember]
        public int ContactEmployeeId
        {
            get { return _contactId; }
            set { _contactId = value; }
        }
        [DataMember]
        public string ContactEmployeeName
        {
            get { return _contactName; }
            set { _contactName = value; }
        }
        [DataMember]
        public int PriorityId
        {
            get { return _priorityId; }
            set { _priorityId = value; }
        }
        [DataMember]
        public string PriorityName
        {
            get { return _priorityName; }
            set { _priorityName = value; }
        }
        [DataMember]
        public int ProcessId
        {
            get { return _processId; }
            set { _processId = value; }
        }
        [DataMember]
        public string ProcessName
        {
            get { return _processName; }
            set { _processName = value; }
        }
        [DataMember]
        public string LastSubProcessId
        {
            get { return _lastSubProcessId; }
            set { _lastSubProcessId = value; }
        }
        [DataMember]
        public string LastSubProcessName
        {
            get { return _lastSubProcessName; }
            set { _lastSubProcessName = value; }
        }
        [DataMember]
        public string LastPositionId
        {
            get { return _lastPositionId; }
            set { _lastPositionId = value; }
        }
        [DataMember]
        public string LastSubPositionId
        {
            get { return _lastSubPositionId; }
            set { _lastSubPositionId = value; }
        }
        [DataMember]
        public string LastStepId
        {
            get { return _lastStepId; }
            set { _lastStepId = value; }
        }
        [DataMember]
        public string LastStepName
        {
            get { return _lastStepName; }
            set { _lastStepName = value; }
        }
        [DataMember]
        public string LastEquipmentId
        {
            get { return _lastEqId; }
            set { _lastEqId = value; }
        }
        [DataMember]
        public string LastEquipmentName
        {
            get { return _lastEqName; }
            set { _lastEqName = value; }
        }
        [DataMember]
        public string NextSubProcessId
        {
            get { return _nextSubProcessId; }
            set { _nextSubProcessId = value; }
        }
        [DataMember]
        public string NextSubProcessName
        {
            get { return _nextSubProcessName; }
            set { _nextSubProcessName = value; }
        }
        [DataMember]
        public string NextPositionId
        {
            get { return _nextPositionId; }
            set { _nextPositionId = value; }
        }
        [DataMember]
        public string NextSubPositionId
        {
            get { return _nextSubPositionId; }
            set { _nextSubPositionId = value; }
        }
        [DataMember]
        public string NextStepId
        {
            get { return _nextStepId; }
            set { _nextStepId = value; }
        }
        [DataMember]
        public string NextStepName
        {
            get { return _nextStepName; }
            set { _nextStepName = value; }
        }
        [DataMember]
        public string NextEquipmentUsage
        {
            get { return _nextEqUsage; }
            set { _nextEqUsage = value; }
        }
        [DataMember]
        public string NextEquipmentId
        {
            get { return _nextEqId; }
            set { _nextEqId = value; }
        }
        [DataMember]
        public string NextEquipmentName
        {
            get { return _nextEqName; }
            set { _nextEqName = value; }
        }
        [DataMember]
        public string Comment
        {
            get { return _comment; }
            set { _comment = value; }
        }
    }
}
