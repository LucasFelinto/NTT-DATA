import { api, LightningElement } from "lwc";
import NAME_FILED from "@salesforce/schema/Account.Name";
import ACCOUNT_NUMBER_FIELD from "@salesforce/schema/Account.AccountNumber";
import TYPE_FIELD from "@salesforce/schema/Account.Type";

export default class Form extends LightningElement {
  fields = [NAME_FILED, ACCOUNT_NUMBER_FIELD, TYPE_FIELD];

  @api recordId;
  @api objectApiName;
}
