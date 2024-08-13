
&НаКлиенте
Процедура СозданиеГруппыИЭлементов(Команда)
	СозданиеГруппыИЭлементовНаСервере();
КонецПроцедуры

&НаСервере
Процедура СозданиеГруппыИЭлементовНаСервере()
	
	ГруппаРазвитие = Справочники.Затраты.СоздатьГруппу();
	ГруппаРазвитие.Наименование = "Затраты на развитие";
	ГруппаРазвитие.Записать();
	
	Сервера = Справочники.Затраты.СоздатьЭлемент();
	Сервера.Наименование = "Покупка серверного оборудования";
	Сервера.Родитель = ГруппаРазвитие.Ссылка;
	Сервера.Примечание = "Закуп нового серверного оборудования для работы магазинов";
	Сервера.Записать();
	
	Обучение = Справочники.Затраты.СоздатьЭлемент();
	Обучение.Наименование = "Обучение персонала";
	Обучение.Родитель = ГруппаРазвитие.Ссылка;
	Обучение.Примечание = "";
	Обучение.Записать();
	
	ОбменОпытом = Справочники.Затраты.СоздатьЭлемент();
	ОбменОпытом.Наименование = "Стажировка/обмен опытом";
	ОбменОпытом.Родитель = ГруппаРазвитие.Ссылка;
	ОбменОпытом.Примечание = "Обмен опытом с другими компаниями";
	ОбменОпытом.Записать();

КонецПроцедуры

&НаКлиенте
Процедура МодификацияЗатраты(Команда)
	МодификацияЗатратыНаСервере();
КонецПроцедуры

&НаСервере
Процедура МодификацияЗатратыНаСервере()
	
	ЗначениеЭлемента = Затрата.ПолучитьОбъект();
	ЗначениеЭлемента.Примечание = Примечание;
	ЗначениеЭлемента.Записать();
	
КонецПроцедуры
