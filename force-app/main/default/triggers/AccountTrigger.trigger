trigger AccountTrigger on Account(before insert, after insert) {
  if (Trigger.isAfter) {
    AccountHandler.checkAccountType(Trigger.new);
    AccountHandler.checkRecordType(Trigger.new);
  }
}
