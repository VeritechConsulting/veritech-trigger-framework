# Veritech Trigger Framework
A lightweight Apex trigger framework for Salesforce that is packed with functionality.

## How to install
Copy the class `BaseTriggerHandler` (and associated `BaseTriggerHandlerTest`) to your org and you are ready to start using the trigger framework!

Optionally, copy `TriggerUtil` (and `TriggerUtilTest`) if you would like to take advantage of the additional utilities included.

## How to use
Start by creating a trigger handler class that  extends `BaseTriggerHandler` and override the methods for the trigger operations that you want to handle.

```apex
public class AccountTriggerHandler extends BaseTriggerHandler {
    protected override void beforeInsert() {
        // Before insert logic
    }

    protected override void afterInsert() {
        // After insert logic
    }
}
```

Create a minimal trigger file with no business logic. The trigger creates a new instance of the trigger handler and calls the `run()` method to begin execution.

```apex
trigger AccountTrigger on Account(before insert, after insert) {
    new AccountTriggerHandler().run();
}
```

A full working example can be found in the folder [examples](examples).

## Features
### Methods that can be overriden
Only override those that you need to handle.
- `beforeInsert()`
- `beforeUpdate()`
- `beforeDelete()`
- `afterInsert()`
- `afterUpdate()`
- `afterDelete()`
- `afterUndelete()`

### Trigger context variables available
The following context variables have been retrieved from `Trigger` and are available for use in your trigger handler:
- `this.newList`
- `this.newMap`
- `this.oldList`
- `this.oldMap`
- `this.isBefore`
- `this.isAfter`
- `this.isInsert`
- `this.isUpdate`
- `this.isDelete`
- `this.isUndelete`
- `this.operationType`

> [!IMPORTANT]
> All the lists and maps are initialized to empty collections by the trigger framework to reduce the need for null checks.

### Recursion prevention
By default, the trigger framework prevents recursion in order to avoid hitting governor limits. However, if you need to allow recursion in your triggers, modify the trigger handler initialization by passing an optional Boolean parameter.

```apex
trigger AccountTrigger on Account(before insert, after insert) {
    Boolean allowRecursion = true;
    new AccountTriggerHandler(allowRecursion).run();
}
```

### Disabling trigger execution
All triggers handlers are enabled by default. If you would like to disable the execution of a trigger handler for the current transaction, you can do so by passing either the trigger handler `Type` or the `SObjectType` as a parameter.

```apex
// Options for disabling triggers
BaseTriggerHandler.disableTrigger(AccountTriggerHandler.class);
BaseTriggerHandler.disableTrigger(Account.SObjectType);
BaseTriggerHandler.disableTriggers(new Set<Type>{
    AccountTriggerHandler.class,
    OpportunityTriggerHandler.class,
});
BaseTriggerHandler.disableTriggers(new Set<SObjectType>{
    Account.SObjectType,
    Opportunity.SObjectType,
});

// Options for re-enabling triggers
BaseTriggerHandler.enableTrigger(AccountTriggerHandler.class);
BaseTriggerHandler.enableTrigger(Account.SObjectType);
BaseTriggerHandler.enableTriggers(new Set<Type>{
    AccountTriggerHandler.class,
    OpportunityTriggerHandler.class,
});
BaseTriggerHandler.enableTriggers(new Set<SObjectType>{
    Account.SObjectType,
    Opportunity.SObjectType,
});
```

## Additional utilities
Installing the class `TriggerUtil` gives you access to additional utility methods to perform common operations needed during trigger execution.

To use, create an instance of `TriggerUtil` by passing a reference to your trigger handler object (using `this`) and call the utility methods.

```apex
public class AccountTriggerHandler extends BaseTriggerHandler {
    TriggerUtil triggerUtil;

    public AccountTriggerHandler() {
        this.triggerUtil = new TriggerUtil(this);
    }

    protected override void beforeUpdate() {
        Set<Id> newRecordIds = this.triggerUtil.getNewIDs();
        // Other before update logic
    }
}
```

These are the definitions for the available trigger utility methods:

```apex
Set<Id> getNewIDs();
Set<Id> getOldIDs();
Id getRecordTypeId(String developerName);
Boolean fieldValueChanged(SObject newRecord, SObjectField field);
Boolean fieldValueChangedTo(SObject newRecord, SObjectField field, Object newValue);
Boolean fieldValueChangedFrom(SObject newRecord, SObjectField field, Object oldValue);
Boolean fieldValueChangedFromTo(SObject newRecord, SObjectField field, Object oldValue, Object newValue);
```
