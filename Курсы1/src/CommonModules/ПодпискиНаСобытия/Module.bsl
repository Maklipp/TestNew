
Процедура УстановкаАвтораПриКопированииПриКопировании(Источник, ОбъектКопирования) Экспорт
	
	Если Источник.Метаданные().Реквизиты.Найти("Автор") <> Неопределено Тогда
		Источник.Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
КонецПроцедуры
