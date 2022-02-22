public with sharing class ConsumidorFinal {
  public static Task createTask(Account account) {
    Task task = new Task();

    task.Subject = 'Consumidor Final';
    task.WhatId = account.Id;
    task.Status = 'Not Started';
    task.Priority = 'Normal';

    return Task;
  }
}
