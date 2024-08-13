

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ИнтервалАвтосохранения", Объект.ИнтервалАвтосохранения);
	Параметры.Свойство("ИспользоватьАвтосохранение", Объект.ИспользоватьАвтосохранение);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если Объект.ИспользоватьАвтосохранение и Объект.ИнтервалАвтосохранения < 10 Тогда
		глПредупреждение("Интервал автосахронения должен быть не менее 10 секунд.", , "Предупреждение");
		Возврат;
	КонецЕсли;
	
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("ИнтервалАвтосохранения", Объект.ИнтервалАвтосохранения);
	ПараметрыПередачи.Вставить("ИспользоватьАвтосохранение", Объект.ИспользоватьАвтосохранение);
	
	Закрыть();
	
	Оповестить("ПередатьПараметрыНастроекАвтоСохранения", ПараметрыПередачи);
	
КонецПроцедуры
