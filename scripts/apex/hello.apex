AccountSchedule m = new AccountSchedule();
String sch = '0 0 0/6 ? * MON,TUE,WED,THU,FRI *';
String jobID = system.schedule('Apagar contas inativas', sch, m);
