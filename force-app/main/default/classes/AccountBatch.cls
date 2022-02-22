public with sharing class AccountBatch implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext BC) {
    List<Task> tasks = [
      SELECT WhatId
      FROM Task
      WHERE
        WhatId IN (SELECT Id FROM Account WHERE Inativo__c != TRUE)
        AND (NOT CreatedDate = LAST_N_DAYS:90)
    ];

    List<Opportunity> opps = [
      SELECT Account.Id
      FROM Opportunity
      WHERE
        CreatedDate = LAST_N_DAYS:120
        AND Account.Inativo__c != TRUE
        AND StageName != 'Closed Won'
        AND StageName != 'Negotiation/Review'
    ];

    Set<Id> ids = new Set<Id>();

    if (!tasks.isEmpty()) {
      for (Task task : tasks) {
        ids.add(task.WhatId);
      }
    }

    if (!opps.isEmpty()) {
      for (Opportunity opp : opps) {
        ids.add(opp.Id);
      }
    }

    return Database.getQueryLocator(
      'SELECT Inativo__c FROM Account WHERE Id IN :ids'
    );
  }

  public void execute(Database.BatchableContext BC, List<Account> scopes) {
    for (Account account : scopes) {
      account.Inativo__c = true;
    }

    update scopes;
  }

  public void finish(Database.BatchableContext BC) {
  }
}
