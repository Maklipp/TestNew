
&НаСервере
Процедура ПолучитьЗначенияНаСервере()
	
	Отбор = Новый Структура("Филиал", Филиал);
	ЗаписиРегистра = РегистрыСведений.ИсторияФилиала.СрезПервых(Дата, Отбор);
	ТЗ.Загрузить(ЗаписиРегистра);	
	
	
	

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьЗначения(Команда)
	ПолучитьЗначенияНаСервере();
КонецПроцедуры
