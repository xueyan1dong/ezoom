﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.4206
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ezOMMClient.DispatchServiceReference {
    using System.Runtime.Serialization;
    using System;
    
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Runtime.Serialization", "3.0.0.0")]
    [System.Runtime.Serialization.DataContractAttribute(Name="LotInformation", Namespace="http://schemas.datacontract.org/2004/07/ezOMMServer")]
    [System.SerializableAttribute()]
    public partial class LotInformation : object, System.Runtime.Serialization.IExtensibleDataObject, System.ComponentModel.INotifyPropertyChanged {
        
        [System.NonSerializedAttribute()]
        private System.Runtime.Serialization.ExtensionDataObject extensionDataField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string CommentField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int ContactEmployeeIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ContactEmployeeNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private decimal CurQuantityField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastEquipmentIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastEquipmentNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastPositionIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastStepIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastStepNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastSubPositionIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastSubProcessIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LastSubProcessNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string LotAliasField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int LotIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextEquipmentIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextEquipmentNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextEquipmentUsageField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextPositionIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextStepIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextStepNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextSubPositionIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextSubProcessIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string NextSubProcessNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int PriorityIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string PriorityNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int ProcessIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string ProcessNameField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string StatusField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private int UomIdField;
        
        [System.Runtime.Serialization.OptionalFieldAttribute()]
        private string UomNameField;
        
        [global::System.ComponentModel.BrowsableAttribute(false)]
        public System.Runtime.Serialization.ExtensionDataObject ExtensionData {
            get {
                return this.extensionDataField;
            }
            set {
                this.extensionDataField = value;
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Comment {
            get {
                return this.CommentField;
            }
            set {
                if ((object.ReferenceEquals(this.CommentField, value) != true)) {
                    this.CommentField = value;
                    this.RaisePropertyChanged("Comment");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int ContactEmployeeId {
            get {
                return this.ContactEmployeeIdField;
            }
            set {
                if ((this.ContactEmployeeIdField.Equals(value) != true)) {
                    this.ContactEmployeeIdField = value;
                    this.RaisePropertyChanged("ContactEmployeeId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string ContactEmployeeName {
            get {
                return this.ContactEmployeeNameField;
            }
            set {
                if ((object.ReferenceEquals(this.ContactEmployeeNameField, value) != true)) {
                    this.ContactEmployeeNameField = value;
                    this.RaisePropertyChanged("ContactEmployeeName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public decimal CurQuantity {
            get {
                return this.CurQuantityField;
            }
            set {
                if ((this.CurQuantityField.Equals(value) != true)) {
                    this.CurQuantityField = value;
                    this.RaisePropertyChanged("CurQuantity");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastEquipmentId {
            get {
                return this.LastEquipmentIdField;
            }
            set {
                if ((object.ReferenceEquals(this.LastEquipmentIdField, value) != true)) {
                    this.LastEquipmentIdField = value;
                    this.RaisePropertyChanged("LastEquipmentId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastEquipmentName {
            get {
                return this.LastEquipmentNameField;
            }
            set {
                if ((object.ReferenceEquals(this.LastEquipmentNameField, value) != true)) {
                    this.LastEquipmentNameField = value;
                    this.RaisePropertyChanged("LastEquipmentName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastPositionId {
            get {
                return this.LastPositionIdField;
            }
            set {
                if ((object.ReferenceEquals(this.LastPositionIdField, value) != true)) {
                    this.LastPositionIdField = value;
                    this.RaisePropertyChanged("LastPositionId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastStepId {
            get {
                return this.LastStepIdField;
            }
            set {
                if ((object.ReferenceEquals(this.LastStepIdField, value) != true)) {
                    this.LastStepIdField = value;
                    this.RaisePropertyChanged("LastStepId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastStepName {
            get {
                return this.LastStepNameField;
            }
            set {
                if ((object.ReferenceEquals(this.LastStepNameField, value) != true)) {
                    this.LastStepNameField = value;
                    this.RaisePropertyChanged("LastStepName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastSubPositionId {
            get {
                return this.LastSubPositionIdField;
            }
            set {
                if ((object.ReferenceEquals(this.LastSubPositionIdField, value) != true)) {
                    this.LastSubPositionIdField = value;
                    this.RaisePropertyChanged("LastSubPositionId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastSubProcessId {
            get {
                return this.LastSubProcessIdField;
            }
            set {
                if ((object.ReferenceEquals(this.LastSubProcessIdField, value) != true)) {
                    this.LastSubProcessIdField = value;
                    this.RaisePropertyChanged("LastSubProcessId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LastSubProcessName {
            get {
                return this.LastSubProcessNameField;
            }
            set {
                if ((object.ReferenceEquals(this.LastSubProcessNameField, value) != true)) {
                    this.LastSubProcessNameField = value;
                    this.RaisePropertyChanged("LastSubProcessName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string LotAlias {
            get {
                return this.LotAliasField;
            }
            set {
                if ((object.ReferenceEquals(this.LotAliasField, value) != true)) {
                    this.LotAliasField = value;
                    this.RaisePropertyChanged("LotAlias");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int LotId {
            get {
                return this.LotIdField;
            }
            set {
                if ((this.LotIdField.Equals(value) != true)) {
                    this.LotIdField = value;
                    this.RaisePropertyChanged("LotId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextEquipmentId {
            get {
                return this.NextEquipmentIdField;
            }
            set {
                if ((object.ReferenceEquals(this.NextEquipmentIdField, value) != true)) {
                    this.NextEquipmentIdField = value;
                    this.RaisePropertyChanged("NextEquipmentId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextEquipmentName {
            get {
                return this.NextEquipmentNameField;
            }
            set {
                if ((object.ReferenceEquals(this.NextEquipmentNameField, value) != true)) {
                    this.NextEquipmentNameField = value;
                    this.RaisePropertyChanged("NextEquipmentName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextEquipmentUsage {
            get {
                return this.NextEquipmentUsageField;
            }
            set {
                if ((object.ReferenceEquals(this.NextEquipmentUsageField, value) != true)) {
                    this.NextEquipmentUsageField = value;
                    this.RaisePropertyChanged("NextEquipmentUsage");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextPositionId {
            get {
                return this.NextPositionIdField;
            }
            set {
                if ((object.ReferenceEquals(this.NextPositionIdField, value) != true)) {
                    this.NextPositionIdField = value;
                    this.RaisePropertyChanged("NextPositionId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextStepId {
            get {
                return this.NextStepIdField;
            }
            set {
                if ((object.ReferenceEquals(this.NextStepIdField, value) != true)) {
                    this.NextStepIdField = value;
                    this.RaisePropertyChanged("NextStepId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextStepName {
            get {
                return this.NextStepNameField;
            }
            set {
                if ((object.ReferenceEquals(this.NextStepNameField, value) != true)) {
                    this.NextStepNameField = value;
                    this.RaisePropertyChanged("NextStepName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextSubPositionId {
            get {
                return this.NextSubPositionIdField;
            }
            set {
                if ((object.ReferenceEquals(this.NextSubPositionIdField, value) != true)) {
                    this.NextSubPositionIdField = value;
                    this.RaisePropertyChanged("NextSubPositionId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextSubProcessId {
            get {
                return this.NextSubProcessIdField;
            }
            set {
                if ((object.ReferenceEquals(this.NextSubProcessIdField, value) != true)) {
                    this.NextSubProcessIdField = value;
                    this.RaisePropertyChanged("NextSubProcessId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string NextSubProcessName {
            get {
                return this.NextSubProcessNameField;
            }
            set {
                if ((object.ReferenceEquals(this.NextSubProcessNameField, value) != true)) {
                    this.NextSubProcessNameField = value;
                    this.RaisePropertyChanged("NextSubProcessName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int PriorityId {
            get {
                return this.PriorityIdField;
            }
            set {
                if ((this.PriorityIdField.Equals(value) != true)) {
                    this.PriorityIdField = value;
                    this.RaisePropertyChanged("PriorityId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string PriorityName {
            get {
                return this.PriorityNameField;
            }
            set {
                if ((object.ReferenceEquals(this.PriorityNameField, value) != true)) {
                    this.PriorityNameField = value;
                    this.RaisePropertyChanged("PriorityName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int ProcessId {
            get {
                return this.ProcessIdField;
            }
            set {
                if ((this.ProcessIdField.Equals(value) != true)) {
                    this.ProcessIdField = value;
                    this.RaisePropertyChanged("ProcessId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string ProcessName {
            get {
                return this.ProcessNameField;
            }
            set {
                if ((object.ReferenceEquals(this.ProcessNameField, value) != true)) {
                    this.ProcessNameField = value;
                    this.RaisePropertyChanged("ProcessName");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string Status {
            get {
                return this.StatusField;
            }
            set {
                if ((object.ReferenceEquals(this.StatusField, value) != true)) {
                    this.StatusField = value;
                    this.RaisePropertyChanged("Status");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public int UomId {
            get {
                return this.UomIdField;
            }
            set {
                if ((this.UomIdField.Equals(value) != true)) {
                    this.UomIdField = value;
                    this.RaisePropertyChanged("UomId");
                }
            }
        }
        
        [System.Runtime.Serialization.DataMemberAttribute()]
        public string UomName {
            get {
                return this.UomNameField;
            }
            set {
                if ((object.ReferenceEquals(this.UomNameField, value) != true)) {
                    this.UomNameField = value;
                    this.RaisePropertyChanged("UomName");
                }
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(ConfigurationName="DispatchServiceReference.IDispatchService")]
    public interface IDispatchService {
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDispatchService/GetLotInfo", ReplyAction="http://tempuri.org/IDispatchService/GetLotInfoResponse")]
        ezOMMClient.DispatchServiceReference.LotInformation GetLotInfo(string lotalias);
        
        [System.ServiceModel.OperationContractAttribute(Action="http://tempuri.org/IDispatchService/test", ReplyAction="http://tempuri.org/IDispatchService/testResponse")]
        string test();
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
    public interface IDispatchServiceChannel : ezOMMClient.DispatchServiceReference.IDispatchService, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "3.0.0.0")]
    public partial class DispatchServiceClient : System.ServiceModel.ClientBase<ezOMMClient.DispatchServiceReference.IDispatchService>, ezOMMClient.DispatchServiceReference.IDispatchService {
        
        public DispatchServiceClient() {
        }
        
        public DispatchServiceClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public DispatchServiceClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public DispatchServiceClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public DispatchServiceClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        public ezOMMClient.DispatchServiceReference.LotInformation GetLotInfo(string lotalias) {
            return base.Channel.GetLotInfo(lotalias);
        }
        
        public string test() {
            return base.Channel.test();
        }
    }
}
