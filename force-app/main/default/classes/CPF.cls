public with sharing class CPF {
  public static void validation(Account account) {
    try {
      if (!Utils.validaCPF(account.AccountNumber)) {
        throw new AccountException('Número do cliente é inválido');
      }
    } catch (Exception e) {
      account.addError(e.getMessage());
    }
  }
}
