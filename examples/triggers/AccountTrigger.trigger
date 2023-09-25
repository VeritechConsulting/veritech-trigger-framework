/**
 * Minimal trigger file with no business logic
 * Creates a new instance of a class that extends BaseTriggerHandler (AccountTriggerHandler)
 * and calls the run() method to begin execution
 */
trigger AccountTrigger on Account(
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after undelete
) {
    new AccountTriggerHandler().run();
}