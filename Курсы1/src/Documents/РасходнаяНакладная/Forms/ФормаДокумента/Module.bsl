 //Событие пометки\снятия удаления можно отловить через ПриЧтенииНаСервере
 &НаСервере
 Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	 
	 ОбновитьСтатусДокумента();
	 
 КонецПроцедуры
 
 &НаСервере
 Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 
	 ОбновитьСтатусДокумента();
	 
 КонецПроцедуры
 
 &НаСервере
 Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	 
	 ОбновитьСтатусДокумента();
	 
 КонецПроцедуры
 
 &НаКлиенте
 Процедура КоличествоИлиЦенаПриИзменении(Элемент)
	 
	 ПересчитатьСуммуТовара(); 
	 
 КонецПроцедуры
 
 &НаСервере
 Процедура ОбновитьСтатусДокумента()
	 
	 Если ЭтаФорма.Параметры.Ключ.Пустая() Тогда
		 
		 Элементы.ПризнакПроведения.Заголовок  = "Новый";
		 Элементы.ПризнакПроведения.ЦветТекста = WebЦвета.Серый;
		 
	 ИначеЕсли Объект.Проведен Тогда 
		 
		 Элементы.ПризнакПроведения.Заголовок  = "Проведен";
		 Элементы.ПризнакПроведения.ЦветТекста = WebЦвета.ЗеленыйЛес;
		 
	 ИначеЕсли НЕ Объект.Проведен И НЕ Объект.ПометкаУдаления Тогда 
		 
		 Элементы.ПризнакПроведения.Заголовок  = "Записан";
		 Элементы.ПризнакПроведения.ЦветТекста = WebЦвета.СероСиний;
		 
	 Иначе
		 
		 Элементы.ПризнакПроведения.Заголовок  = "Удален";
		 Элементы.ПризнакПроведения.ЦветТекста =
		 WebЦвета.КрасноФиолетовый;
		 
	 КонецЕсли;
	 
	 ОбновитьВидКнопкиПровестиРаспровести();
	 ОбновитьВидКнопкиПометкаУдаления();
	 
 КонецПроцедуры
 
 &НаКлиенте
 Процедура ПересчитатьСуммуТовара()
	 
	 ТекДанные = Элементы.Номенклатура.ТекущиеДанные;
	 Если (ТекДанные <> Неопределено) Тогда
	     ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
	 КонецЕсли;
	 ОбработкаТабличнойЧастиКлиента.ОбработатьСтроку(ТекДанные);
	 ПересчитатьСуммуДокумента(); 
	 
 КонецПроцедуры
 
 &НаКлиенте
 Процедура ПересчитатьСуммуДокумента()
	 
	 Объект.СуммаДокумента = Объект.Номенклатура.Итог("Сумма");
		 
 КонецПроцедуры
 
 &НаКлиенте
 Процедура ПодборНоменклатура(Команда)
	 
	 ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, РежимПодбора", Ложь, Истина);
	 
	 ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбора",ПараметрыФормы,ЭтотОбъект);
	 
 КонецПроцедуры
 
 &НаКлиенте
 Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	 
	 Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		 Если ВыбранноеЗначение.Количество() = 2 Тогда
			 Отбор = Новый Структура("Номенклатура", ВыбранноеЗначение.Номенклатура);
			 РезультатПоиска = Объект.Номенклатура.НайтиСтроки(Отбор);
			 Если РезультатПоиска.Количество() <> 0 Тогда
				 СтрокаТаблицы = РезультатПоиска[0];
			 Иначе
				 СтрокаТаблицы = Объект.Номенклатура.Добавить();
				 СтрокаТаблицы.Номенклатура = ВыбранноеЗначение.Номенклатура;
			 КонецЕсли;
			 
			 СтрокаТаблицы.Количество = СтрокаТаблицы.Количество + ВыбранноеЗначение.Количество;
			 СтрокаТаблицы.Сумма = СтрокаТаблицы.Количество * СтрокаТаблицы.Цена;
			 ПересчитатьСуммуДокумента();
			 
			 СообщениеДобавления = СтрШаблон("В Документ расходная накладная %1 от %2 добавлена номенклатура:
			 |%3 в количестве %4 шт.",Объект.Номер, Объект.Дата, СтрокаТаблицы.Номенклатура, ВыбранноеЗначение.Количество);
			 
			 ИсточникВыбора.ОповеститьОДобавленииВТаблицу(СообщениеДобавления)
		 Иначе
			 Если ВыбранноеЗначение.Выбор Тогда
				 Объект.Номенклатура.Очистить();
			 КонецЕсли;
			 ЗагрузитьДанныеВТаблицу (ВыбранноеЗначение.Документ);
			 
		 КонецЕсли;		 
	 КонецЕсли;	
	 
 КонецПроцедуры 
 
 &НаСервере
 Процедура ЗагрузитьДанныеВТаблицу (Данные)
	 
	 Таблица = Данные.Номенклатура.Выгрузить();
	 Для Каждого Строка Из Таблица Цикл 
		 СтрокаТаблицы = Объект.Номенклатура.Добавить();
		 СтрокаТаблицы.Номенклатура = Строка.Номенклатура;
		 СтрокаТаблицы.Количество = Строка.Количество;  
		 СтрокаТаблицы.Цена = Строка.Цена;  
		 СтрокаТаблицы.Сумма = Строка.Сумма;
	 КонецЦикла;
	 
 КонецПроцедуры
 
 &НаСервере
 Процедура КомандаПометкаУдаленияНаСервере()
	 
	 Если (Объект.Проведен) Тогда
		 Сообщить("Запрещено устанавливать пометку на проведенный документ.");
		 Возврат;
	 КонецЕсли;
	 
	 ОбъектДокумента = РеквизитФормыВЗначение("Объект");
	 ОбъектДокумента.УстановитьПометкуУдаления(НЕ ОбъектДокумента.ПометкаУдаления);
	 ЗначениеВРеквизитФормы(ОбъектДокумента, "Объект");
	 
	 ОбновитьСтатусДокумента();
	 
 КонецПроцедуры
 
 &НаКлиенте
 Процедура КомандаПометкаУдаления(Команда)
	 КомандаПометкаУдаленияНаСервере();
 КонецПроцедуры
 
 &НаСервере
 Процедура КомандаПровестиРаспровестиНаСервере()
	 
	 ОбъектДокумента = РеквизитФормыВЗначение("Объект");
	 Если (Объект.Проведен) Тогда
		 ОбъектДокумента.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	 Иначе
		 ОбъектДокумента.Дата = ТекущаяДата();
		 ОбъектДокумента.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
	 КонецЕсли;
	 ЗначениеВРеквизитФормы(ОбъектДокумента, "Объект");
	 
	 ОбновитьСтатусДокумента();
	 
 КонецПроцедуры
 &НаСервере
 Процедура ОбновитьВидКнопкиПровестиРаспровести()    
	 
	 ТекстЗаголовка = ?(Объект.Проведен, "Отменить проведение", "Провести");
	 Элементы.ФормаКомандаПровестиРаспровести.Заголовок = ТекстЗаголовка;  
	 
 КонецПроцедуры
 
 &НаСервере
 Процедура ОбновитьВидКнопкиПометкаУдаления()        
	 
	 ТекстЗаголовка = ?(Объект.ПометкаУдаления, "Снять пометку удаления", "Установить пометку удаления");
	 Элементы.ФормаКомандаПометкаУдаления.Заголовок = ТекстЗаголовка;  
	 
 КонецПроцедуры
 
 
 
 &НаКлиенте
 Процедура КомандаПровестиРаспровести(Команда)
	 КомандаПровестиРаспровестиНаСервере();
 КонецПроцедуры
 
 &НаКлиенте
 Процедура ЗаполнениеТаблицы(Команда)
	 
	 
	 ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, РежимПодбора", Истина, Истина);
	 ОткрытьФорму("Документ.ПриходнаяНакладная.Форма.ФормаВыбора",ПараметрыФормы, ЭтотОбъект);
	 
 КонецПроцедуры
 
 
 