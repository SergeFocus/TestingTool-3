&НаКлиенте
Перем Модуль_СервисныеФункции;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина; // форма не предназначена для открытия
КонецПроцедуры

#Область Команды

&НаКлиенте
Процедура мСценСкрипт_GenerateClientConnection(ТестовоеПриложение, ОписаниеОшибки, мПараметры) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	СвойстваПодключенияКлиентаТестирования = мПараметры.СвойстваПодключенияКлиентаТестирования;
	ПараметрыСценария = мПараметры.ПараметрыСценария;
	НомерПорта = мПараметры.НомерПорта;
	Интервал = мПараметры.Интервал; 
	ТекущийНомерПорта = мПараметры.ТекущийНомерПорта; 
	НомерПортаExternAutomationUI = мПараметры.НомерПортаExternAutomationUI;
	АдресИнтернетExternAutomationUI = мПараметры.АдресИнтернетExternAutomationUI;
	
	ПутьUrl = Модуль_СервисныеФункции.ПолучитьПутьUrl(АдресИнтернетExternAutomationUI, НомерПортаExternAutomationUI );
	
	
	Если Найти(СвойстваПодключенияКлиентаТестирования,"&") Тогда
		ИмяПараметра = СокрЛП(СтрЗаменить(СвойстваПодключенияКлиентаТестирования,"&",""));
		СвойстваПодключенияКлиентаТестирования = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра,ПараметрыСценария);
	КонецЕсли;	
	
	Попытка
		ОписаниеПодключения = мЗначениеИзСтрокиВнутр(СвойстваПодключенияКлиентаТестирования);
		Если ТипЗнч(ОписаниеПодключения)=Тип("Соответствие") Тогда
			Если ОписаниеПодключения.Получить("НомерПорта")<>Неопределено Тогда
				ТекущийНомерПорта = Число(ОписаниеПодключения.Получить("НомерПорта"));
			КонецЕсли;
		КонецЕсли;
	Исключение
		ТекущийНомерПорта = НомерПорта;
	КонецПопытки;

	
	ЗагрузитьБиблиотеки();

	// проверим связь, активна ли сессия?
	СтрокаКоманды = "&Operation=status_session&answer_format=json";
	СтрокаКоманды = СтрокаКоманды + "&session_id=" + ТекущийНомерПорта;
	СтруктураОтвета = Неопределено;

	СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl	+ "/rest.html?" + СтрокаКоманды);

	Если СтруктураОтвета.КодСостояния = 200 Тогда

		Текст = СтруктураОтвета.ТелоСтрокой;

		РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);

		Если Нрег(РезультатПреобразования.status) = "false" тогда
			ТестовоеПриложение = Неопределено;
		Иначе
			ТестовоеПриложение = Строка(ТекущийНомерПорта);
			Возврат;
		КонецЕсли;
	Иначе
		ТестовоеПриложение = Неопределено;
		ВызватьИсключение "Не удалось получить данные. Код состояния: "+СтруктураОтвета.КодСостояния;
	КонецЕсли;			

	
	Если ТестовоеПриложение=Неопределено или ТестовоеПриложение="" Тогда

		// подключимся к тестируемому приложению
		// и получим хеш
		СтрокаКоманды = "&Operation=new_predefined_session&answer_format=json";
		СтрокаКоманды = СтрокаКоманды + "&session_id=" + ТекущийНомерПорта;		
		СтруктураОтвета = Неопределено;

		СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl+"/rest.html?"
			+ СтрокаКоманды);

		Если НЕ СтруктураОтвета.КодСостояния = 200 Тогда
			ВызватьИсключение "Не удалось получить данные. Код состояния: "+СтруктураОтвета.КодСостояния;
		КонецЕсли;

		//Текст = СтруктураОтвета.ТелоСтрокой;
		//РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);		
		//ТестовоеПриложение = РезультатПреобразования.session_id;
		ТестовоеПриложение = Строка(ТекущийНомерПорта);
		
	КонецЕсли;
	
	мПараметры.ТекущийНомерПорта = ТекущийНомерПорта;
		
КонецПроцедуры

&НаКлиенте
Функция мСцен_ПолучитьЗначениеПараметра(Знач ИмяПараметра,ПараметрыСценария) Экспорт
	
	Для каждого стр из ПараметрыСценария Цикл
		Если ВРег(стр.Имя)=Врег(ИмяПараметра) Тогда
			Возврат стр.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервереБезКонтекста
