// Suppressing EmptyStatementBlock because the virtual methods are empty by design as they are meant to be overriden
@SuppressWarnings('PMD.EmptyStatementBlock')
public abstract class BaseTriggerHandler {
    //================================================================================
    // Constants and other static variables
    //================================================================================

    @TestVisible
    private static final Boolean ALLOW_RECURSION_DEFAULT = false;

    // Static variable used to determine if recursion is happening
    @TestVisible
    private static Set<String> triggerHandlerAndOperation = new Set<String>();

    // Static variables used to disable trigger execution
    @TestVisible
    private static Set<Type> disabledTriggerHandlers = new Set<Type>();
    @TestVisible
    private static Set<SObjectType> disabledTriggerObjects = new Set<SObjectType>();

    //================================================================================
    // Instance properties
    //================================================================================

    @TestVisible
    private Boolean allowRecursion;
    @TestVisible
    private String triggerHandlerName;
    @TestVisible
    private Type triggerHandlerType;

    @TestVisible
    public SObjectType sObjectType { get; private set; }
    @TestVisible
    public TriggerOperation operationType { get; private set; }
    @TestVisible
    public List<SObject> newList { get; private set; }
    @TestVisible
    public Map<Id, SObject> newMap { get; private set; }
    @TestVisible
    public List<SObject> oldList { get; private set; }
    @TestVisible
    public Map<Id, SObject> oldMap { get; private set; }
    @TestVisible
    public Boolean isBefore { get; private set; }
    @TestVisible
    public Boolean isAfter { get; private set; }
    @TestVisible
    public Boolean isInsert { get; private set; }
    @TestVisible
    public Boolean isUpdate { get; private set; }
    @TestVisible
    public Boolean isDelete { get; private set; }
    @TestVisible
    public Boolean isUndelete { get; private set; }

    //================================================================================
    // Constructors and constructor helpers
    //================================================================================

    protected BaseTriggerHandler() {
        this(ALLOW_RECURSION_DEFAULT);
    }

    protected BaseTriggerHandler(Boolean allowRecursion) {
        this.allowRecursion = allowRecursion ?? ALLOW_RECURSION_DEFAULT;
        this.triggerHandlerName = this.getExecutingClassName();
        this.triggerHandlerType = this.getExecutingClassType();

        if (Trigger.isExecuting) {
            this.initializeTriggerContext();
            this.sObjectType = this.getObjectType();
        }
    }

    @TestVisible
    private void initializeTriggerContext() {
        this.operationType = Trigger.operationType;
        this.newList = Trigger.new ?? new List<SObject>();
        this.newMap = Trigger.newMap ?? new Map<Id, SObject>();
        this.oldList = Trigger.old ?? new List<SObject>();
        this.oldMap = Trigger.oldMap ?? new Map<Id, SObject>();
        this.isBefore = Trigger.isBefore;
        this.isAfter = Trigger.isAfter;
        this.isInsert = Trigger.isInsert;
        this.isUpdate = Trigger.isUpdate;
        this.isDelete = Trigger.isDelete;
        this.isUndelete = Trigger.isUndelete;
    }

    @TestVisible
    private String getExecutingClassName() {
        return String.valueOf(this).substringBefore(':');
    }

    @TestVisible
    private Type getExecutingClassType() {
        return Type.forName(this.triggerHandlerName);
    }

    @TestVisible
    private SObjectType getObjectType() {
        return this.isDelete ? this.oldList.getSObjectType() : this.newList.getSObjectType();
    }

    //================================================================================
    // Virtual (overridable) methods, run method, and run helpers
    //================================================================================

    @TestVisible
    protected virtual void beforeInsert() {
    }
    @TestVisible
    protected virtual void beforeUpdate() {
    }
    @TestVisible
    protected virtual void beforeDelete() {
    }
    @TestVisible
    protected virtual void afterInsert() {
    }
    @TestVisible
    protected virtual void afterUpdate() {
    }
    @TestVisible
    protected virtual void afterDelete() {
    }
    @TestVisible
    protected virtual void afterUndelete() {
    }

    public void run() {
        if (this.canRun()) {
            this.registerRun();

            switch on this.operationType {
                when BEFORE_INSERT {
                    this.beforeInsert();
                }
                when BEFORE_UPDATE {
                    this.beforeUpdate();
                }
                when BEFORE_DELETE {
                    this.beforeDelete();
                }
                when AFTER_INSERT {
                    this.afterInsert();
                }
                when AFTER_UPDATE {
                    this.afterUpdate();
                }
                when AFTER_DELETE {
                    this.afterDelete();
                }
                when AFTER_UNDELETE {
                    this.afterUndelete();
                }
            }
        }
    }

    @TestVisible
    private Boolean canRun() {
        return this.triggerIsEnabled() && (this.allowRecursion || this.isFirstRun());
    }

    @TestVisible
    private Boolean triggerIsEnabled() {
        return !disabledTriggerHandlers.contains(this.triggerHandlerType) &&
            !disabledTriggerObjects.contains(this.sObjectType);
    }

    @TestVisible
    private Boolean isFirstRun() {
        return !triggerHandlerAndOperation.contains(this.triggerHandlerName + this.operationType);
    }

    @TestVisible
    private void registerRun() {
        triggerHandlerAndOperation.add(this.triggerHandlerName + this.operationType);
    }

    //================================================================================
    // Static methods to disable/enable trigger execution
    //================================================================================

    public static Boolean triggerIsEnabled(Type triggerHandler) {
        return !disabledTriggerHandlers.contains(triggerHandler);
    }

    public static Boolean triggerIsEnabled(SObjectType objectType) {
        return !disabledTriggerObjects.contains(objectType);
    }

    public static void disableTriggers(Set<Type> triggerHandlers) {
        if (triggerHandlers != null) {
            disabledTriggerHandlers.addAll(triggerHandlers);
        }
    }

    public static void disableTriggers(Set<SObjectType> objectTypes) {
        if (objectTypes != null) {
            disabledTriggerObjects.addAll(objectTypes);
        }
    }

    public static void disableTrigger(Type triggerHandler) {
        if (triggerHandler != null) {
            disabledTriggerHandlers.add(triggerHandler);
        }
    }

    public static void disableTrigger(SObjectType objectType) {
        if (objectType != null) {
            disabledTriggerObjects.add(objectType);
        }
    }

    public static void enableTriggers(Set<Type> triggerHandlers) {
        if (triggerHandlers != null) {
            disabledTriggerHandlers.removeAll(triggerHandlers);
        }
    }

    public static void enableTriggers(Set<SObjectType> objectTypes) {
        if (objectTypes != null) {
            disabledTriggerObjects.removeAll(objectTypes);
        }
    }

    public static void enableTrigger(Type triggerHandler) {
        if (triggerHandler != null) {
            disabledTriggerHandlers.remove(triggerHandler);
        }
    }

    public static void enableTrigger(SObjectType objectType) {
        if (objectType != null) {
            disabledTriggerObjects.remove(objectType);
        }
    }
}