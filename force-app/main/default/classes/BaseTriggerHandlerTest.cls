// Suppressing MethodNamingConventions because naming format is methodBeingTested_testScenario_expectedResult
@SuppressWarnings('PMD.MethodNamingConventions')
@IsTest(IsParallel=true)
private with sharing class BaseTriggerHandlerTest {
    //================================================================================
    // Unit tests
    //================================================================================

    // Constructors and constructor helpers

    @IsTest
    static void baseTriggerHandler_noParameters_constructedWithDefaultAllowRecursion() {
        Test.startTest();
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        Test.stopTest();

        Assert.areEqual(
            BaseTriggerHandler.ALLOW_RECURSION_DEFAULT,
            triggerHandler.allowRecursion,
            'Expected the class property "allowRecursion" to be equal to the constant "ALLOW_RECURSION_DEFAULT"'
        );

        Assert.areEqual(
            'TestTriggerHandler',
            triggerHandler.triggerHandlerName,
            'Expected the class property "triggerHandlerName" to be equal to the executing class "TestTriggerHandler"'
        );
    }

    @IsTest
    static void baseTriggerHandler_allowRecursionTrue_constructedWithAllowRecursionTrue() {
        Boolean allowRecursion = true;

        Test.startTest();
        TestTriggerHandlerWithAllowRecursion triggerHandler = new TestTriggerHandlerWithAllowRecursion(allowRecursion);
        Test.stopTest();

        Assert.isTrue(triggerHandler.allowRecursion, 'Expected the class property "allowRecursion" to be true');

        Assert.areEqual(
            'TestTriggerHandlerWithAllowRecursion',
            triggerHandler.triggerHandlerName,
            'Expected the class property "triggerHandlerName" to be equal to the executing class "TestTriggerHandlerWithAllowRecursion"'
        );
    }

    @IsTest
    static void baseTriggerHandler_allowRecursionFalse_constructedWithAllowRecursionFalse() {
        Boolean allowRecursion = false;

        Test.startTest();
        TestTriggerHandlerWithAllowRecursion triggerHandler = new TestTriggerHandlerWithAllowRecursion(allowRecursion);
        Test.stopTest();

        Assert.isFalse(triggerHandler.allowRecursion, 'Expected the class property "allowRecursion" to be false');

        Assert.areEqual(
            'TestTriggerHandlerWithAllowRecursion',
            triggerHandler.triggerHandlerName,
            'Expected the class property "triggerHandlerName" to be equal to the executing class "TestTriggerHandlerWithAllowRecursion"'
        );
    }

    @IsTest
    static void baseTriggerHandler_allowRecursionNull_constructedWithDefaultAllowRecursion() {
        Boolean allowRecursion = null;

        Test.startTest();
        TestTriggerHandlerWithAllowRecursion triggerHandler = new TestTriggerHandlerWithAllowRecursion(allowRecursion);
        Test.stopTest();

        Assert.areEqual(
            BaseTriggerHandler.ALLOW_RECURSION_DEFAULT,
            triggerHandler.allowRecursion,
            'Expected the class property "allowRecursion" to be equal to the constant "ALLOW_RECURSION_DEFAULT"'
        );

        Assert.areEqual(
            'TestTriggerHandlerWithAllowRecursion',
            triggerHandler.triggerHandlerName,
            'Expected the class property "triggerHandlerName" to be equal to the executing class "TestTriggerHandlerWithAllowRecursion"'
        );
    }

    @IsTest
    static void initializeTriggerContext_nullTriggerContextVariables_instanceVariablesPopulatedWithEmptyCollections() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();

        Test.startTest();
        triggerHandler.initializeTriggerContext();
        Test.stopTest();

        Assert.isNotNull(triggerHandler.newList, 'Expected the class property "newList" to be initialized');
        Assert.isTrue(
            triggerHandler.newList.isEmpty(),
            'Expected the class property "newList" to be an empty collection'
        );
        Assert.isNotNull(triggerHandler.newMap, 'Expected the class property "newMap" to be initialized');
        Assert.isTrue(
            triggerHandler.newMap.isEmpty(),
            'Expected the class property "newMap" to be an empty collection'
        );
        Assert.isNotNull(triggerHandler.oldList, 'Expected the class property "oldList" to be initialized');
        Assert.isTrue(
            triggerHandler.oldList.isEmpty(),
            'Expected the class property "oldList" to be an empty collection'
        );
        Assert.isNotNull(triggerHandler.oldMap, 'Expected the class property "oldMap" to be initialized');
        Assert.isTrue(
            triggerHandler.oldMap.isEmpty(),
            'Expected the class property "oldMap" to be an empty collection'
        );
    }

    @IsTest
    static void getExecutingClassName_defaultScenario_classNameReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();

        Test.startTest();
        String executingClassName = triggerHandler.getExecutingClassName();
        Test.stopTest();

        Assert.areEqual(
            'TestTriggerHandler',
            executingClassName,
            'Expected the resulting "executingClassName" to be equal to the executing class "TestTriggerHandler"'
        );
    }

    @IsTest
    static void getExecutingClassType_defaultScenario_classTypeReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();

        // Handler name needs to be a public top-level class or Type.forName() returns null
        triggerHandler.triggerHandlerName = BaseTriggerHandler.class.getName();

        Test.startTest();
        Type executingClassType = triggerHandler.getExecutingClassType();
        Test.stopTest();

        Assert.areEqual(
            BaseTriggerHandler.class,
            executingClassType,
            'Expected the resulting "executingClassType" to be of type "BaseTriggerHandler"'
        );
    }

    @IsTest
    static void getObjectType_isDelete_objectTypeReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.isDelete = true;
        triggerHandler.oldList = new List<Account>();

        Test.startTest();
        SObjectType objectType = triggerHandler.getObjectType();
        Test.stopTest();

        Assert.areEqual(
            Account.SObjectType,
            objectType,
            'Expected the resulting "objectType" to be equal to the oldList type "Account"'
        );
    }

    @IsTest
    static void getObjectType_isNotDelete_objectTypeReturned() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.isDelete = false;
        triggerHandler.newList = new List<Account>();

        Test.startTest();
        SObjectType objectType = triggerHandler.getObjectType();
        Test.stopTest();

        Assert.areEqual(
            Account.SObjectType,
            objectType,
            'Expected the resulting "objectType" to be equal to the newList type "Account"'
        );
    }

    // Virtual (overridable) methods, run method, and run helpers

    // Suppressing ApexUnitTestClassShouldHaveAsserts because there is no logic in the overridable methods
    @SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
    @IsTest
    static void allVirtualMethods_coverageOnly_success() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();

        Test.startTest();
        triggerHandler.beforeInsert();
        triggerHandler.beforeUpdate();
        triggerHandler.beforeDelete();
        triggerHandler.afterInsert();
        triggerHandler.afterUpdate();
        triggerHandler.afterDelete();
        triggerHandler.afterUndelete();
        Test.stopTest();
    }

    @IsTest
    static void run_canRunFalse_methodsNotExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        String triggerHandlerName = triggerHandler.triggerHandlerName;
        TriggerOperation operationType = triggerHandler.operationType;
        BaseTriggerHandler.triggerHandlerAndOperation.add(triggerHandlerName + operationType);

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isFalse(triggerHandler.beforeInsertCalled, 'Expected the method beforeInsert() not to have run');
    }

    @IsTest
    static void run_beforeInsert_methodExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isTrue(triggerHandler.beforeInsertCalled, 'Expected the method beforeInsert() to have run');
        Assert.isFalse(triggerHandler.isFirstRun(), 'Expected the trigger to register a successful run');
    }

    @IsTest
    static void run_beforeUpdate_methodExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.BEFORE_UPDATE;

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isTrue(triggerHandler.beforeUpdateCalled, 'Expected the method beforeUpdate() to have run');
        Assert.isFalse(triggerHandler.isFirstRun(), 'Expected the trigger to register a successful run');
    }

    @IsTest
    static void run_beforeDelete_methodExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.BEFORE_DELETE;

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isTrue(triggerHandler.beforeDeleteCalled, 'Expected the method beforeDelete() to have run');
        Assert.isFalse(triggerHandler.isFirstRun(), 'Expected the trigger to register a successful run');
    }

    @IsTest
    static void run_afterInsert_methodExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.AFTER_INSERT;

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isTrue(triggerHandler.afterInsertCalled, 'Expected the method afterInsert() to have run');
        Assert.isFalse(triggerHandler.isFirstRun(), 'Expected the trigger to register a successful run');
    }

    @IsTest
    static void run_afterUpdate_methodExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.AFTER_UPDATE;

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isTrue(triggerHandler.afterUpdateCalled, 'Expected the method afterUpdate() to have run');
        Assert.isFalse(triggerHandler.isFirstRun(), 'Expected the trigger to register a successful run');
    }

    @IsTest
    static void run_afterDelete_methodExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.AFTER_DELETE;

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isTrue(triggerHandler.afterDeleteCalled, 'Expected the method afterDelete() to have run');
        Assert.isFalse(triggerHandler.isFirstRun(), 'Expected the trigger to register a successful run');
    }

    @IsTest
    static void run_afterUndelete_methodExecuted() {
        TestTriggerHandlerWithOverridenMethods triggerHandler = new TestTriggerHandlerWithOverridenMethods();
        triggerHandler.operationType = TriggerOperation.AFTER_UNDELETE;

        Test.startTest();
        triggerHandler.run();
        Test.stopTest();

        Assert.isTrue(triggerHandler.afterUndeleteCalled, 'Expected the method afterUndelete() to have run');
        Assert.isFalse(triggerHandler.isFirstRun(), 'Expected the trigger to register a successful run');
    }

    @IsTest
    static void canRun_triggerDisabled_returnFalse() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.triggerHandlerType = TestTriggerHandler.class;
        BaseTriggerHandler.disabledTriggerHandlers.add(TestTriggerHandler.class);

        Test.startTest();
        Boolean canRun = triggerHandler.canRun();
        Test.stopTest();

        Assert.isFalse(canRun, 'Expected the resulting "canRun" to be false');
    }

    @IsTest
    static void canRun_triggerEnabledAndAllowRecursionTrue_returnTrue() {
        Boolean allowRecursion = true;
        TestTriggerHandlerWithAllowRecursion triggerHandler = new TestTriggerHandlerWithAllowRecursion(allowRecursion);

        Test.startTest();
        Boolean canRun = triggerHandler.canRun();
        Test.stopTest();

        Assert.isTrue(canRun, 'Expected the resulting "canRun" to be true');
    }

    @IsTest
    static void canRun_triggerEnabledAndAllowRecursionFalseAndFirstRunTrue_returnTrue() {
        Boolean allowRecursion = false;
        TestTriggerHandlerWithAllowRecursion triggerHandler = new TestTriggerHandlerWithAllowRecursion(allowRecursion);
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        Test.startTest();
        Boolean canRun = triggerHandler.canRun();
        Test.stopTest();

        Assert.isTrue(canRun, 'Expected the resulting "canRun" to be true');
    }

    @IsTest
    static void canRun_triggerEnabledAndAllowRecursionFalseAndFirstRunFalse_returnFalse() {
        Boolean allowRecursion = false;
        TestTriggerHandlerWithAllowRecursion triggerHandler = new TestTriggerHandlerWithAllowRecursion(allowRecursion);
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        String triggerHandlerName = triggerHandler.triggerHandlerName;
        TriggerOperation operationType = triggerHandler.operationType;
        BaseTriggerHandler.triggerHandlerAndOperation.add(triggerHandlerName + operationType);

        Test.startTest();
        Boolean canRun = triggerHandler.canRun();
        Test.stopTest();

        Assert.isFalse(canRun, 'Expected the resulting "canRun" to be false');
    }

    @IsTest
    static void triggerIsEnabled_setsAreEmpty_returnTrue() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();

        Test.startTest();
        Boolean triggerIsEnabled = triggerHandler.triggerIsEnabled();
        Test.stopTest();

        Assert.isTrue(triggerIsEnabled, 'Expected the resulting "triggerIsEnabled" to be true');
    }

    @IsTest
    static void triggerIsEnabled_triggerHandlerMatch_returnFalse() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.triggerHandlerType = TestTriggerHandler.class;
        BaseTriggerHandler.disabledTriggerHandlers.add(TestTriggerHandler.class);

        Test.startTest();
        Boolean triggerIsEnabled = triggerHandler.triggerIsEnabled();
        Test.stopTest();

        Assert.isFalse(triggerIsEnabled, 'Expected the resulting "triggerIsEnabled" to be false');
    }

    @IsTest
    static void triggerIsEnabled_triggerObjectMatch_returnFalse() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.sObjectType = Account.SObjectType;
        BaseTriggerHandler.disabledTriggerObjects.add(Account.SObjectType);

        Test.startTest();
        Boolean triggerIsEnabled = triggerHandler.triggerIsEnabled();
        Test.stopTest();

        Assert.isFalse(triggerIsEnabled, 'Expected the resulting "triggerIsEnabled" to be false');
    }

    @IsTest
    static void isFirstRun_onFirstRun_returnTrue() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        Test.startTest();
        Boolean isFirstRun = triggerHandler.isFirstRun();
        Test.stopTest();

        Assert.isTrue(isFirstRun, 'Expected the resulting "isFirstRun" to be true');
    }

    @IsTest
    static void isFirstRun_onSecondRun_returnFalse() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        String triggerHandlerName = triggerHandler.triggerHandlerName;
        TriggerOperation operationType = triggerHandler.operationType;
        BaseTriggerHandler.triggerHandlerAndOperation.add(triggerHandlerName + operationType);

        Test.startTest();
        Boolean isFirstRun = triggerHandler.isFirstRun();
        Test.stopTest();

        Assert.isFalse(isFirstRun, 'Expected the resulting "isFirstRun" to be false');
    }

    @IsTest
    static void processAfterRun_onFirstRun_valueAddedToSet() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        Test.startTest();
        triggerHandler.processAfterRun();
        Test.stopTest();

        String triggerHandlerName = triggerHandler.triggerHandlerName;
        TriggerOperation operationType = triggerHandler.operationType;

        Assert.isTrue(
            BaseTriggerHandler.triggerHandlerAndOperation.contains(triggerHandlerName + operationType),
            'Expected the set "triggerHandlerAndOperation" to contain the element "triggerHandlerName + operationType"'
        );
    }

    @IsTest
    static void processAfterRun_onSecondRun_valueAddedToSet() {
        TestTriggerHandler triggerHandler = new TestTriggerHandler();
        triggerHandler.operationType = TriggerOperation.BEFORE_INSERT;

        String triggerHandlerName = triggerHandler.triggerHandlerName;
        TriggerOperation operationType = triggerHandler.operationType;
        BaseTriggerHandler.triggerHandlerAndOperation.add(triggerHandlerName + operationType);

        Test.startTest();
        triggerHandler.processAfterRun();
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.triggerHandlerAndOperation.contains(triggerHandlerName + operationType),
            'Expected the set "triggerHandlerAndOperation" to contain the element "triggerHandlerName + operationType"'
        );
    }

    // Static methods to disable/enable trigger execution

    @IsTest
    static void disableTriggers_passSetOfTypePopulated_disabledTriggerHandlersPopulated() {
        Set<Type> triggerHandlers = new Set<Type>{
            TestTriggerHandler.class,
            TestTriggerHandlerWithAllowRecursion.class
        };

        Test.startTest();
        BaseTriggerHandler.disableTriggers(triggerHandlers);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.containsAll(triggerHandlers),
            'Expected the set "disabledTriggerHandlers" to contain the elements "TestTriggerHandler" and "TestTriggerHandlerWithAllowRecursion"'
        );
    }

    @IsTest
    static void disableTriggers_passSetOfTypeNull_disabledTriggerHandlersEmpty() {
        Set<Type> triggerHandlers = null;

        Test.startTest();
        BaseTriggerHandler.disableTriggers(triggerHandlers);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.isEmpty(),
            'Expected the set "disabledTriggerHandlers" to be empty'
        );
    }

    @IsTest
    static void disableTriggers_passSetOfSObjectPopulated_disabledTriggerObjectsPopulated() {
        Set<SObjectType> objectTypes = new Set<SObjectType>{ Account.SObjectType, Contact.SObjectType };

        Test.startTest();
        BaseTriggerHandler.disableTriggers(objectTypes);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.containsAll(objectTypes),
            'Expected the set "disabledTriggerObjects" to contain the elements "Account" and "Contact"'
        );
    }

    @IsTest
    static void disableTriggers_passSetOfSObjectNull_disabledTriggerObjectsEmpty() {
        Set<SObjectType> objectTypes = null;

        Test.startTest();
        BaseTriggerHandler.disableTriggers(objectTypes);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.isEmpty(),
            'Expected the set "disabledTriggerObjects" to be empty'
        );
    }

    @IsTest
    static void disableTrigger_passType_disabledTriggerHandlersPopulated() {
        Type triggerHandler = TestTriggerHandler.class;

        Test.startTest();
        BaseTriggerHandler.disableTrigger(triggerHandler);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.contains(triggerHandler),
            'Expected the set "disabledTriggerHandlers" to contain the element "TestTriggerHandler"'
        );
    }

    @IsTest
    static void disableTrigger_passTypeNull_disabledTriggerHandlersEmpty() {
        Type triggerHandler = null;

        Test.startTest();
        BaseTriggerHandler.disableTrigger(triggerHandler);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.isEmpty(),
            'Expected the set "disabledTriggerHandlers" to be empty'
        );
    }

    @IsTest
    static void disableTrigger_passSObject_disabledTriggerObjectsPopulated() {
        SObjectType objectType = Account.SObjectType;

        Test.startTest();
        BaseTriggerHandler.disableTrigger(objectType);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.contains(objectType),
            'Expected the set "disabledTriggerObjects" to contain the element "Account"'
        );
    }

    @IsTest
    static void disableTrigger_passSObjectNull_disabledTriggerObjectsEmpty() {
        SObjectType objectType = null;

        Test.startTest();
        BaseTriggerHandler.disableTrigger(objectType);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.isEmpty(),
            'Expected the set "disabledTriggerObjects" to be empty'
        );
    }

    @IsTest
    static void enableTriggers_passSetOfTypePopulated_disabledTriggerHandlersEmpty() {
        Set<Type> triggerHandlers = new Set<Type>{
            TestTriggerHandler.class,
            TestTriggerHandlerWithAllowRecursion.class
        };

        BaseTriggerHandler.disabledTriggerHandlers.addAll(triggerHandlers);

        Test.startTest();
        BaseTriggerHandler.enableTriggers(triggerHandlers);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.isEmpty(),
            'Expected the set "disabledTriggerHandlers" to be empty'
        );
    }

    @IsTest
    static void enableTriggers_passSetOfTypeNull_disabledTriggerHandlersPopulated() {
        Set<Type> triggerHandlers = new Set<Type>{
            TestTriggerHandler.class,
            TestTriggerHandlerWithAllowRecursion.class
        };

        BaseTriggerHandler.disabledTriggerHandlers.addAll(triggerHandlers);
        Set<Type> nullSet = null;

        Test.startTest();
        BaseTriggerHandler.enableTriggers(nullSet);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.containsAll(triggerHandlers),
            'Expected the set "disabledTriggerHandlers" to contain the elements "TestTriggerHandler" and "TestTriggerHandlerWithAllowRecursion"'
        );
    }

    @IsTest
    static void enableTriggers_passSetOfSObjectPopulated_disabledTriggerObjectsEmpty() {
        Set<SObjectType> objectTypes = new Set<SObjectType>{ Account.SObjectType, Contact.SObjectType };
        BaseTriggerHandler.disabledTriggerObjects.addAll(objectTypes);

        Test.startTest();
        BaseTriggerHandler.enableTriggers(objectTypes);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.isEmpty(),
            'Expected the set "disabledTriggerObjects" to be empty'
        );
    }

    @IsTest
    static void enableTriggers_passSetOfSObjectNull_disabledTriggerObjectsPopulated() {
        Set<SObjectType> objectTypes = new Set<SObjectType>{ Account.SObjectType, Contact.SObjectType };
        BaseTriggerHandler.disabledTriggerObjects.addAll(objectTypes);
        Set<SObjectType> nullSet = null;

        Test.startTest();
        BaseTriggerHandler.enableTriggers(nullSet);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.containsAll(objectTypes),
            'Expected the set "disabledTriggerObjects" to contain the elements "Account" and "Contact"'
        );
    }

    @IsTest
    static void enableTrigger_passType_typeRemovedFromDisabledTriggerHandlers() {
        Type disabledTriggerHandler = TestTriggerHandler.class;
        Type triggerHandlerToEnable = TestTriggerHandlerWithAllowRecursion.class;

        BaseTriggerHandler.disabledTriggerHandlers.addAll(
            new List<Type>{ disabledTriggerHandler, triggerHandlerToEnable }
        );

        Test.startTest();
        BaseTriggerHandler.enableTrigger(triggerHandlerToEnable);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.contains(disabledTriggerHandler),
            'Expected the set "disabledTriggerHandlers" to contain the element "TestTriggerHandler"'
        );

        Assert.isFalse(
            BaseTriggerHandler.disabledTriggerHandlers.contains(triggerHandlerToEnable),
            'Expected the set "disabledTriggerHandlers" not to contain the element "TestTriggerHandlerWithAllowRecursion"'
        );
    }

    @IsTest
    static void enableTrigger_passTypeNull_disabledTriggerHandlersPopulated() {
        List<Type> triggerHandlers = new List<Type>{
            TestTriggerHandler.class,
            TestTriggerHandlerWithAllowRecursion.class
        };

        BaseTriggerHandler.disabledTriggerHandlers.addAll(triggerHandlers);
        Type nullType = null;

        Test.startTest();
        BaseTriggerHandler.enableTrigger(nullType);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerHandlers.containsAll(triggerHandlers),
            'Expected the set "disabledTriggerHandlers" to contain the elements "TestTriggerHandler" and "TestTriggerHandlerWithAllowRecursion"'
        );
    }

    @IsTest
    static void enableTrigger_passSObject_sobjectRemovedFromDisabledTriggerObjects() {
        SObjectType disabledTriggerObject = Account.SObjectType;
        SObjectType triggerObjectToEnable = Contact.SObjectType;

        BaseTriggerHandler.disabledTriggerObjects.addAll(
            new List<SObjectType>{ disabledTriggerObject, triggerObjectToEnable }
        );

        Test.startTest();
        BaseTriggerHandler.enableTrigger(triggerObjectToEnable);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.contains(disabledTriggerObject),
            'Expected the set "disabledTriggerObjects" to contain the element "Account"'
        );

        Assert.isFalse(
            BaseTriggerHandler.disabledTriggerObjects.contains(triggerObjectToEnable),
            'Expected the set "disabledTriggerObjects" not to contain the element "Contact"'
        );
    }

    @IsTest
    static void enableTrigger_passSObjectNull_disabledTriggerObjectsPopulated() {
        List<SObjectType> triggerObjects = new List<SObjectType>{ Account.SObjectType, Contact.SObjectType };
        BaseTriggerHandler.disabledTriggerObjects.addAll(triggerObjects);
        SObjectType nullObject = null;

        Test.startTest();
        BaseTriggerHandler.enableTrigger(nullObject);
        Test.stopTest();

        Assert.isTrue(
            BaseTriggerHandler.disabledTriggerObjects.containsAll(triggerObjects),
            'Expected the set "disabledTriggerObjects" to contain the elements "Account" and "Contact"'
        );
    }

    //================================================================================
    // Mock classes extending BaseTriggerHandler
    //================================================================================

    class TestTriggerHandler extends BaseTriggerHandler {
    }

    class TestTriggerHandlerWithAllowRecursion extends BaseTriggerHandler {
        TestTriggerHandlerWithAllowRecursion(Boolean allowRecursion) {
            super(allowRecursion);
        }
    }

    class TestTriggerHandlerWithOverridenMethods extends BaseTriggerHandler {
        Boolean beforeInsertCalled = false;
        Boolean beforeUpdateCalled = false;
        Boolean beforeDeleteCalled = false;
        Boolean afterInsertCalled = false;
        Boolean afterUpdateCalled = false;
        Boolean afterDeleteCalled = false;
        Boolean afterUndeleteCalled = false;

        protected override void beforeInsert() {
            this.beforeInsertCalled = true;
        }
        protected override void beforeUpdate() {
            this.beforeUpdateCalled = true;
        }
        protected override void beforeDelete() {
            this.beforeDeleteCalled = true;
        }
        protected override void afterInsert() {
            this.afterInsertCalled = true;
        }
        protected override void afterUpdate() {
            this.afterUpdateCalled = true;
        }
        protected override void afterDelete() {
            this.afterDeleteCalled = true;
        }
        protected override void afterUndelete() {
            this.afterUndeleteCalled = true;
        }
    }
}