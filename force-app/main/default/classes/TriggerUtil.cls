public inherited sharing class TriggerUtil {
    @TestVisible
    private DescribeSObjectResult sObjectDescribe;
    @TestVisible
    private Map<Id, SObject> newMap;
    @TestVisible
    private Map<Id, SObject> oldMap;
    @TestVisible
    private Boolean isInsert;
    @TestVisible
    private Boolean isDelete;
    @TestVisible
    private Boolean isUndelete;

    public TriggerUtil(BaseTriggerHandler triggerHandler) {
        this.sObjectDescribe = triggerHandler.sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED);
        this.newMap = triggerHandler.newMap;
        this.oldMap = triggerHandler.oldMap;
        this.isInsert = triggerHandler.isInsert;
        this.isDelete = triggerHandler.isDelete;
        this.isUndelete = triggerHandler.isUndelete;
    }

    public Set<Id> getNewIDs() {
        return this.newMap.keySet();
    }

    public Set<Id> getOldIDs() {
        return this.oldMap.keySet();
    }

    public Id getRecordTypeId(String developerName) {
        return this.sObjectDescribe.getRecordTypeInfosByDeveloperName().get(developerName)?.getRecordTypeId();
    }

    public Boolean fieldValueChanged(SObject newRecord, SObjectField field) {
        return this.isDelete
            ? null
            : this.isInsert || this.isUndelete || newRecord.get(field) != this.oldMap.get(newRecord.Id).get(field);
    }

    public Boolean fieldValueChangedTo(SObject newRecord, SObjectField field, Object newValue) {
        return this.fieldValueChanged(newRecord, field) && newRecord.get(field) == newValue;
    }

    public Boolean fieldValueChangedFrom(SObject newRecord, SObjectField field, Object oldValue) {
        return this.fieldValueChanged(newRecord, field) && this.oldMap.get(newRecord.Id).get(field) == oldValue;
    }

    // Suppressing ExcessiveParameterList because accepting a wrapper would be detrimental to ease-of-use
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public Boolean fieldValueChangedFromTo(SObject newRecord, SObjectField field, Object oldValue, Object newValue) {
        return this.fieldValueChangedFrom(newRecord, field, oldValue) && newRecord.get(field) == newValue;
    }
}