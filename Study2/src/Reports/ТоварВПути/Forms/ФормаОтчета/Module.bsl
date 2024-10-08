
&НаСервере
Процедура СформироватьНаСервере()
	
	ТабДок.Очистить();
	
	Если НЕ ЗначениеЗаполнено(Филиал) Тогда
		Сообщить("Выберите филиал");
		Возврат
	конецЕсли;
	
	ЗапросДанных = Новый Запрос("ВЫБРАТЬ
	|	ТранзитТоваровОбороты.Номенклатура КАК Номенклатура,
	|	СУММА(ТранзитТоваровОбороты.КоличествоОборот) КАК Количество,
	|	РАЗНОСТЬДАТ(МИНИМУМ(ТранзитТоваровОбороты.Период), &ДатаТекущая, ДЕНЬ) КАК ДнейВПути,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТранзитТоваровОбороты.Регистратор) КАК КоличествоПоставок,
	|	ТранзитТоваровОбороты.Регистратор.Ссылка КАК Регистратор
	|ИЗ
	|	РегистрНакопления.ТранзитТоваров.Обороты(, , Запись, ФилиалПолучатель = &Филиал) КАК ТранзитТоваровОбороты
	|ГДЕ
	|	ТранзитТоваровОбороты.Регистратор.СтатусПеремещения = ЗНАЧЕНИЕ(Перечисление.СтатусПеремещенияТоваров.ВПути)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТранзитТоваровОбороты.Номенклатура,
	|	ТранзитТоваровОбороты.Регистратор.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаказанныеТоварыОбороты.Номенклатура,
	|	СУММА(ЗаказанныеТоварыОбороты.КоличествоОборот),
	|	РАЗНОСТЬДАТ(МИНИМУМ(ЗаказанныеТоварыОбороты.Период), &ДатаТекущая, ДЕНЬ),
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказанныеТоварыОбороты.Заказ),
	|	ЗаказанныеТоварыОбороты.Заказ.Ссылка
	|ИЗ
	|	РегистрНакопления.ЗаказанныеТовары.Обороты(, , Запись, Филиал = &Филиал) КАК ЗаказанныеТоварыОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказанныеТоварыОбороты.Номенклатура,
	|	ЗаказанныеТоварыОбороты.Заказ.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|ИТОГИ
	|	СУММА(Количество),
	|	МАКСИМУМ(ДнейВПути),
	|	СУММА(КоличествоПоставок)
	|ПО
	|	Номенклатура");
	
	ЗапросДанных.УстановитьПараметр("Филиал",Филиал);
	ЗапросДанных.УстановитьПараметр("ДатаТекущая",ТекущаяДата());
	
	Выборка = ЗапросДанных.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,);
	
	ОбъектОтчет = РеквизитФормыВЗначение("Отчет");
	Макет = ОбъектОтчет.ПолучитьМакет("Макет");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ТабДок.Вывести(ОбластьШапка);
	
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		
		СтруктураРасшифровки = Новый Структура;
		СтруктураРасшифровки.Вставить("Товар",Выборка.Номенклатура);
		СтруктураРасшифровки.Вставить("Филиал",Филиал);
		
		ТаблицаДляПередачи = Новый ТаблицаЗначений;
		ТаблицаДляПередачи.Колонки.Добавить("Перемещение");
		ТаблицаДляПередачи.Колонки.Добавить("КоличествоТовара");
		ТаблицаДляПередачи.Колонки.Добавить("ДнейВПути");
		
		ВыборкаДляРасшифровки = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,);		
		Пока ВыборкаДляРасшифровки.Следующий() Цикл 
			СтрокаТаблицы = ТаблицаДляПередачи.Добавить();
			СтрокаТаблицы.Перемещение = ВыборкаДляРасшифровки.Регистратор;
			СтрокаТаблицы.КоличествоТовара = ВыборкаДляРасшифровки.Количество;
			СтрокаТаблицы.ДнейВПути = ВыборкаДляРасшифровки.ДнейВПути;
		КонецЦикла;
		
		АдресТаблицы = ПоместитьВоВременноеХранилище(ТаблицаДляПередачи, Новый УникальныйИдентификатор);
		СтруктураРасшифровки.Вставить("АдресТаблицы",АдресТаблицы);
		ОбластьСтрока.Параметры.РасшифровкаПеремещения = СтруктураРасшифровки;
		
		ТабДок.Вывести(ОбластьСтрока);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытия = Новый Структура("СтруктураДляОтчета",Расшифровка);
		ОткрытьФорму("Отчет.ТоварВПути.Форма.ФормаРасшифровки",ПараметрыОткрытия,,Новый УникальныйИдентификатор());
		
	КонецЕсли;
	
КонецПроцедуры