Функция мЗначениеИзСтрокиВнутр(Значение) Экспорт
	Возврат ЗначениеИзСтрокиВнутр(Значение);
КонецФункции


&НаКлиенте
Процедура мСценСкрипт_GenerateClientDisconnection(ТестовоеПриложение, ОписаниеОшибки, мПараметры) Экспорт	

	//ЗагрузитьБиблиотеки();

		//НомерПортаExternAutomationUI = мПараметры.НомерПортаExternAutomationUI;
		//АдресИнтернетExternAutomationUI = мПараметры.АдресИнтернетExternAutomationUI;
	
		//ПутьUrl = Модуль_СервисныеФункции.ПолучитьПутьUrl(АдресИнтернетExternAutomationUI, НомерПортаExternAutomationUI );

	// подключимся к тестируемому приложению
		//СтрокаКоманды = "&Operation=delete_step&answer_format=json&session_id="+ТестовоеПриложение;
		//СтруктураОтвета = Неопределено;

		//СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl+"/rest.html?"+СтрокаКоманды);

		//Если НЕ СтруктураОтвета.КодСостояния=200 Тогда
			//ОписаниеОшибки =  "Не удалось получить данные";
		//КонецЕсли;
	
		//Текст = СтруктураОтвета.ТелоСтрокой;
	
	//РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);
	
	//ТестовоеПриложение = Текст; // guid сессии	

	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_НайтиОсновноеОкно(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная, мПараметры) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	PID = мПараметры.PID;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска;
	НомерПортаExternAutomationUI = мПараметры.НомерПортаExternAutomationUI;
	АдресИнтернетExternAutomationUI = мПараметры.АдресИнтернетExternAutomationUI;
	
	ПутьUrl = Модуль_СервисныеФункции.ПолучитьПутьUrl(АдресИнтернетExternAutomationUI, НомерПортаExternAutomationUI );
	
	// подключимся к тестируемому приложению
	СтрокаКоманды = "&Operation=play_step&answer_format=json&session_id="+ТестовоеПриложение;
	СтрокаКоманды = СтрокаКоманды + "&api=Automation UI";
	СтрокаКоманды = СтрокаКоманды + "&action=find main window";
	СтрокаКоманды = СтрокаКоманды + "&process_id="+PID;
	СтрокаКоманды = СтрокаКоманды + "&element_name="+ЗаголовокОбъекта;
	
	 
	СтруктураОтвета = Неопределено;

	СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl+"/rest.html?"+СтрокаКоманды);

	Если НЕ СтруктураОтвета.КодСостояния=200 Тогда
		ОписаниеОшибки =  "Не удалось получить данные";
	КонецЕсли;
	
	Текст = СтруктураОтвета.ТелоСтрокой;
	
	РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);
	
	Если НРег(РезультатПреобразования.error)="true" Тогда
		ОписаниеОшибки = РезультатПреобразования.message;
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_НайтиОкно(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,мПараметры) Экспорт

	ЗагрузитьБиблиотеки();

	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	PID = мПараметры.PID;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска;
	НомерПортаExternAutomationUI = мПараметры.НомерПортаExternAutomationUI;
	АдресИнтернетExternAutomationUI = мПараметры.АдресИнтернетExternAutomationUI;
	Интервал = мПараметры.Интервал;
	
	ПутьUrl = Модуль_СервисныеФункции.ПолучитьПутьUrl(АдресИнтернетExternAutomationUI, НомерПортаExternAutomationUI );

	// подключимся к тестируемому приложению
	СтрокаКоманды = "&Operation=play_step&answer_format=json&session_id="+ТестовоеПриложение;
	СтрокаКоманды = СтрокаКоманды + "&api=Automation UI";
	СтрокаКоманды = СтрокаКоманды + "&action=find window";
	СтрокаКоманды = СтрокаКоманды + "&process_id="+PID;
	СтрокаКоманды = СтрокаКоманды + "&element_name="+ЗаголовокОбъекта;
	СтрокаКоманды = СтрокаКоманды + "&interval="+Формат(Интервал,"ЧН=0; ЧГ=;");
	
	 
	СтруктураОтвета = Неопределено;

	СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl+"/rest.html?"+СтрокаКоманды);

	Если НЕ СтруктураОтвета.КодСостояния=200 Тогда
		ОписаниеОшибки =  "Не удалось получить данные";
	КонецЕсли;
	
	Текст = СтруктураОтвета.ТелоСтрокой;
	
	РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);
	
	Если НРег(РезультатПреобразования.error)="true" Тогда
		ОписаниеОшибки = РезультатПреобразования.message;
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_НайтиОбъект(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная, мПараметры) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	ТипОбъекта = мПараметры.ТипОбъекта;
	РодительПеременная = мПараметры.РодительПеременная;
	ИмяПеременнойРодителя = мПараметры.ИмяПеременнойРодителя;
	ИмяПеременной = мПараметры.ИмяПеременной;	
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	ИмяОбъекта = мПараметры.ИмяОбъекта;
	ИмяКлассаОбъекта = мПараметры.ИмяКлассаОбъекта;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска;
	НомерПортаExternAutomationUI = мПараметры.НомерПортаExternAutomationUI;
	АдресИнтернетExternAutomationUI = мПараметры.АдресИнтернетExternAutomationUI;
	ИдентификаторОбъекта = мПараметры.ИдентификаторОбъекта;
	Интервал = мПараметры.Интервал;
	ОдинУровеньВниз = мПараметры.ОдинУровеньВниз;
	
	ПутьUrl = Модуль_СервисныеФункции.ПолучитьПутьUrl(АдресИнтернетExternAutomationUI, НомерПортаExternAutomationUI );
	
	СтрокаКоманды = "&Operation=play_step&answer_format=json&session_id="+ТестовоеПриложение;
	СтрокаКоманды = СтрокаКоманды + "&api=Automation UI";
	Если ОдинУровеньВниз=Истина Тогда
		СтрокаКоманды = СтрокаКоманды + "&action=find element child";
	Иначе 
		СтрокаКоманды = СтрокаКоманды + "&action=find element";
	КонецЕсли;
	СтрокаКоманды = СтрокаКоманды + "&element_name="+ИмяОбъекта;
	СтрокаКоманды = СтрокаКоманды + "&element_class_name="+ИмяКлассаОбъекта;
	СтрокаКоманды = СтрокаКоманды + "&element_type="+ТипОбъекта;	
	СтрокаКоманды = СтрокаКоманды + "&element_id="+ИдентификаторОбъекта;
	СтрокаКоманды = СтрокаКоманды + "&interval="+Формат(Интервал,"ЧН=0; ЧГ=;");
	СтрокаКоманды = СтрокаКоманды + "&element_variable_name="+ИмяПеременной;
	СтрокаКоманды = СтрокаКоманды + "&element_parent_variable_name="+ИмяПеременнойРодителя;
		
	 
	СтруктураОтвета = Неопределено;

	СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl+"/rest.html?"+СтрокаКоманды);

	Если НЕ СтруктураОтвета.КодСостояния=200 Тогда
		ОписаниеОшибки =  "Не удалось получить данные";
	КонецЕсли;
	
	Текст = СтруктураОтвета.ТелоСтрокой;
	
	РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);
	
	Если НРег(РезультатПреобразования.error)="true" Тогда
		ОписаниеОшибки = РезультатПреобразования.message;
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_ВыполнитьКоманду(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,мПараметры) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	ИмяКоманды = мПараметры.ИмяКоманды;
	ИмяПеременной = мПараметры.ИмяПеременной;
	ТипОбъекта = мПараметры.ТипОбъекта;
	РодительПеременная = мПараметры.РодительПеременная;
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	OutputText = мПараметры.OutputText;
	CommandRef = мПараметры.CommandRef;
	Presentation = мПараметры.Presentation;
	Direction = мПараметры.Direction;
	RowDescription = мПараметры.RowDescription;
	SwitchSelection = мПараметры.SwitchSelection;
	Cancel = мПараметры.Cancel;
	Area = мПараметры.Area;
	ИмяПараметра = мПараметры.ИмяПараметра;
	ЗначениеПараметра = мПараметры.ЗначениеПараметра;
	ПараметрыСценария = мПараметры.ПараметрыСценария;
	НомерПортаExternAutomationUI = мПараметры.НомерПортаExternAutomationUI;
	ClickX = мПараметры.ClickX;
	ClickY = мПараметры.ClickY;
	АдресИнтернетExternAutomationUI = мПараметры.АдресИнтернетExternAutomationUI;
	Интервал = мПараметры.Интервал;
	ИдентификаторОбъекта = мПараметры.ИдентификаторОбъекта;
	ОдинУровеньВниз = мПараметры.ОдинУровеньВниз;
	
	ПутьUrl = Модуль_СервисныеФункции.ПолучитьПутьUrl(АдресИнтернетExternAutomationUI, НомерПортаExternAutomationUI );
	
	СтрокаКоманды = "&Operation=play_step&answer_format=json&session_id="+ТестовоеПриложение;
	СтрокаКоманды = СтрокаКоманды + "&api=Automation UI";
	СтрокаКоманды = СтрокаКоманды + "&action=command";
	СтрокаКоманды = СтрокаКоманды + "&element_text="+OutputText;
	СтрокаКоманды = СтрокаКоманды + "&command="+ИмяКоманды;
	СтрокаКоманды = СтрокаКоманды + "&element_id="+ИдентификаторОбъекта;
	СтрокаКоманды = СтрокаКоманды + "&clickX="+ClickX;
	СтрокаКоманды = СтрокаКоманды + "&clickY="+ClickY;
	СтрокаКоманды = СтрокаКоманды + "&interval="+Формат(Интервал,"ЧН=0; ЧГ=;");
	СтрокаКоманды = СтрокаКоманды + "&element_variable_name="+ИмяПеременной;	
	 
	СтруктураОтвета = Неопределено;

	СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl+"/rest.html?"+СтрокаКоманды);

	Если НЕ СтруктураОтвета.КодСостояния=200 Тогда
		ОписаниеОшибки =  "Не удалось получить данные";
	КонецЕсли;
	
	Текст = СтруктураОтвета.ТелоСтрокой;
	
	РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);
	
	Если НРег(РезультатПреобразования.error)="true" Тогда
		ОписаниеОшибки = РезультатПреобразования.message;
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	

