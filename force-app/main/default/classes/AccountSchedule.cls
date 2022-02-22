global with sharing class AccountSchedule implements Schedulable {
  global void execute(SchedulableContext SC) {
    Database.executeBatch(new AccountBatch());
  }
}
