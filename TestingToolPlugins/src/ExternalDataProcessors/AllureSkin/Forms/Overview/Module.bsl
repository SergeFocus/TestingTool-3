&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ДобавитьМеню(ЭтаФорма,"Overview");
	
	ЭтаФорма.КоманднаяПанель.Видимость = Ложь;
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Overview";
	
	ЗаполнитьЗначенияСвойств(Объект,Параметры);

КонецПроцедуры

&НаКлиенте
Процедура КнопкаМеню(Команда)
	ИмяКоманды = Команда.Имя;
	мПараметры = новый Структура("Проверка,ТестируемыйКлиент",Объект.Проверка,Объект.ТестируемыйКлиент);
	ОткрытьФорму("ВнешняяОбработка.AllureSkin.Форма."+ИмяКоманды,мПараметры,ЭтаФорма,ЭтаФорма.УникальныйИдентификатор,ЭтаФорма.Окно);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗагрузитьНастройкиПользователя();
	СформироватьОписаниеПанелей();
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеПанелей()
	
	Объект.Проверка = ПолучитьПоследнююПроверкуДляТестируемогоКлиента(Объект.ТестируемыйКлиент);
	СформироватьОписаниеПанелиОкружение();
	СформироватьОписаниеПанелиПоПоследнейПровеке();
	СформироватьОписаниеПанелиПоДефектам();
	
КонецПроцедуры


