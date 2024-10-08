
&НаСервере
Процедура ВывестиСписокГородовНаСервере()

		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Города.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Города КАК Города
		|
		|УПОРЯДОЧИТЬ ПО
		|	Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Сообщить("Пусто");
		Возврат
	КонецЕсли;
		
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
	    Сообщить("Пусто");
		Возврат
	КонецЕсли;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить(ВыборкаДетальныеЗаписи.Наименование);
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

КонецПроцедуры

&НаКлиенте
Процедура ВывестиСписокГородов(Команда)
	ВывестиСписокГородовНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВывестиГородаВТабДокНаСервере()
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Макет = Обработки.ЗапросСпискаГородов.ПолучитьМакет("Макет");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Города.Наименование КАК Наименование,
		|	Города.Численность КАК Численность,
		|	Города.Округ КАК Округ
		|ИЗ
		|	Справочник.Города КАК Города
		|ГДЕ
		|	Города.Численность > &Численность
		|
		|УПОРЯДОЧИТЬ ПО
		|	Численность УБЫВ";
	
	Запрос.УстановитьПараметр("Численность", ЧисленностьНаселенияОт);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
		ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень());
	КонецЦикла;
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА


	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиГородаВТабДок(Команда)
	ВывестиГородаВТабДокНаСервере();
КонецПроцедуры
