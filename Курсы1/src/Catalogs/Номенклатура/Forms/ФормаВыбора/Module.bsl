
&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Параметры.РежимПодбора Тогда
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения("ВводКоличестваПродолжить", ЭтотОбъект,Значение);
		ПоказатьВводЧисла(ОписаниеОповещения,1,"Количество товара",4,0);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ВводКоличестваПродолжить (Число, ДополнительныеПараметры) Экспорт
	
	Если Число <> Неопределено И Число > 0 Тогда
		СсылкаВыбраннаяНоменклатура = ДополнительныеПараметры;
		СтруктураВыбора = Новый Структура;
		СтруктураВыбора.Вставить("Номенклатура", СсылкаВыбраннаяНоменклатура);
		СтруктураВыбора.Вставить("Количество", Число);
		ОповеститьОВыборе(СтруктураВыбора);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОповеститьОДобавленииВТаблицу (СтрокаСообщения) Экспорт
	
	Элементы.СообщениеПодбора.Заголовок = СтрокаСообщения;
	Элементы.СообщениеПодбора.Видимость = Истина;
	ПодключитьОбработчикОжидания("ОчиститьСообщениеПодбора",3, Истина);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСообщениеПодбора() Экспорт
	
	Элементы.СообщениеПодбора.Заголовок = "";
	Элементы.СообщениеПодбора.Видимость = Ложь;
	
КонецПроцедуры
