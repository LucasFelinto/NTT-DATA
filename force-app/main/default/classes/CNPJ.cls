public with sharing class CNPJ {
  public static void validation(Account account) {
    try {
      if (!Utils.validaCNPJ(account.AccountNumber)) {
        throw new AccountException('Número do cliente é inválido');
      }
    } catch (Exception e) {
      account.addError(e.getMessage());
    }
  }
}
