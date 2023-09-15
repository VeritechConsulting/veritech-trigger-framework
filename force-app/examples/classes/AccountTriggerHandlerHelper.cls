/**
 * Optional helper class for better separation of concerns
 * Contains the business logic that we want to execute when our triggers run
 * Uses utilities in TriggerUtil to simplify common operations
 */
public with sharing class AccountTriggerHandlerHelper {
    private static final String VENDOR_NAME_IDENTIFIER = ' (Vendor)';
    private static final String VENDOR_RECORD_TYPE_DEVELOPER_NAME = 'VendorAccount';
    private static final String SYSTEM_ADMIN_PROFILE_NAME = 'System Administrator';
    private static final String DELETION_NOT_ALLOWED_ERROR = 'You are not allowed to delete this record. Contact your System Administrator.';

    private TriggerUtil triggerUtil;
    private List<Account> newList;
    private List<Account> oldList;

    public AccountTriggerHandlerHelper(AccountTriggerHandler triggerHandler) {
        this.triggerUtil = new TriggerUtil(triggerHandler);
        this.newList = triggerHandler.newList;
        this.oldList = triggerHandler.oldList;
    }

    // Appends "(Vendor)" at the end of vendor account names if not already present
    public void renameVendorAccounts() {
        for (Account account : this.newList) {
            // Using TriggerUtil.getRecordTypeId() to easily retrieve the Id for a specific record type
            Id vendorRecordTypeId = this.triggerUtil.getRecordTypeId(VENDOR_RECORD_TYPE_DEVELOPER_NAME);

            Boolean accountIsVendor = account.RecordTypeId == vendorRecordTypeId;
            Boolean nameDoesNotEndInVendor = !account.Name.endsWith(VENDOR_NAME_IDENTIFIER);

            if (accountIsVendor && nameDoesNotEndInVendor) {
                account.Name += VENDOR_NAME_IDENTIFIER;
            }
        }
    }

    // Prevents the deletion of accounts by users who are not System Admins
    public void preventDeletionByNonAdmins() {
        Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = :SYSTEM_ADMIN_PROFILE_NAME];
        Boolean currentUserIsNotAdmin = UserInfo.getProfileId() != systemAdminProfile.Id;

        if (currentUserIsNotAdmin) {
            for (Account account : this.oldList) {
                account.addError(DELETION_NOT_ALLOWED_ERROR);
            }
        }
    }

    // Forces an update on parent accounts when updating the parent field
    public void updateParentAccounts() {
        Set<Id> changedParentIds = new Set<Id>();
        changedParentIds.addAll(this.getChangedParentIds(this.newList));
        changedParentIds.addAll(this.getChangedParentIds(this.oldList));

        List<Account> parentsToUpdate = new List<Account>();

        for (Id changedParentId : changedParentIds) {
            Account parentToUpdate = new Account(Id = changedParentId);
            parentsToUpdate.add(parentToUpdate);
        }

        if (!parentsToUpdate.isEmpty()) {
            update parentsToUpdate;
        }
    }

    //================================================================================
    // Helpers
    //================================================================================

    // Returns the Id of parent accounts if the parent field changed in the children
    private Set<Id> getChangedParentIds(List<Account> accountsToProcess) {
        Set<Id> changedParentIds = new Set<Id>();

        for (Account accountToProcess : accountsToProcess) {
            // Using TriggerUtil.fieldValueChanged() to determine if the field is being updated with a new value
            Boolean parentValueChanged = this.triggerUtil.fieldValueChanged(accountToProcess, Account.ParentId);

            Boolean accountHasParent = accountToProcess.ParentId != null;

            if (accountHasParent && parentValueChanged) {
                changedParentIds.add(accountToProcess.ParentId);
            }
        }

        return changedParentIds;
    }
}