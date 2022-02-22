@isTest
public with sharing class AccountTriggerTest {
  @isTest
  static void accountBatch() {
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < 200; i++) {
      Account account = new Account();
      account.Name = 'Teste';
      account.AccountNumber = '59023288000162';
      account.Type = 'CNPJ';
      accounts.add(account);
    }

    insert accounts;

    Test.startTest();
    DataBase.executeBatch(
      new AccountBatch(
        'SELECT Id, Subject, WhatId FROM Task WHERE WhatId IN (SELECT Id FROM Account WHERE Inativo__c != TRUE) AND (NOT CreatedDate = LAST_N_DAYS:5)',
        'Inativo__c',
        'true'
      )
    );
    Test.stopTest();
  }

  @isTest
  static void accountCreateCPFErro() {
    DmlException unexpectedException;

    try {
      Account account = new Account();
      account.Name = 'Teste';
      account.AccountNumber = '123454564';
      account.Type = 'CPF';

      insert account;
    } catch (DmlException e) {
      unexpectedException = e;
    }

    System.assert(
      unexpectedException != null,
      'Exceções devem ser tratadas pelo método'
    );
  }

  @isTest
  static void accountCreateCNPJErro() {
    DmlException unexpectedException;

    try {
      Account account = new Account();
      account.Name = 'Teste';
      account.AccountNumber = '2432362345231';
      account.Type = 'CNPJ';

      insert account;
    } catch (DmlException e) {
      unexpectedException = e;
    }

    System.assert(
      unexpectedException != null,
      'Exceções devem ser tratadas pelo método'
    );
  }

  @isTest
  static void accountCreate() {
    try {
      Account cpfAccount = new Account();
      cpfAccount.Name = 'Teste 1';
      cpfAccount.AccountNumber = '88343524080';
      cpfAccount.Type = 'CPF';

      Account cnpjAccount = new Account();
      cnpjAccount.Name = 'Teste 2';
      cnpjAccount.AccountNumber = '59023288000162';
      cnpjAccount.Type = 'CNPJ';

      insert cpfAccount;
      insert cnpjAccount;

      String cpf = [
        SELECT AccountNumber
        FROM Account
        WHERE AccountNumber = '88343524080'
      ]
      .AccountNumber;

      String cnpj = [
        SELECT AccountNumber
        FROM Account
        WHERE AccountNumber = '59023288000162'
      ]
      .AccountNumber;

      System.assertEquals(
        cpfAccount.AccountNumber,
        cpf,
        'Deveria retorna o CPF cadastrado'
      );

      System.assertEquals(
        cnpjAccount.AccountNumber,
        cnpj,
        'Deveria retorna o CNPJ cadastrado'
      );
    } catch (DmlException e) {
      System.assert(false, 'Exceções devem ser tratadas pelo método');
    }
  }

  @isTest
  static void createAccountParceiro() {
    String recordTypeIdParceiros = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Parceiro')
      .getRecordTypeId();

    Account account = new Account();
    account.Name = 'Teste';
    account.RecordTypeId = recordTypeIdParceiros;

    insert account;

    String recordId = [SELECT RecordTypeId FROM Account WHERE Name = 'Teste']
    .RecordTypeId;

    Opportunity opp = [
      SELECT Name
      FROM Opportunity
      WHERE StageName = 'Qualification'
    ];

    System.assert(
      opp.Name.contains(opp.Name),
      'O Name da Opportunity deveria conter o Name da Account'
    );

    System.assertEquals(
      recordTypeIdParceiros,
      recordId,
      'Deveria trazer RecordTypeId de Parceiros'
    );
  }

  @isTest
  static void createAccountConsumidorFinal() {
    String recordTypeIdConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Consumidor final')
      .getRecordTypeId();

    Account account = new Account();
    account.Name = 'Teste';
    account.RecordTypeId = recordTypeIdConsumidorFinal;

    insert account;

    String recordId = [SELECT RecordTypeId FROM Account WHERE Name = 'Teste']
    .RecordTypeId;

    Task task = [SELECT WhatId FROM Task WHERE WhatId = :account.Id];

    System.assertEquals(
      account.Id,
      task.WhatId,
      'WhatId da task deveria ser igual ao Id da Account'
    );

    System.assertEquals(
      recordTypeIdConsumidorFinal,
      recordId,
      'Deveria trazer RecordTypeId de Consumidor final'
    );
  }
}