КонецПроцедуры


&НаКлиенте
Процедура мСценСкрипт_ПолучитьПредставлениеДанных(ТестовоеПриложение,ОписаниеОшибки,мПараметрыКлиент,ТекущаяПеременная,мПараметры,ПараметрыСценария) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	ПредставлениеДанных = мПараметры.ПредставлениеДанных;
	ИмяПараметра = мПараметры.ИмяПараметра;
	ЗначениеПараметра = мПараметры.ЗначениеПараметра;
	НомерПортаExternAutomationUI = мПараметры.НомерПортаExternAutomationUI;
	xPath = мПараметры.xPath;
	АдресИнтернетExternAutomationUI = мПараметры.АдресИнтернетExternAutomationUI;
	
	ПутьUrl = Модуль_СервисныеФункции.ПолучитьПутьUrl(АдресИнтернетExternAutomationUI, НомерПортаExternAutomationUI );
	
	СтрокаКоманды = "&Operation=play_step&answer_format=json&session_id="+ТестовоеПриложение;
	СтрокаКоманды = СтрокаКоманды + "&api=Automation UI";
	СтрокаКоманды = СтрокаКоманды + "&action=command";
	СтрокаКоманды = СтрокаКоманды + "&command=get text";
	СтрокаКоманды = СтрокаКоманды + "&element_xPath="+xPath;
	
	СтруктураОтвета = Неопределено;

	СтруктураОтвета = Модуль_СервисныеФункции.ЗагрузитьФайлПоИнтернетАдресу(ПутьUrl+"/rest.html?"+СтрокаКоманды);

	Если НЕ СтруктураОтвета.КодСостояния=200 Тогда
		ОписаниеОшибки =  "Не удалось получить данные";
	КонецЕсли;
	
	Текст = СтруктураОтвета.ТелоСтрокой;
	
	РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(Текст);

	Если НРег(РезультатПреобразования.error)="true" Тогда
		ОписаниеОшибки = РезультатПреобразования.message;
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	ПредставлениеДанных = РезультатПреобразования.text;
	
	мПараметрыКлиент.Вставить("ПоследнееПредставлениеДанных", ПредставлениеДанных);
	ЗначениеПараметра = ПредставлениеДанных;
	мСцен_УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра, ПараметрыСценария);	
	
	
	мПараметры.ПредставлениеДанных = ПредставлениеДанных;
	мПараметры.ЗначениеПараметра = ЗначениеПараметра;
	
