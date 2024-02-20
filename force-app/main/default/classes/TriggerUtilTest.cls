// Suppressing MethodNamingConventions because naming format is methodBeingTested_testScenario_expectedResult
@SuppressWarnings('PMD.MethodNamingConventions')
@IsTest(IsParallel=true)
private without sharing class TriggerUtilTest {
    //================================================================================
    // Helpers
    //================================================================================
    static Integer fakeIdCounter = 1;

    static Id generateFakeId(SObjectType objectType) {
        String objectPrefix = objectType.getDescribe().getKeyPrefix();
        String fakeIdCounterStr = String.valueOf(fakeIdCounter++);
        Id fakeId = Id.valueOf(objectPrefix + '0'.repeat(12 - fakeIdCounterStr.length()) + fakeIdCounterStr);
        return fakeId;
    }

    static SObjectType getSObjectTypeFromString(String objectTypeStr) {
        return ((SObject) Type.forName(objectTypeStr).newInstance()).getSObjectType();
    }

    //================================================================================
    // Unit tests
    //================================================================================

    @IsTest
    static void triggerUtil_constructor_constructedSuccessfully() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;

        Test.startTest();
        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);
        Test.stopTest();

        Assert.isNotNull(
            triggerUtil.sObjectDescribe,
            'Expected the class property "sObjectDescribe" to be initialized'
        );

        Assert.areEqual(
            triggerHandler.newMap,
            triggerUtil.newMap,
            'Expected the class property "newMap" to be equal to the trigger handler\'s "newMap"'
        );

        Assert.areEqual(
            triggerHandler.oldMap,
            triggerUtil.oldMap,
            'Expected the class property "oldMap" to be equal to the trigger handler\'s "oldMap"'
        );

        Assert.areEqual(
            triggerHandler.isInsert,
            triggerUtil.isInsert,
            'Expected the class property "isInsert" to be equal to the trigger handler\'s "isInsert"'
        );

        Assert.areEqual(
            triggerHandler.isDelete,
            triggerUtil.isDelete,
            'Expected the class property "isDelete" to be equal to the trigger handler\'s "isDelete"'
        );

        Assert.areEqual(
            triggerHandler.isUndelete,
            triggerUtil.isUndelete,
            'Expected the class property "isUndelete" to be equal to the trigger handler\'s "isUndelete"'
        );
    }

    @IsTest
    static void getNewIDs_newMapPopulated_idsReturned() {
        Id firstId = generateFakeId(Account.SObjectType);
        Id secondId = generateFakeId(Account.SObjectType);

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.newMap = new Map<Id, Account>{ firstId => new Account(), secondId => new Account() };

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Set<Id> newIDs = triggerUtil.getNewIDs();
        Test.stopTest();

        Assert.isTrue(newIDs.contains(firstId), 'Expected the resulting set "newIDs" to contain the ID');
        Assert.isTrue(newIDs.contains(secondId), 'Expected the resulting set "newIDs" to contain the ID');
    }

    @IsTest
    static void getNewIDs_newMapNotPopulated_idsNotReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.newMap = new Map<Id, SObject>();

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Set<Id> newIDs = triggerUtil.getNewIDs();
        Test.stopTest();

        Assert.isTrue(newIDs.isEmpty(), 'Expected the resulting set "newIDs" to be empty');
    }

    @IsTest
    static void getOldIDs_oldMapPopulated_idsReturned() {
        Id firstId = generateFakeId(Account.SObjectType);
        Id secondId = generateFakeId(Account.SObjectType);

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.oldMap = new Map<Id, Account>{ firstId => new Account(), secondId => new Account() };

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Set<Id> oldIDs = triggerUtil.getOldIDs();
        Test.stopTest();

        Assert.isTrue(oldIDs.contains(firstId), 'Expected the resulting set "oldIDs" to contain the ID');
        Assert.isTrue(oldIDs.contains(secondId), 'Expected the resulting set "oldIDs" to contain the ID');
    }

    @IsTest
    static void getOldIDs_oldMapNotPopulated_idsNotReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.oldMap = new Map<Id, SObject>();

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Set<Id> oldIDs = triggerUtil.getOldIDs();
        Test.stopTest();

        Assert.isTrue(oldIDs.isEmpty(), 'Expected the resulting set "oldIDs" to be empty');
    }

    @IsTest
    static void getRecordTypeId_existingDeveloperName_idReturned() {
        List<RecordType> allRecordTypes = [
            SELECT Id, DeveloperName, SObjectType
            FROM RecordType
            WHERE IsActive = TRUE
        ];

        if (!allRecordTypes.isEmpty()) {
            RecordType anyRecordType = allRecordTypes.get(0);

            TestTriggerHandler triggerHandler = new TestTriggerHandler();
            triggerHandler.sObjectType = getSObjectTypeFromString(anyRecordType.SObjectType);

            String existingDeveloperName = anyRecordType.DeveloperName;

            TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

            Test.startTest();
            Id recordTypeIdReturned = triggerUtil.getRecordTypeId(existingDeveloperName);
            Test.stopTest();

            Assert.areEqual(
                anyRecordType.Id,
                recordTypeIdReturned,
                'Expected the resulting "recordTypeIdReturned" to be equal to the Id for the "anyRecordType" retrieved'
            );
        }
    }

    @IsTest
    static void getRecordTypeId_nonExistingDeveloperName_nullReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;

        String nonExistingDeveloperName = 'NonExistingDeveloperName';

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Id recordTypeIdReturned = triggerUtil.getRecordTypeId(nonExistingDeveloperName);
        Test.stopTest();

        Assert.isNull(recordTypeIdReturned, 'Expected the resulting "recordTypeIdReturned" to be null');
    }

    @IsTest
    static void getRecordTypeId_nullDeveloperName_nullReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);
        String developerName = null;

        Test.startTest();
        Id recordTypeIdReturned = triggerUtil.getRecordTypeId(developerName);
        Test.stopTest();

        Assert.isNull(recordTypeIdReturned, 'Expected the resulting "recordTypeIdReturned" to be null');
    }

    @IsTest
    static void fieldValueChanged_isDelete_nullReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = true;

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        SObject newRecord = null;
        SObjectField field = null;

        Test.startTest();
        Boolean fieldValueChanged = triggerUtil.fieldValueChanged(newRecord, field);
        Test.stopTest();

        Assert.isNull(fieldValueChanged, 'Expected the resulting "fieldValueChanged" to be null');
    }

    @IsTest
    static void fieldValueChanged_isInsert_returnTrue() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = true;

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        SObject newRecord = null;
        SObjectField field = null;

        Test.startTest();
        Boolean fieldValueChanged = triggerUtil.fieldValueChanged(newRecord, field);
        Test.stopTest();

        Assert.isTrue(fieldValueChanged, 'Expected the resulting "fieldValueChanged" to be true');
    }

    @IsTest
    static void fieldValueChanged_isUndelete_returnTrue() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = true;

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        SObject newRecord = null;
        SObjectField field = null;

        Test.startTest();
        Boolean fieldValueChanged = triggerUtil.fieldValueChanged(newRecord, field);
        Test.stopTest();

        Assert.isTrue(fieldValueChanged, 'Expected the resulting "fieldValueChanged" to be true');
    }

    @IsTest
    static void fieldValueChanged_valueChanged_returnTrue() {
        String oldName = 'Old Name';
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChanged = triggerUtil.fieldValueChanged(newAccount, Account.Name);
        Test.stopTest();

        Assert.isTrue(fieldValueChanged, 'Expected the resulting "fieldValueChanged" to be true');
    }

    @IsTest
    static void fieldValueChanged_valueNotChanged_returnFalse() {
        String oldName = 'Old Name';
        String newName = 'Old Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChanged = triggerUtil.fieldValueChanged(newAccount, Account.Name);
        Test.stopTest();

        Assert.isFalse(fieldValueChanged, 'Expected the resulting "fieldValueChanged" to be false');
    }

    @IsTest
    static void fieldValueChanged_fieldNull_exceptionThrown() {
        SObjectField fieldToCompare = null;
        String oldName = 'Old Name';
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();

        Exception exceptionReceived;

        try {
            triggerUtil.fieldValueChanged(newAccount, fieldToCompare);
            Assert.fail('Expected to receive an exception');
        } catch (Exception e) {
            exceptionReceived = e;
        }

        Test.stopTest();

        Assert.isInstanceOfType(
            exceptionReceived,
            NullPointerException.class,
            'Expected to receive a NullPointerException'
        );
    }

    @IsTest
    static void fieldValueChanged_fieldNotInObject_exceptionThrown() {
        SObjectField fieldToCompare = Contact.Name;
        String oldName = 'Old Name';
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();

        Exception exceptionReceived;

        try {
            triggerUtil.fieldValueChanged(newAccount, fieldToCompare);
            Assert.fail('Expected to receive an exception');
        } catch (Exception e) {
            exceptionReceived = e;
        }

        Test.stopTest();

        Assert.isInstanceOfType(exceptionReceived, SObjectException.class, 'Expected to receive a SObjectException');
    }

    @IsTest
    static void fieldValueChangedTo_valueChanged_returnTrue() {
        String oldName = 'Old Name';
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedTo = triggerUtil.fieldValueChangedTo(newAccount, Account.Name, newName);
        Test.stopTest();

        Assert.isTrue(fieldValueChangedTo, 'Expected the resulting "fieldValueChangedTo" to be true');
    }

    @IsTest
    static void fieldValueChangedTo_valueNotChanged_returnFalse() {
        String oldName = 'Old Name';
        String newName = 'Old Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedTo = triggerUtil.fieldValueChangedTo(newAccount, Account.Name, oldName);
        Test.stopTest();

        Assert.isFalse(fieldValueChangedTo, 'Expected the resulting "fieldValueChangedTo" to be false');
    }

    @IsTest
    static void fieldValueChangedTo_valueChangedToNull_returnTrue() {
        String oldName = 'Old Name';
        String newName = null;

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedTo = triggerUtil.fieldValueChangedTo(newAccount, Account.Name, newName);
        Test.stopTest();

        Assert.isTrue(fieldValueChangedTo, 'Expected the resulting "fieldValueChangedTo" to be true');
    }

    @IsTest
    static void fieldValueChangedTo_valueChangedToDifferentDataType_returnFalse() {
        String oldName = 'Old Name';
        Integer newName = 3;

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = String.valueOf(newName));

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedTo = triggerUtil.fieldValueChangedTo(newAccount, Account.Name, newName);
        Test.stopTest();

        Assert.isFalse(fieldValueChangedTo, 'Expected the resulting "fieldValueChangedTo" to be false');
    }

    @IsTest
    static void fieldValueChangedFrom_valueChanged_returnTrue() {
        String oldName = 'Old Name';
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedFrom = triggerUtil.fieldValueChangedFrom(newAccount, Account.Name, oldName);
        Test.stopTest();

        Assert.isTrue(fieldValueChangedFrom, 'Expected the resulting "fieldValueChangedFrom" to be true');
    }

    @IsTest
    static void fieldValueChangedFrom_valueNotChanged_returnFalse() {
        String oldName = 'Old Name';
        String newName = 'Old Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedFrom = triggerUtil.fieldValueChangedFrom(newAccount, Account.Name, oldName);
        Test.stopTest();

        Assert.isFalse(fieldValueChangedFrom, 'Expected the resulting "fieldValueChangedFrom" to be false');
    }

    @IsTest
    static void fieldValueChangedFrom_valueChangedFromNull_returnTrue() {
        String oldName = null;
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedFrom = triggerUtil.fieldValueChangedFrom(newAccount, Account.Name, oldName);
        Test.stopTest();

        Assert.isTrue(fieldValueChangedFrom, 'Expected the resulting "fieldValueChangedFrom" to be true');
    }

    @IsTest
    static void fieldValueChangedFrom_valueChangedFromDifferentDataType_returnFalse() {
        Integer oldName = 3;
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = String.valueOf(oldName));
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedFrom = triggerUtil.fieldValueChangedFrom(newAccount, Account.Name, oldName);
        Test.stopTest();

        Assert.isFalse(fieldValueChangedFrom, 'Expected the resulting "fieldValueChangedFrom" to be false');
    }

    @IsTest
    static void fieldValueChangedFromTo_valueChanged_returnTrue() {
        String oldName = 'Old Name';
        String newName = 'New Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedFromTo = triggerUtil.fieldValueChangedFromTo(
            newAccount,
            Account.Name,
            oldName,
            newName
        );
        Test.stopTest();

        Assert.isTrue(fieldValueChangedFromTo, 'Expected the resulting "fieldValueChangedFromTo" to be true');
    }

    @IsTest
    static void fieldValueChangedFromTo_valueNotChanged_returnFalse() {
        String oldName = 'Old Name';
        String newName = 'Old Name';

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedFromTo = triggerUtil.fieldValueChangedFromTo(newAccount, Account.Name, oldName, null);
        Test.stopTest();

        Assert.isFalse(fieldValueChangedFromTo, 'Expected the resulting "fieldValueChangedFromTo" to be false');
    }

    @IsTest
    static void fieldValueChangedFromTo_valueChangedToNull_returnTrue() {
        String oldName = 'Old Name';
        String newName = null;

        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        triggerHandler.isDelete = false;
        triggerHandler.isInsert = false;
        triggerHandler.isUndelete = false;

        Account oldAccount = new Account(Id = generateFakeId(Account.SObjectType), Name = oldName);
        triggerHandler.oldMap = new Map<Id, Account>{ oldAccount.Id => oldAccount };

        Account newAccount = new Account(Id = oldAccount.Id, Name = newName);

        TriggerUtil triggerUtil = new TriggerUtil(triggerHandler);

        Test.startTest();
        Boolean fieldValueChangedFromTo = triggerUtil.fieldValueChangedFromTo(
            newAccount,
            Account.Name,
            oldName,
            newName
        );
        Test.stopTest();

        Assert.isTrue(fieldValueChangedFromTo, 'Expected the resulting "fieldValueChangedFromTo" to be true');
    }

    //================================================================================
    // Mock classes extending BaseTriggerHandler
    //================================================================================

    class TestTriggerHandler extends BaseTriggerHandler {
    }
}