public with sharing class Parceiro {
  public static Opportunity createOpportunity(Account account) {
    Opportunity opp = new Opportunity();

    opp.Name = account.Name + ' - opp Parceiro';
    opp.CloseDate = Date.today().addDays(30);
    opp.StageName = 'Qualification';
    opp.AccountId = account.Id;

    return opp;
  }
}
