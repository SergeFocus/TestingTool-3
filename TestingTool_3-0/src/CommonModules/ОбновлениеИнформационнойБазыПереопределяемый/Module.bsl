///////////////////////////////////////////////////////////////////////////////
// ИНТЕРФЕЙСНАЯ ЧАСТЬ ПЕРЕОПРЕДЕЛЯЕМОГО МОДУЛЯ

// Возвращает список процедур-обработчиков обновления ИБ для всех поддерживаемых версий ИБ.
//
// Пример добавления процедуры-обработчика в список:
//    Обработчик = Обработчики.Добавить();
//    Обработчик.Версия = "1.0.0.0";
//    Обработчик.Процедура = "ОбновлениеИБ.ПерейтиНаВерсию_1_0_0_0";
//
// Вызывается перед началом обновления данных ИБ.
//
Функция ОбработчикиОбновления() Экспорт
	
	Обработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.17.01.01";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыПереопределяемый.НачальнаяИнициализация";
	
	Возврат Обработчики;
	
КонецФункции

// Вызывается при подготовке табличного документа с описанием изменений системы.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновлений.
//   
// См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры	

// Вызывается после завершении обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ     - Строка - версия ИБ до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ        - Строка - версия ИБ после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков
//                                             обновления, сгруппированных по номеру версии.
//  Итерирование по выполненным обработчикам:
//		Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//	
//			Если Версия.Версия = "*" Тогда
//				группа обработчиков, которые выполняются всегда
//			Иначе
//				группа обработчиков, которые выполняются для определенной версии 
//			КонецЕсли;
//	
//			Для Каждого Обработчик Из Версия.Строки Цикл
//				...
//			КонецЦикла;
//	
//		КонецЦикла;
//
//   ВыводитьОписаниеОбновлений - Булево -	если Истина, то выводить форму с описанием 
//											обновлений.
// 
Процедура ПослеОбновления(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ, 
	Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений) Экспорт
	
	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
		
		Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
			
			Если Версия.Версия = "*" Тогда
				
			Иначе
				
			КонецЕсли;
			
			Для Каждого Обработчик Из Версия.Строки Цикл
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#Область НачальнаяИнициализация

// начальная инициализация
Процедура НачальнаяИнициализация() Экспорт
	
	// обновляем идентификаторы метаданных
	ЕстьИзменения = Ложь;
	ЕстьУдаленные = Ложь;
	ТолькоПроверка = Ложь;	
	Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(ЕстьИзменения,ЕстьУдаленные,ТолькоПроверка);

	// генерим макеты для ключей настроек и имен переменных
	СформироватьНачальныеКлючиНастроек();
	
КонецПроцедуры

Процедура СформироватьНачальныеКлючиНастроек()
	
	// "Путь к исполняемому файлу 1С"
	КлючОбъект = Справочники.КлючиНастроек.ПутьКИсполняемомуФайлу1С.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к исполняемому файлу 1С";
	КлючОбъект.ИмяКлюча = "%ПутьКИсполняемомуФайлу1С%";
	КлючОбъект.Расширение = "exe";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Файл;
	КлючОбъект.Записать();
	
	// "Путь к исполняемому файлу GIT"
	КлючОбъект = Справочники.КлючиНастроек.ПутьКИсполняемомуФайлуGIT.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к исполняемому файлу GIT";
	КлючОбъект.ИмяКлюча = "%ПутьКИсполняемомуФайлуGIT%";
	КлючОбъект.Расширение = "exe";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Файл;
	КлючОбъект.Записать();
	
	// "Путь к обработке xddTestRunner"
	КлючОбъект = Справочники.КлючиНастроек.ПутьКОбработкеxddTestRunner.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к обработке xddTestRunner";
	КлючОбъект.ИмяКлюча = "%ПутьКОбработкеxddTestRunner%";
	КлючОбъект.Расширение = "epf";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Файл;
	КлючОбъект.Записать();
	
	// "Путь к обработке 'Менеджер сценарного теста'"
	КлючОбъект = Справочники.КлючиНастроек.ПутьКОбработкеМенеджерСценарногоТеста.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к обработке 'Менеджер сценарного теста'";
	КлючОбъект.ИмяКлюча = "%ПутьКОбработкеМенеджерСценарногоТеста%";
	КлючОбъект.Расширение = "epf";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Файл;
	КлючОбъект.Записать();
	
	// "Путь к каталогу GIT"
	КлючОбъект = Справочники.КлючиНастроек.ПутьККаталогуGIT.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к каталогу GIT";
	КлючОбъект.ИмяКлюча = "%ПутьККаталогуGIT%";
	КлючОбъект.Расширение = "";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Каталог;
	КлючОбъект.Записать();
	
	// "Путь к временному каталогу файлов"
	КлючОбъект = Справочники.КлючиНастроек.ПутьКВременномуКаталогуФайлов.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к временному каталогу файлов";
	КлючОбъект.ИмяКлюча = "%ПутьКВременномуКаталогуФайлов%";
	КлючОбъект.Расширение = "";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Каталог;
	КлючОбъект.Записать();
	
	// "Путь к каталогу SoapUI"
	КлючОбъект = Справочники.КлючиНастроек.ПутьККаталогуSoapUI.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к каталогу SoapUI";
	КлючОбъект.ИмяКлюча = "%ПутьККаталогуSoapUI%";
	КлючОбъект.Расширение = "";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Каталог;
	КлючОбъект.Записать();
	
	// "Путь к каталогу библиотеки сценариев"
	КлючОбъект = Справочники.КлючиНастроек.ПутьККаталогуБиблиотекиСценариев.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к каталогу библиотеки сценариев";
	КлючОбъект.ИмяКлюча = "%ПутьККаталогуБиблиотекиСценариев%";
	КлючОбъект.Расширение = "";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Каталог;
	КлючОбъект.Записать();
	
	// "Путь к каталогу наборов сценариев"
	КлючОбъект = Справочники.КлючиНастроек.ПутьККаталогуНаборовСценариев.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к каталогу наборов сценариев";
	КлючОбъект.ИмяКлюча = "%ПутьККаталогуНаборовСценариев%";
	КлючОбъект.Расширение = "";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Каталог;
	КлючОбъект.Записать();
	
	// "Путь к каталогу отчетов выполнения тестов"
	КлючОбъект = Справочники.КлючиНастроек.ПутьККаталогуОтчетовВыполненияТестов.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к каталогу отчетов выполнения тестов";
	КлючОбъект.ИмяКлюча = "%ПутьККаталогуОтчетовВыполненияТестов%";
	КлючОбъект.Расширение = "";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Каталог;
	КлючОбъект.Записать();
	
	// "Путь к рабочему каталогу"
	КлючОбъект = Справочники.КлючиНастроек.ПутьКРабочемуКаталогу.ПолучитьОбъект();
	КлючОбъект.Наименование = "Путь к рабочему каталогу";
	КлючОбъект.ИмяКлюча = "%ПутьКРабочемуКаталогу%";
	КлючОбъект.Расширение = "";
	КлючОбъект.ТипНастройки = Перечисления.ТипыКлючейНастроек.Каталог;
	КлючОбъект.Записать();
	
	
КонецПроцедуры


#КонецОбласти