&НаСервере
Процедура СформироватьОписаниеПанелиОкружение()

	ОбщаяИнформацияОкружение = "<html><head></head><body>";
	
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"<table>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"<tr>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"<td>Тестируемый клиент</td><td>"+Объект.ТестируемыйКлиент+"</td>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"</tr><tr>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"<td>Тестируемая конфигурация 1С </td><td>"+Объект.ТестируемыйКлиент.База1С.Конфигурация.Синоним+"</td>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"</tr><tr>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"<td>База 1С</td><td>"+Объект.ТестируемыйКлиент.База1С+"</td>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"</tr><tr>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"<td>Путь подключения</td><td>"+Объект.ТестируемыйКлиент.База1С.СтрокаПодключенияКИБ+"</td>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"</tr><tr>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"<td>Дополнительные параметры командной строки</td><td>"+Объект.ТестируемыйКлиент.База1С.ДопПараметрыКоманднойСтроки+"</td>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"</tr>";
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"</table>";
	
	ОбщаяИнформацияОкружение = ОбщаяИнформацияОкружение+"</body></html>";
	
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеПанелиПоПоследнейПровеке()

	ОбщаяИнформацияПоПроверке = "<html><head></head><body>";
	
	ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<b>Проверка №"+Объект.Проверка+"</b>";
	ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+" запущена "+Объект.Проверка.ДатаНачала+" <br/>";
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Т.Проверка,
	|	Т.ТестируемыйКлиент,
	|	Т.Тест,
	|	Т.РезультатВыполнения,
	|	Т.ОписаниеОшибки,
	|	Т.ДатаВыполенения,
	|	Т.НомерПоПорядку,
	|	Т.КоличествоТестовыхСлучаев,
	|	Т.КоличествоПровалов,
	|	Т.КоличествоОшибок,
	|	Т.КоличествоПропущенных,
	|	Т.ВремяВыполнения
	|ПОМЕСТИТЬ ВтПоследниеПроверки
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК Т
	|ГДЕ
	|	Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И Т.Проверка = &Проверка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВтПоследниеПроверки.ТестируемыйКлиент,
	|	ВтПоследниеПроверки.Проверка,
	|	СУММА(ВтПоследниеПроверки.КоличествоТестовыхСлучаев) КАК КоличествоТестовыхСлучаев,
	|	СУММА(ВтПоследниеПроверки.КоличествоПровалов) КАК КоличествоПровалов,
	|	СУММА(ВтПоследниеПроверки.КоличествоОшибок) КАК КоличествоОшибок,
	|	СУММА(ВтПоследниеПроверки.КоличествоПропущенных) КАК КоличествоПропущенных,
	|	СУММА(ВтПоследниеПроверки.КоличествоТестовыхСлучаев - ВтПоследниеПроверки.КоличествоПровалов - ВтПоследниеПроверки.КоличествоОшибок - ВтПоследниеПроверки.КоличествоПропущенных) КАК КоличествоУспешных,
	|	СУММА(ВтПоследниеПроверки.ВремяВыполнения) КАК ВремяВыполнения
	|ИЗ
	|	ВтПоследниеПроверки КАК ВтПоследниеПроверки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВтПоследниеПроверки.Проверка,
	|	ВтПоследниеПроверки.ТестируемыйКлиент";
	
	Запрос.УстановитьПараметр("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	Запрос.УстановитьПараметр("Проверка",Объект.Проверка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		КоличествоТестовыхСлучаев = Выборка.КоличествоТестовыхСлучаев;
		КоличествоПровалов = Выборка.КоличествоПровалов;
		КоличествоОшибок = Выборка.КоличествоОшибок;
		КоличествоПропущенных = Выборка.КоличествоПропущенных;
		КоличествоУспешных = Выборка.КоличествоУспешных;
		ВремяВыполнения = Выборка.ВремяВыполнения;
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<br/>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<span>Всего тестовых случаев "+КоличествоТестовыхСлучаев+" длительность "+ВремяВыполнения+" с."+"</span>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<table><tr><td>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<span style='color:red'>Количество провалов <b>"+КоличествоПровалов+"</b></span>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<br/>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<span style='color:orange'>Количество ошибок <b>"+КоличествоОшибок+"</b></span>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<br/>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<span style='color:gray'>Количество пропущенных <b>"+КоличествоПропущенных+"</b></span>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<br/>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<span style='color:green'>Количество успешных <b>"+КоличествоУспешных+"</b></span>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"<br/>";
		ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"</td><td>#КартинкаЭмоции#</td></tr></table>";
		
	КонецЕсли;
	
	ИмяМакета= "";
	
	Если КоличествоПровалов=0 И КоличествоОшибок=0 Тогда
		ИмяМакета = "HappyFace";
	ИначеЕсли КоличествоУспешных=0 И КоличествоПровалов<>0 И КоличествоОшибок<>0 Тогда
		ИмяМакета = "OMGFace";
	ИначеЕсли КоличествоПропущенных<>0 И КоличествоУспешных=0 И КоличествоПровалов=0 И КоличествоОшибок=0 Тогда
		ИмяМакета = "ThinkingFace";
	КонецЕсли;
	Если ЗначениеЗаполнено(ИмяМакета) Тогда
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		Макет = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
		СсылкаFace = ПоместитьВоВременноеХранилище(Макет);
		Картинка = "<IMG style='margin-left:40px;height:64px;width:64px;' src='"+СсылкаFace+"'>";
	Иначе
		Картинка = "";
	КонецЕсли;
	
	ОбщаяИнформацияПоПроверке = СтрЗаменить(ОбщаяИнформацияПоПроверке,"#КартинкаЭмоции#",Картинка);
	              	
	ОбщаяИнформацияПоПроверке = ОбщаяИнформацияПоПроверке+"</body></html>";

КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеПанелиПоДефектам()
	
	ОбщаяИнформацияПоДефектам = "";
	
	ОбщаяИнформацияПоДефектам = "<html><head></head><body>";
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(Т.ТестовыйСлучай) КАК КоличествоДефектов
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестовыхСлучаев КАК Т
	|ГДЕ
	|	Т.Проверка = &Проверка
	|	И Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И Т.РезультатВыполнения В (ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияШагов.Провал), ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияШагов.Ошибка))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 10
	|	Т.Проверка,
	|	Т.ТестируемыйКлиент,
	|	Т.Тест,
	|	Т.ТестовыйСлучай,
	|	Т.РезультатВыполнения,
	|	ВЫБОР
	|		КОГДА Т.РезультатВыполнения = ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияШагов.Провал)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Порядок,
	|	Т.ОписаниеОшибки,
	|	Т.ВремяВыполнения,
	|	Т.ДатаВыполенения
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестовыхСлучаев КАК Т
	|ГДЕ
	|	Т.Проверка = &Проверка
	|	И Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|	И Т.РезультатВыполнения В (ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияШагов.Провал), ЗНАЧЕНИЕ(Перечисление.РезультатыВыполненияШагов.Ошибка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	Запрос.УстановитьПараметр("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	Запрос.УстановитьПараметр("Проверка",Объект.Проверка);
	
	РезультатПакет = ЗАпрос.ВыполнитьПакет();
	
	// количество дефектов
	Выборка = РезультатПакет[0].Выбрать();
	КоличествоДефектов = 0;
	Если Выборка.Следующий() Тогда
		КоличествоДефектов = Выборка.КоличествоДефектов;
	КонецЕсли;
	
	ОбщаяИнформацияПоДефектам = ОбщаяИнформацияПоДефектам+"<h3>Дефектов всего: <b>"+КоличествоДефектов+"</b></h3>";
	
	// количество в целом
	Выборка = РезультатПакет[1].Выбрать();	
	Пока Выборка.Следующий() Цикл
		Тест = Выборка.Тест;
		ОписаниеОшибки = Выборка.ОписаниеОшибки;
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки,"Шаг №","</br><hr>Шаг №");
		Если Выборка.РезультатВыполнения=Перечисления.РезультатыВыполненияШагов.Провал Тогда
			ОбщаяИнформацияПоДефектам = ОбщаяИнформацияПоДефектам+"<div style='width:550px;overflow:hidden;border-style:dotted;border-color:gray;border-width:thin;padding:5px;'><b style='color:red;'>"+Тест+"</b>: "+ОписаниеОшибки+"</div>";		
		Иначе
			ОбщаяИнформацияПоДефектам = ОбщаяИнформацияПоДефектам+"<div style='width:550px;overflow:hidden;border-style:dotted;border-color:gray;border-width:thin;padding:5px;'><b style='color:orange;'>"+Тест+"</b>: "+ОписаниеОшибки+"</div>";		
		КонецЕсли;
	КонецЦикла;	
	
	ОбщаяИнформацияПоДефектам = ОбщаяИнформацияПоДефектам+"</body></html>";
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьПоследнююПроверкуДляТестируемогоКлиента(Знач ТестируемыйКлиент)
	
	Проверка = Справочники.Проверки.ПустаяСсылка();
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	Т.Проверка КАК Проверка
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК Т
	|ГДЕ
	|	Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Т.Проверка.Код УБЫВ";
	Запрос.УстановитьПараметр("ТестируемыйКлиент",ТестируемыйКлиент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Проверка = Выборка.Проверка;
		КонецЕсли;
		
	КонецЕсли;
	
	
	Возврат Проверка;
	
КонецФункции

&НаКлиенте
Процедура ТестируемыйКлиентПриИзменении(Элемент)
	СформироватьОписаниеПанелей();
	СохранитьНастройкиПользователя();
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПользователя()
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.СохранитьНастройкиПользователя(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиПользователя()
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ЗагрузитьНастройкиПользователя(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВсе(Команда)
	СформироватьОписаниеПанелей();
КонецПроцедуры