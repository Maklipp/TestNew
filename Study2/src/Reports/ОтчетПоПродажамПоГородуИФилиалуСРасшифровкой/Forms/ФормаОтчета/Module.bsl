
&НаСервере
Процедура СформироватьНаСервере()
	
	Если Не ЗначениеЗаполнено(Период.ДатаНачала) или Не ЗначениеЗаполнено(Период.ДатаОкончания) ИЛИ СписокГородов.Количество() = 0 Тогда
		Сообщить("Не все параметры заполнены");
		Возврат
	КонецЕсли;
	
	ТабДок.Очистить(); 
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Филиалы.Ссылка КАК Ссылка,
	                      |	Филиалы.Город.Наименование КАК ГородНаименование,
	                      |	Филиалы.Наименование КАК Наименование
	                      |ПОМЕСТИТЬ ВТ_Филиалы
	                      |ИЗ
	                      |	Справочник.Филиалы КАК Филиалы
	                      |ГДЕ
	                      |	Филиалы.Город.Ссылка В(&СписокГородов)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВТ_Филиалы.ГородНаименование КАК Город,
	                      |	ВТ_Филиалы.Ссылка КАК Филиал,
	                      |	ПродажаТовараОбороты.Регистратор КАК Документ,
	                      |	ПродажаТовараОбороты.Номенклатура КАК Товар,
	                      |	ПродажаТовараОбороты.СуммаПродажиОборот КАК СуммаПродажи,
	                      |	ПродажаТовараОбороты.СебестоимостьОборот КАК Себестоимость,
	                      |	ВЫБОР
	                      |		КОГДА ПродажаТовараОбороты.СебестоимостьОборот > 0
	                      |			ТОГДА (ПродажаТовараОбороты.СуммаПродажиОборот - ПродажаТовараОбороты.СебестоимостьОборот) / ПродажаТовараОбороты.СебестоимостьОборот
	                      |		ИНАЧЕ 0
	                      |	КОНЕЦ КАК ПроцентПрибыли,
	                      |	ПродажаТовараОбороты.КоличествоОборот КАК Количество
	                      |ИЗ
	                      |	ВТ_Филиалы КАК ВТ_Филиалы
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПродажаТовара.Обороты(&Дата1, &Дата2, Регистратор, ) КАК ПродажаТовараОбороты
	                      |		ПО ВТ_Филиалы.Ссылка = ПродажаТовараОбороты.Филиал
	                      |ИТОГИ
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Документ),
	                      |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Товар),
	                      |	СУММА(СуммаПродажи),
	                      |	СРЕДНЕЕ(ПроцентПрибыли),
	                      |	СУММА(Количество)
	                      |ПО
	                      |	Город,
	                      |	Филиал");
	
	Запрос.УстановитьПараметр("Дата1",Период.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2",Период.ДатаОкончания);
	Запрос.УстановитьПараметр("СписокГородов",СписокГородов);
	
	ВыборкаГород = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Город");
	
	ОбъектОтчет = РеквизитФормыВЗначение("Отчет");
	Макет = ОбъектОтчет.ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьГород = Макет.ПолучитьОбласть("Город");
	ОбластьФилиал = Макет.ПолучитьОбласть("Филиал");
	ОбластьДокумент = Макет.ПолучитьОбласть("Документ");

	 ТабДок.Вывести(ОбластьШапка);
	 ТабДок.НачатьАвтогруппировкуСтрок();
	 
	 Пока ВыборкаГород.Следующий() Цикл
		 ОбластьГород.Параметры.Заполнить(ВыборкаГород);
		 ТабДок.Вывести(ОбластьГород,ВыборкаГород.Уровень());
		 
		 ВыборкаФилиалы = ВыборкаГород.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"Филиал");
		 Пока ВыборкаФилиалы.Следующий() Цикл
			 ОбластьФилиал.Параметры.Заполнить(ВыборкаФилиалы);
			 СтруктураРасшифрровки = Новый Структура("Филиал,ПроцентПрибыли");
			 СтруктураРасшифрровки.Филиал = ВыборкаФилиалы.Филиал;
			 СтруктураРасшифрровки.ПроцентПрибыли = Окр(ВыборкаФилиалы.ПроцентПрибыли,2); 
			 ОбластьФилиал.Параметры.ФилиалРасшифровка = СтруктураРасшифрровки;
			 
			 ТабДок.Вывести(ОбластьФилиал,ВыборкаФилиалы.Уровень());
			 
			 ВыборкаДокумент = ВыборкаФилиалы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"");
			 Пока ВыборкаДокумент.Следующий() Цикл
				 ОбластьДокумент.Параметры.Заполнить(ВыборкаДокумент);
				 ОбластьДокумент.Параметры.ДокументСсылка = ВыборкаДокумент.Документ; 
				 ТабДок.Вывести(ОбластьДокумент,ВыборкаДокумент.Уровень());
			 КонецЦикла;
		 КонецЦикла;
	 КонецЦикла;
	 
	 ТабДок.ЗакончитьАвтогруппировкуСтрок();

КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		Расшифровка.Вставить("ДатаС",Период.ДатаНачала);
		Расшифровка.Вставить("ДатаПо",Период.ДатаОкончания);
        Расшифровка.Вставить("ДатаПо",Период.ДатаОкончания);
        ПарамтрыОткрытия = Новый Структура("СтруктураДляОтчета",Расшифровка);
		ОткрытьФорму("Отчет.ОтчетПоПродажамПоГородуИФилиалуСРасшифровкой.Форма.ФормаРасшифровка",ПарамтрыОткрытия);
		
	КонецЕсли;
	
КонецПроцедуры
