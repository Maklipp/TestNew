
&НаСервере
Процедура ПоказатьЦенуНаСервере()
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(Товар) Тогда
		Отбор.Вставить("Товар",Товар);
	КонецЕсли;
	Если ЗначениеЗаполнено(Поставщик)Тогда
		Отбор.Вставить ("Поставщик",Поставщик);
	КонецЕсли;
			
	ЗаписиРегистра = РегистрыСведений.ЦеныНоменклатурыПоКонтрагентам.СрезПоследних(Дата, Отбор);
	ТЗ.Загрузить(ЗаписиРегистра);
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЦену(Команда)
	ПоказатьЦенуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТаблицу(Команда)
	
	ТЗ.Очистить();
	
КонецПроцедуры
