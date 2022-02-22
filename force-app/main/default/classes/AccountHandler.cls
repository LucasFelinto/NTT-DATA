public with sharing class AccountHandler {
  public static void checkAccountType(List<Account> accounts) {
    for (Account account : accounts) {
      if (account.Type == 'CPF') {
        CPF.validation(account);
      } else if (account.Type == 'CNPJ') {
        CNPJ.validation(account);
      }
    }
  }

  public static void checkRecordType(List<Account> accounts) {
    String recordTypeIdParceiros = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Parceiro')
      .getRecordTypeId();

    String recordTypeIdConsumidorFinal = Schema.SObjectType.Account.getRecordTypeInfosByName()
      .get('Consumidor final')
      .getRecordTypeId();

    List<SObject> data = new List<SObject>();

    for (Account account : accounts) {
      if (account.RecordTypeId == recordTypeIdParceiros) {
        data.add(Parceiro.createOpportunity(account));
      } else {
        data.add(ConsumidorFinal.createTask(account));
      }
    }

    insert data;
  }
}