КонецПроцедуры


&НаКлиенте
Процедура мСценСкрипт_СравнитьСПредставлениемДанных(ТестовоеПриложение,	ОписаниеОшибки, мПараметрыКлиент, ТекущаяПеременная, мПараметры, ПараметрыСценария) Экспорт

	ЗагрузитьБиблиотеки();

	ПредставлениеДанных = мПараметры.ПредставлениеДанных;
	УсловиеСравнения = мПараметры.УсловиеСравнения;

	// получим представление
	мСценСкрипт_ПолучитьПредставлениеДанных(ТестовоеПриложение,ОписаниеОшибки,мПараметрыКлиент,ТекущаяПеременная,мПараметры,ПараметрыСценария);

	// Если ПредставлениеДанных это параметр, то попробуем его найти
	ИмяПараметра = СокрЛП(СтрЗаменить(ПредставлениеДанных, "&", ""));
	ПараметрПредставлениеДанных = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра, ПараметрыСценария);
	Если ПараметрПредставлениеДанных <> Неопределено Тогда
		ЗначениеПредставлениеДанных = ПараметрПредставлениеДанных;
	Иначе
		ЗначениеПредставлениеДанных = ПредставлениеДанных;
	КонецЕсли;
	
	ПредставлениеДанныхЭлемента = мПараметры.ПредставлениеДанных;

	// выполним сравнение
	ОписаниеОшибки = Модуль_СервисныеФункции.СравнитьСПредставлениемДанных(УсловиеСравнения, ЗначениеПредставлениеДанных, ПредставлениеДанныхЭлемента);

	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_ПроверкаНаличияЭлемента(ТестовоеПриложение, ОписаниеОшибки, мПараметры, ПараметрыСценария) Экспорт
	
	ТипОбъекта = НРег(мПараметры.ТипОбъекта);
	ИмяПараметра = мПараметры.ИмяПараметра;
	ОбъектНайден = Ложь;
	ТекущаяПеременная = Неопределено;

	// поиск объекта, используем те же правила!
	Попытка
		//мСценСкрипт_НайтиОбъект();
		Если ТипОбъекта="window" Тогда		
			//мСценСкрипт_НайтиОсновноеОкно(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная, мПараметры);
			мСценСкрипт_НайтиОкно(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,мПараметры);
		Иначе // это элемент
			мСценСкрипт_НайтиОбъект(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,мПараметры);
		КонецЕсли;
		ОбъектНайден = Истина;
	Исключение
		// увы не нашли
		ОбъектНайден = Ложь;
	КонецПопытки;
	
	ОписаниеОшибки = "";
		
	Значение = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра,ПараметрыСценария);
	Если ТипЗнч(Значение)=Тип("Строка") Тогда
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,Строка(ОбъектНайден),ПараметрыСценария);
	ИначеЕсли ТипЗнч(Значение)=Тип("Число") Тогда
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,?(ОбъектНайден,1,0),ПараметрыСценария);	
	Иначе
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,ОбъектНайден,ПараметрыСценария);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_ОбработатьУсловие(ТестовоеПриложение,ОписаниеОшибки, Узел, ИмяПараметра,ЗначениеПараметра,УсловиеСравнения, ПараметрыСценария, ОсуществитьПереходСТекущегоШага) Экспорт
	
	ЗагрузитьБиблиотеки();

	ЗначениеПараметраТаблицыПараметров = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра, ПараметрыСценария);

	РезультатСравенения = Модуль_СервисныеФункции.СравнитьСПредставлениемДанных(УсловиеСравнения, ЗначениеПараметра, ЗначениеПараметраТаблицыПараметров);

	// сравним
	Если НЕ ЗначениеЗаполнено(РезультатСравенения) Тогда
	// все хорошо продолжаем выполнение
	Иначе
	// переходим на следующий узел по уровню
		ОсуществитьПереходСТекущегоШага = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Функция - Установить значение параметра
//
// Параметры:
//  ИмяПараметра		 - строка	 - Имя параметра, как в таблице параметров
//  ЗначениеПараметра	 - строка, булево, число, дата	 - Значение устанавливаемого параметра
// 
// Возвращаемое значение:
//  Булево - Истина, при удачной установке параметра; Ложь, в случае ошибки
//
&НаКлиенте
Функция мСцен_УстановитьЗначениеПараметра(Знач ИмяПараметра,ЗначениеПараметра,ПараметрыСценария) Экспорт
	
	РезультатОперации = Ложь;
	
	Для каждого стр из ПараметрыСценария Цикл
		Если ВРег(стр.Имя)=Врег(ИмяПараметра) Тогда
			стр.Значение = ЗначениеПараметра;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РезультатОперации;
	
КонецФункции

#КонецОбласти



&НаКлиенте
Процедура ЗагрузитьБиблиотеки()
	
	Если Модуль_СервисныеФункции=Неопределено Тогда
		Модуль_СервисныеФункции = ПолучитьФорму("ВнешняяОбработка.МенеджерСценарногоТеста.Форма.Модуль_СервисныеФункции");
	КонецЕсли;		
	
КонецПроцедуры	