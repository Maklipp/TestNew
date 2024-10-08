
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтотОбъект.ДополнительнаяИнформация = ЭтотОбъект.Параметры.ПереданнаяИнформация;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ("ВЫБРАТЬ
	|	ДополнительныеСвойстваТовара.Ссылка КАК Свойства,
	|	СвойстваТовара.Значение КАК Значение,
	|	&Товар КАК Товар
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеСвойстваТовара КАК ДополнительныеСвойстваТовара
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СвойстваТовара КАК СвойстваТовара
	|		ПО (ДополнительныеСвойстваТовара.Ссылка = СвойстваТовара.Свойство)
	|			И (СвойстваТовара.Товар = &Товар)");
	
	Запрос.УстановитьПараметр("Товар", Объект.Ссылка);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Таблица.Загрузить(РезультатЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.АссортиментныйСтатус = ВыборКартинкиДляКлассаНоменклатуры(Объект.КлассНоменклатуры);
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидТовара) Тогда
		Отказ = Истина;
		Сообщить("Не заполнено поле ""Вид товара""");
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыборКартинкиДляКлассаНоменклатуры(КлассНоменклатуры)
	
	Если КлассНоменклатуры = Перечисления.КлассНоменклатуры.А Тогда
		Значение = 28;
	ИначеЕсли КлассНоменклатуры = Перечисления.КлассНоменклатуры.В Тогда
		Значение = 29;
	ИначеЕсли КлассНоменклатуры = Перечисления.КлассНоменклатуры.С Тогда
		Значение = 32;
	ИначеЕсли КлассНоменклатуры = Перечисления.КлассНоменклатуры.СнятСПродаж Тогда
		Значение = 34;
	Иначе 
		Значение = 35;
	КонецЕсли; 
	
	Возврат Значение
	
КонецФункции

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Для каждого Строка из Таблица Цикл
		МЗ = РегистрыСведений.СвойстваТовара.СоздатьМенеджерЗаписи();
		МЗ.Товар = Объект.Ссылка;
		МЗ.Свойство = Строка.Свойства;
		МЗ.Значение = Строка.Значение;
		МЗ.Записать();
	КонецЦикла; 
	
	// Создание записи в РС.КлассНоменклатуры
	МЗ = РегистрыСведений.КлассНоменклатуры.СоздатьМенеджерЗаписи();
	МЗ.Период = ТекущаяДата();
	МЗ.Номенклатура = Объект.Ссылка;
	МЗ.Класс = Объект.КлассНоменклатуры;
	МЗ.Записать();
	
КонецПроцедуры
