/**
 * Overrides the methods for the trigger operations that we want to handle
 * For example, notice the exclusion of afterDelete
 * (Optional) Delegates the execution to a helper for better separation of concerns
 */
public with sharing class AccountTriggerHandler extends BaseTriggerHandler {
    private AccountTriggerHandlerHelper helper;

    public AccountTriggerHandler() {
        this.helper = new AccountTriggerHandlerHelper(this);
    }

    protected override void beforeInsert() {
        this.helper.renameVendorAccounts();
    }

    protected override void beforeUpdate() {
        this.helper.renameVendorAccounts();
    }

    protected override void beforeDelete() {
        this.helper.preventDeletionByNonAdmins();
    }

    protected override void afterInsert() {
        this.helper.updateParentAccounts();
    }

    protected override void afterUpdate() {
        this.helper.updateParentAccounts();
    }

    protected override void afterUndelete() {
        this.helper.updateParentAccounts();
    }
}