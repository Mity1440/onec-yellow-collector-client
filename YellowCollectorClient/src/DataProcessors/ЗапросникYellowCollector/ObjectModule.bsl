#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем АдресСервера;
Перем Порт;
Перем АдресМаршрута;
Перем ЩаблонURL;
Перем ПараметрыЗапроса;

#КонецОбласти

#Область ПрограммныйИнтерфейс

Функция УстановитьМаршрут(Значение) Экспорт

	Маршрут = Значение;
	УстановитьАдресМаршрута();
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция УстановитьСервер(Значение) Экспорт

	Инстанс = Значение; 
	УстановитьАдресСервераИПорт();

	Возврат ЭтотОбъект;
	
КонецФункции

Функция Иницизировать(Параметры = Неопределено) Экспорт

	ПараметрыЗапроса = Параметры;
	
	Если НЕ ЗначениеЗаполнено(Инстанс) Тогда
		УстановитьСервер(Справочники.СервераYellowCollector.Активный());
	КонецЕсли;
	
	Возврат ЭтотОбъект;

КонецФункции

// Сформировать URL.
// 
// Возвращаемое значение:
//  Строка - 
Функция СформироватьURL() Экспорт
	
	URL =  
	СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрЗаменить(ЩаблонURL, "Протокол", "http"), "АдресСервера", АдресСервера), 
	                                                     "Порт", Формат(Порт, "ЧГ=;")), "АдресМаршрута", АдресМаршрута);
	Если НЕ СтрНайти(URL, "{id}") = 0 Тогда
		URL = СтрЗаменить(URL, "{id}", ПараметрыЗапроса.ИД);	
	КонецЕсли;
	
	Возврат URL;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьАдресМаршрута()

	АдресМаршрута = Неопределено;
	Если ЗначениеЗаполнено(Маршрут) Тогда
		АдресМаршрута = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Маршрут, "АдресРесурса");
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьАдресСервераИПорт()
	
	АдресСервера = Неопределено;
	Порт = Неопределено;
	Если ЗначениеЗаполнено(Инстанс) Тогда
	
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Инстанс, "Адрес, Порт");
	
		АдресСервера = Реквизиты["Адрес"];
		Порт = Реквизиты["Порт"];	
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЩаблонURL = "Протокол://АдресСервера:Порт/АдресМаршрута";

#КонецОбласти

#КонецЕсли
