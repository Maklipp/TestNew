
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСтатусПеремещения();
	
	Если Параметры.ЗаполнениеИзОбработки Тогда
		
		ОбъектДокумента = РеквизитФормыВЗначение("Объект");
		ОбъектДокумента.Дата=ТекущаяДата();
		
		ОбъектДокумента.ФилиалОтправитель = Параметры.ФилиалОтправитель;
		ОбъектДокумента.ФилиалПолучатель = Параметры.ФилиалПолучатель;
		
		
		ТабЧасть = ПолучитьИзВременногоХранилища(Параметры.Адрес); 
		Для каждого Строка из ТабЧасть Цикл
			СтрокаТабЧасти = ОбъектДокумента.Состав.Добавить();
			СтрокаТабЧасти.Номенклатура = Строка.Номенклатура;
			СтрокаТабЧасти.Количество = Строка.Количество; 
		КонецЦикла;
		
		ЗначениеВРеквизитФормы(ОбъектДокумента,"Объект");
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ОбновитьСтатусПеремещения()
	
	Если Элементы.СтатусПеремещения.СписокВыбора.Количество() < 2 Тогда
		Элементы.СтатусПеремещения.СписокВыбора.Добавить(Перечисления.СтатусПеремещенияТоваров.Принят,"Принят");
	КонецЕсли;
	
	Если Объект.СтатусПеремещения <> Перечисления.СтатусПеремещенияТоваров.Принят Тогда
		Если Объект.СтатусПеремещения = Перечисления.СтатусПеремещенияТоваров.ВПути И Объект.Проведен = Истина Тогда
		Иначе
			Элементы.СтатусПеремещения.СписокВыбора.Удалить(1);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьСтатусПеремещения();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбновитьСтатусПеремещения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если  Не ЗначениеЗаполнено(Объект.ФилиалПолучатель) Тогда
		Отказ = Истина;
		Сообщить("Филиал получатель не выбран"); 
		
	Иначе
		
		Если  Не ЗначениеЗаполнено(Объект.АвторПолучатель) Тогда
			Сообщить("Автор получатель не выбран");
			
			ПараметрыОтбора = Новый Структура("ФилиалРаботы",Объект.ФилиалПолучатель);
			СтруктураПараметров = Новый Структура("РежимВыбора",Истина);
			СтруктураПараметров.Вставить("Отбор", ПараметрыОтбора);
			СтруктураПараметров.Вставить("Заголовок","Выберите сотрудника получателя:");
			СтруктураПараметров.Вставить("ВызовФормыВыбора",Истина);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗакрытииФормыВыбора",ЭтотОбъект);
			ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаВыбора",СтруктураПараметров,ЭтотОбъект,,,,ОписаниеОповещения);
			Отказ = Истина;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриЗакрытииФормыВыбора (Автор,ДополнительныеПараметры) Экспорт
	
	Если Автор <> Неопределено Тогда
		Объект.АвторПолучатель = Автор;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставЦенаИЛИКоличествоПриИзменении(Элемент)
	
	ТекДанные = Элементы.Состав.ТекущиеДанные;
	Если (ТекДанные <> Неопределено) Тогда
		ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
	КонецЕсли;
	ПересчитатьСуммуДокумента();  
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Состав.Итог("Сумма");
	
КонецПроцедуры




