
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДобавитьПеречисления();
	ДобавитьПланыВидовХарактеристик();
	ДобавитьПланыСчетов();
	ДобавитьВидыДвижения();

КонецПроцедуры

&НаСервере
Процедура ДобавитьПеречисления()
	 
	стр = тпЗначения.ПолучитьЭлементы().Добавить();
	стр.Метаданные  = "Перечисления";
	стр.КодКартинки = 11;
	
	Для Каждого Перечисление из Метаданные.Перечисления Цикл
		стр1 = стр.ПолучитьЭлементы().Добавить();
		стр1.Метаданные 	= ?(ЗначениеЗаполнено(Перечисление.Синоним), Перечисление.Синоним, Перечисление.Имя);
		стр1.КодКартинки 	= -1;
		
		Для Каждого знчПеречисления из Перечисление.ЗначенияПеречисления Цикл
			стр2 = стр1.ПолучитьЭлементы().Добавить();
			стр2.Метаданные 			 = ?(ЗначениеЗаполнено(знчПеречисления.Синоним), знчПеречисления.Синоним, знчПеречисления.Имя);
			стр2.ПредставлениеДляЗапроса = "ЗНАЧЕНИЕ(Перечисление." + Перечисление.Имя + "." + знчПеречисления.Имя + ")";
			стр2.КодКартинки 			 = -1;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПланыВидовХарактеристик()
	
	стр = тпЗначения.ПолучитьЭлементы().Добавить();
	стр.Метаданные  = "Планы видов характеристик";
	стр.КодКартинки = 12;
	
	Для Каждого ПланВидовХарактеристик из Метаданные.ПланыВидовХарактеристик Цикл
		стр1 = стр.ПолучитьЭлементы().Добавить();
		Стр1.Метаданные 	= ПланВидовХарактеристик.Имя;
		Стр1.КодКартинки 	= -1;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ                                                                         
					|Ссылка,
					|Наименование
					|ИЗ ПланВидовХарактеристик." + ПланВидовХарактеристик.Имя + " КАК " + ПланВидовХарактеристик.Имя + Символы.ПС + "
					|ГДЕ " + ПланВидовХарактеристик.Имя + ".Предопределенный
					|УПОРЯДОЧИТЬ ПО Наименование"; 
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			стр2 = стр1.ПолучитьЭлементы().Добавить();
			стр2.Метаданные 			 = Выборка.Наименование;
			стр2.ПредставлениеДляЗапроса = "ЗНАЧЕНИЕ(ПланВидовХарактеристик." + ПланВидовХарактеристик.Имя + "." + ПланыВидовХарактеристик[ПланВидовХарактеристик.Имя].ПолучитьИмяПредопределенного(Выборка.Ссылка) + ")";;
			стр2.КодКартинки 			 = -1;
		КонецЦикла;
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПланыСчетов()
	стр = тпЗначения.ПолучитьЭлементы().Добавить();
	стр.Метаданные  = "Планы Счетов";
	стр.КодКартинки = 13;
	
	Для Каждого ПланСчетов из Метаданные.ПланыСчетов Цикл
		стр1 = стр.ПолучитьЭлементы().Добавить();
		Стр1.Метаданные 	= ?(ЗначениеЗаполнено(ПланСчетов.Синоним), ПланСчетов.Синоним + " (" + ПланСчетов.Имя + ")", ПланСчетов.Имя);
		Стр1.КодКартинки 	= -1;
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ                                                                         
					|Ссылка,
					|Наименование,
					|Код
					|ИЗ ПланСчетов." + ПланСчетов.Имя+ " КАК " + ПланСчетов.Имя + Символы.ПС + "
					|ГДЕ " + ПланСчетов.Имя + ".Предопределенный
					|УПОРЯДОЧИТЬ ПО
					|Порядок"; 
		Выборка = Запрос.Выполнить().Выбрать();
		ПустаяСтрока = "            ";
		Пока Выборка.Следующий() Цикл
			ДлинаКода = СтрДлина(Выборка.Код);
			ПромежуточнаяСтрока = Лев(ПустаяСтрока, 12 - ДлинаКода);
    		стр2 = стр1.ПолучитьЭлементы().Добавить();
			стр2.Метаданные 			 = Выборка.Код + ПромежуточнаяСтрока + Выборка.Наименование;
			стр2.ПредставлениеДляЗапроса = "ЗНАЧЕНИЕ(ПланСчетов." + ПланСчетов.Имя + "." + ПланыСчетов[ПланСчетов.Имя].ПолучитьИмяПредопределенного(Выборка.Ссылка) + ")";;
			стр2.КодКартинки 			 = -1;
		КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьГруппу(Строка, Имя, Тип, Значения, КодКартинки)
	
	стр1 = Строка.ПолучитьЭлементы().Добавить();
	стр1.Метаданные 	= Имя;
	стр1.КодКартинки 	= КодКартинки;   
	
	Строки = СтрЗаменить(Значения, ",", Символы.ВК);
	
	Для Сч = 1 По СтрЧислоСтрок(Строки) Цикл
		Значение = СтрПолучитьСтроку(Строки, Сч);
		стр2 = стр1.ПолучитьЭлементы().Добавить();
		стр2.Метаданные 			 = Значение;
		стр2.ПредставлениеДляЗапроса = "ЗНАЧЕНИЕ(" + Тип + "." + Значение + ")";
		стр2.КодКартинки 			 = -1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВидыДвижения()	
	стр = тпЗначения.ПолучитьЭлементы().Добавить();
	стр.Метаданные 	= "Виды движения";
	стр.КодКартинки = -1;
	ДобавитьГруппу(стр, "Регистры накопления", "ВидДвиженияНакопления", "Приход,Расход", 16);
	ДобавитьГруппу(стр, "Регистры бухгалтерии", "ВидДвиженияБухгалтерии", "Дебет,Кредит", 17);
	ДобавитьГруппу(стр, "Планы счетов", "ВидСчета", "Активный,Пассивный,АктивноПассивный", 13);
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПоУмолчанию(Команда)
	
	тпЗначения.ПолучитьЭлементы().Очистить();
	
	ДобавитьПеречисления();
	ДобавитьПланыВидовХарактеристик();
	ДобавитьПланыСчетов();
	ДобавитьВидыДвижения();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПоВозрастанию(Команда)
	
	СортироватьСервер("Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПоУбыванию(Команда)
	
	СортироватьСервер("Убыв");
	
КонецПроцедуры

&НаСервере
Процедура СортироватьСервер(_Направление)
	
	ВидСортировки = "Метаданные " + _Направление;
	
	ДЗ = ДанныеФормыВЗначение(тпЗначения, Тип("ДеревоЗначений"));
	
	Для Каждого Строка из ДЗ.Строки Цикл
		Строка.Строки.Сортировать(ВидСортировки, Ложь);	
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ДЗ, тпЗначения);
	
КонецПроцедуры
