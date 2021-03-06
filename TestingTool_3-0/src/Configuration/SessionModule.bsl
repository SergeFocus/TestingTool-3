#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
	
	// получим компьютер
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыСеанса.ИмяСервера = ИмяКомпьютера();
	
	// Установить пользователя
	ПользователиВызовСервера.УстановитьПараметры(ПараметрыСеанса);
	
	// сбросим настройки если установлено рабочее место
	ОсновноеРабочееМестоСервер.СброситьНастройкиНачальнойСтраницыПриВыбранномОсновномРабочемМесте();
	
КонецПроцедуры

#КонецЕсли