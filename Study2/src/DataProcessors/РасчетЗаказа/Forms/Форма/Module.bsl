
&НаСервере
Процедура СформироватьНаСервере()
	
	ТабЧасть.Очистить();
	
	ЗапросДанных = Новый Запрос("ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА Номенклатура.Категория ЕСТЬ NULL
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Категория
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	(&НеПроверятьНоменклатуру
	|			ИЛИ Номенклатура.Ссылка В (&Номенклатура))
	|	И Номенклатура.ЭтоГруппа = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиТовараОстатки.Номенклатура КАК Номенклатура,
	|	СУММА(ОстаткиТовараОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ВТ_ТекущийОстатокБезГруппировки
	|ИЗ
	|	РегистрНакопления.ОстаткиТовара.Остатки(
	|			,
	|			(&НеПроверятьФилиал
	|				ИЛИ Филиал В (&Филиал))
	|				И (&НеПроверятьНоменклатуру
	|					ИЛИ Номенклатура В (&Номенклатура))) КАК ОстаткиТовараОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиТовараОстатки.Номенклатура
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ТранзитТоваровОстатки.Номенклатура,
	|	СУММА(ТранзитТоваровОстатки.КоличествоОстаток)
	|ИЗ
	|	РегистрНакопления.ТранзитТоваров.Остатки(
	|			,
	|			(&НеПроверятьФилиал
	|				ИЛИ ФилиалПолучатель В (&Филиал))
	|				И (&НеПроверятьНоменклатуру
	|					ИЛИ Номенклатура В (&Номенклатура))) КАК ТранзитТоваровОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ТранзитТоваровОстатки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТекущийОстатокБезГруппировки.Номенклатура КАК Номенклатура,
	|	СУММА(ВТ_ТекущийОстатокБезГруппировки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ВТ_ТекущийОстаток
	|ИЗ
	|	ВТ_ТекущийОстатокБезГруппировки КАК ВТ_ТекущийОстатокБезГруппировки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ТекущийОстатокБезГруппировки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА КлассНоменклатурыСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.КлассНоменклатуры.А)
	|			ТОГДА 2
	|		КОГДА КлассНоменклатурыСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.КлассНоменклатуры.В)
	|			ТОГДА 1.5
	|		КОГДА КлассНоменклатурыСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.КлассНоменклатуры.С)
	|			ТОГДА 1
	|		КОГДА КлассНоменклатурыСрезПоследних.Класс = ЗНАЧЕНИЕ(Перечисление.КлассНоменклатуры.СнятСПродаж)
	|			ТОГДА 0
	|	КОНЕЦ КАК Класс,
	|	КлассНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	|	КлассНоменклатурыСрезПоследних.Класс КАК КлассБуквы
	|ПОМЕСТИТЬ ВТ_Класс
	|ИЗ
	|	РегистрСведений.КлассНоменклатуры.СрезПоследних(
	|			,
	|			&НеПроверятьНоменклатуру
	|				ИЛИ Номенклатура В (&Номенклатура)) КАК КлассНоменклатурыСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиТовараОбороты.Номенклатура КАК Номенклатура,
	|	СУММА(ОстаткиТовараОбороты.КоличествоРасход) КАК КоличествоРасход
	|ПОМЕСТИТЬ ВТ_ПроданоЗаПериод
	|ИЗ
	|	РегистрНакопления.ОстаткиТовара.Обороты(
	|			&ПериодНачало,
	|			&ПериодКонец,
	|			Запись,
	|			(&НеПроверятьФилиал
	|				ИЛИ Филиал В (&Филиал))
	|				И (&НеПроверятьНоменклатуру
	|					ИЛИ Номенклатура В (&Номенклатура))) КАК ОстаткиТовараОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиТовараОбороты.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МинимальныйОстатокТовараНаФилиалеСрезПоследних.Номенклатура КАК Номенклатура,
	|	СУММА(МинимальныйОстатокТовараНаФилиалеСрезПоследних.Количество) КАК Количество
	|ПОМЕСТИТЬ ВТ_МинимальныйОстаток
	|ИЗ
	|	РегистрСведений.МинимальныйОстатокТовараНаФилиале.СрезПоследних(
	|			,
	|			(&НеПроверятьФилиал
	|				ИЛИ Филиал В (&Филиал))
	|				И (&НеПроверятьНоменклатуру
	|					ИЛИ Номенклатура В (&Номенклатура))) КАК МинимальныйОстатокТовараНаФилиалеСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	МинимальныйОстатокТовараНаФилиалеСрезПоследних.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказанныеТоварыОбороты.Номенклатура КАК Номенклатура,
	|	СУММА(ЗаказанныеТоварыОбороты.КоличествоОборот) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ВТ_УжеЗаказано
	|ИЗ
	|	РегистрНакопления.ЗаказанныеТовары.Обороты(
	|			,
	|			,
	|			Запись,
	|			(&НеПроверятьФилиал
	|				ИЛИ Филиал В (&Филиал))
	|				И (&НеПроверятьНоменклатуру
	|					ИЛИ Номенклатура В (&Номенклатура))) КАК ЗаказанныеТоварыОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказанныеТоварыОбороты.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Номенклатура.Номенклатура КАК Номенклатура,
	|	ВТ_Класс.КлассБуквы КАК Класс,
	|	ЕСТЬNULL(ВТ_ТекущийОстаток.КоличествоОстаток, 0) КАК ТекущийОстаток,
	|	ЕСТЬNULL(ВТ_ПроданоЗаПериод.КоличествоРасход, 0) КАК ПроданоЗаПериод,
	|	ЕСТЬNULL(ВТ_МинимальныйОстаток.Количество, 0) КАК МинимальныйОстаток,
	|	ЕСТЬNULL(ВТ_УжеЗаказано.КоличествоОстаток, 0) КАК УжеЗаказано,
	|	ЕСТЬNULL(ВТ_Класс.Класс, 0) КАК КлассКоэффициент
	|ИЗ
	|	ВТ_Номенклатура КАК ВТ_Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Класс КАК ВТ_Класс
	|		ПО ВТ_Номенклатура.Номенклатура = ВТ_Класс.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТекущийОстаток КАК ВТ_ТекущийОстаток
	|		ПО ВТ_Номенклатура.Номенклатура = ВТ_ТекущийОстаток.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПроданоЗаПериод КАК ВТ_ПроданоЗаПериод
	|		ПО ВТ_Номенклатура.Номенклатура = ВТ_ПроданоЗаПериод.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_МинимальныйОстаток КАК ВТ_МинимальныйОстаток
	|		ПО ВТ_Номенклатура.Номенклатура = ВТ_МинимальныйОстаток.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_УжеЗаказано КАК ВТ_УжеЗаказано
	|		ПО ВТ_Номенклатура.Номенклатура = ВТ_УжеЗаказано.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура");
	
	ЗапросДанных.УстановитьПараметр("ПериодНачало",Период.ДатаНачала);
	ЗапросДанных.УстановитьПараметр("ПериодКонец",Период.ДатаОкончания);
	ЗапросДанных.УстановитьПараметр("Номенклатура",Номенклатура);
	ЗапросДанных.УстановитьПараметр("Филиал",Филиалы);
	
	Если Номенклатура.Количество() > 0 Тогда
		ЗапросДанных.УстановитьПараметр("НеПроверятьНоменклатуру",Ложь);
	Иначе
		ЗапросДанных.УстановитьПараметр("НеПроверятьНоменклатуру",Истина);
	КонецЕсли;
	
	Если Филиалы.Количество() > 0 Тогда
		ЗапросДанных.УстановитьПараметр("НеПроверятьФилиал",Ложь);
	Иначе
		ЗапросДанных.УстановитьПараметр("НеПроверятьФилиал",Истина);
	КонецЕсли;
	
	Выборка = ЗапросДанных.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТабЧасть.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		КЗаказу = Выборка.ПроданоЗаПериод - Выборка.ТекущийОстаток;
		Если Выборка.МинимальныйОстаток > Выборка.ПроданоЗаПериод Тогда
			КЗаказу = Выборка.МинимальныйОстаток - Выборка.ТекущийОстаток;
		КонецЕсли;
		КЗаказу = КЗаказу * Выборка.КлассКоэффициент;
		КЗаказу = КЗаказу - Выборка.УжеЗаказано;
		
		Если КЗаказу < 0 Тогда
			НоваяСтрока.КЗаказу = 0;
		Иначе
			НоваяСтрока.КЗаказу = КЗаказу;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Функция ПоместитьВоВременноеХранилищеТабЧасть()
	
	ТаблицаДляПередачиДанных = Новый ТаблицаЗначений;
	ТаблицаДляПередачиДанных.Колонки.Добавить("Номенклатура");
	ТаблицаДляПередачиДанных.Колонки.Добавить("Количество");
	
	Для Каждого Строка Из ТабЧасть Цикл
		Если Строка.КЗаказу > 0 Тогда
			НоваяСтрока = ТаблицаДляПередачиДанных.Добавить();
			НоваяСтрока.Номенклатура = Строка.Номенклатура;
			НоваяСтрока.Количество = Строка.КЗаказу;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДанныхРасчетаЗаказа = Новый УникальныйИдентификатор;
	Адрес = ПоместитьВоВременноеХранилище(ТаблицаДляПередачиДанных, ТаблицаДанныхРасчетаЗаказа);
	Возврат Адрес
	
КонецФункции

&НаКлиенте
Процедура СоздатьЗаказПоставщику(Команда)
	
	ПередаваемыеДанные = Новый Структура("ЗаполнениеИзОбработки",ИСТИНА);
	ПередаваемыеДанные.Вставить("Филиал",Филиалы);
	Адрес = ПоместитьВоВременноеХранилищеТабЧасть();
	ПередаваемыеДанные.Вставить("Адрес",Адрес);
	
	ОткрытьФорму("Документ.ЗаказПоставщику.Форма.ФормаДокумента",ПередаваемыеДанные,ЭтотОбъект);
	
КонецПроцедуры

