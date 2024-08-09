&НаСервере
Процедура РассчитатьНаСервере()
	
	
	ТабЧасть.Очистить();
	
	ЗапросНоменклатуры = Новый Запрос("ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(ПродажаТовараОбороты.СуммаПродажиОборот), 0) КАК СуммаПродаж,
	|	ОстаткиТовараОстатки.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_СуммаПродаж
	|ИЗ
	|	РегистрНакопления.ОстаткиТовара.Остатки КАК ОстаткиТовараОстатки
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрНакопления.ПродажаТовара.Обороты(&ПериодНачало, &ПериодКонец, Запись, ) КАК ПродажаТовараОбороты
	|		ПО ОстаткиТовараОстатки.Номенклатура = ПродажаТовараОбороты.Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиТовараОстатки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлассНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	|	КлассНоменклатурыСрезПоследних.Класс КАК Класс
	|ПОМЕСТИТЬ ВТ_СнятыеСПродажи
	|ИЗ
	|	РегистрСведений.КлассНоменклатуры.СрезПоследних(&ПериодКонец, Класс = ЗНАЧЕНИЕ(Перечисление.КлассНоменклатуры.СнятСПродаж)) КАК КлассНоменклатурыСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.ПометкаУдаления КАК ПометкаУдаления
	|ПОМЕСТИТЬ ВТ_ПометкаНаУдаление
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ПометкаУдаления = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТ_СуммаПродаж.СуммаПродаж) КАК СуммаПродаж,
	|	ВТ_СуммаПродаж.Номенклатура КАК Номенклатура
	|ИЗ
	|	ВТ_СуммаПродаж КАК ВТ_СуммаПродаж
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СнятыеСПродажи КАК ВТ_Класс
	|		ПО ВТ_СуммаПродаж.Номенклатура = ВТ_Класс.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ПометкаНаУдаление КАК ВТ_Пометка
	|		ПО ВТ_СуммаПродаж.Номенклатура = ВТ_Пометка.Ссылка
	|ГДЕ
	|	ВТ_Класс.Класс ЕСТЬ NULL
	|	И ВТ_Пометка.ПометкаУдаления ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_СуммаПродаж.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	СуммаПродаж УБЫВ
	|ИТОГИ
	|	СУММА(СуммаПродаж)
	|ПО
	|	ОБЩИЕ");
	
	
	ЗапросНоменклатуры.УстановитьПараметр("ПериодНачало",ТекущаяДата()  - 60*60*24*30);
	ЗапросНоменклатуры.УстановитьПараметр("ПериодКонец",ТекущаяДата());
	
	Выборка = ЗапросНоменклатуры.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ОбщаяСумма = Выборка.СуммаПродаж;
		ГраницаА = Истина;
		ГраницаВ =Истина;
		ОбходКатегорииА = Истина;
		ОбходКатегорииВ = Ложь;
		ОбходКатегорииС = Ложь;
		ТекущаяСумма = 0;
		СуммаПредыдущегоЗначения = 0;
		
		ВыборкаОбход = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"");
		
		Пока ВыборкаОбход.Следующий() Цикл 
			
			СтрокаТабЧасти = ТабЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабЧасти,ВыборкаОбход);
			
			ТекущаяСумма = ТекущаяСумма + ВыборкаОбход.СуммаПродаж;
			
			Если НЕ ГраницаА И ОбходКатегорииА  Тогда
				Если СуммаПредыдущегоЗначения = ВыборкаОбход.СуммаПродаж Тогда
					ГраницаА = Истина;
				Иначе
					ОбходКатегорииА = Ложь;
					ОбходКатегорииВ = Истина;
				КонецЕсли;
			КонецЕсли;
			
			Если ОбходКатегорииА Тогда
				Если ТекущаяСумма < ОбщаяСумма / 100 * КатегорияА  Тогда
					Категория = Перечисления.КлассНоменклатуры.А;
				ИначеЕсли ГраницаА Тогда
					Категория = Перечисления.КлассНоменклатуры.А;
					ГраницаА = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ ГраницаВ И ОбходКатегорииВ  Тогда
				Если СуммаПредыдущегоЗначения = ВыборкаОбход.СуммаПродаж Тогда
					ГраницаВ = Истина;
				Иначе
					ОбходКатегорииВ = Ложь;
					ОбходКатегорииС = Истина;
				КонецЕсли;
			КонецЕсли;
			
			Если ОбходКатегорииВ Тогда
				Если ТекущаяСумма < ОбщаяСумма / 100 * КатегорияВ  Тогда
					Категория = Перечисления.КлассНоменклатуры.В;
				ИначеЕсли ГраницаВ Тогда
					Категория = Перечисления.КлассНоменклатуры.В;
					ГраницаВ = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ОбходКатегорииС Тогда
				Категория = Перечисления.КлассНоменклатуры.С;
			КонецЕсли;
			
			СуммаПредыдущегоЗначения = ВыборкаОбход.СуммаПродаж;
			СтрокаТабЧасти.Класс = Категория;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	
	Если ПроверкаВводимыхДанных() Тогда
		Возврат
	КонецЕсли;
	
	РассчитатьНаСервере(); 
	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаВводимыхДанных()
	
	Если КатегорияВ < КатегорияА ИЛИ КатегорияВ > КатегорияС Тогда
		Сообщить("Класс А должен быть меньше класса Б, а класс Б должен быть меньше класса С");
		Возврат Истина
	КонецЕсли;
	
	Возврат Ложь
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КатегорияС = 100;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНаСервере()
	
	Для Каждого Строка Из ТабЧасть Цикл
		
		МЗ = РегистрыСведений.КлассНоменклатуры.СоздатьМенеджерЗаписи();
		МЗ.Период = ТекущаяДата();
		МЗ.Номенклатура = Строка.Номенклатура;
		МЗ.Класс = Строка.Класс;
		МЗ.Записать();
		
		ОбъектНоменклатура = Строка.Номенклатура.ПолучитьОбъект();
		ОбъектНоменклатура.КлассНоменклатуры = Строка.Класс;
		
		//выбор картинки соответствующего класса
		Если Строка.Класс = Перечисления.КлассНоменклатуры.А Тогда
			ОбъектНоменклатура.АссортиментныйСтатус = 28;
		ИначеЕсли Строка.Класс = Перечисления.КлассНоменклатуры.В Тогда
			ОбъектНоменклатура.АссортиментныйСтатус = 29;
		Иначе
			ОбъектНоменклатура.АссортиментныйСтатус = 32;
		КонецЕсли; 
		
		ОбъектНоменклатура.Записать();	
		
	КонецЦикла;	 
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНаСервере();
КонецПроцедуры