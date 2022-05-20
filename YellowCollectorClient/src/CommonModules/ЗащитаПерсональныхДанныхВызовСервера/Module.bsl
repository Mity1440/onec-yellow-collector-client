///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Запускает изменение настроек скрытия персональных данных субъектов в соответствии с измененными
// настройками системы.
//
// Параметры:
//  УникальныйИдентификатор - УникальныйИдентификатор - уникальный идентификатор формы.
//  ПараметрыМетода - см. НастройкиСкрытияПерсональныхДанныхСистемы
//
// Возвращаемое значение:
//   см. ДлительныеОперации.ВыполнитьВФоне.
//
Функция ЗапуститьИзменениеНастроекСкрытияПДнВФоновомЗадании(Знач ИдентификаторФормы, Знач ПараметрыМетода) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Изменение настроек скрытия персональных данных'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("ЗащитаПерсональныхДанных.ИзменитьНастройкиСкрытияПерсональныхДанных", ПараметрыМетода, ПараметрыВыполнения);
	
КонецФункции

// Возвращает настройки скрытия персональных данных системы.
// 
// Возвращаемое значение:
//   Структура:
//      * ИспользоватьСкрытиеПерсональныхДанных - Булево - признак использования скрытия персональных данных субъектов.
//      * ДнейДоСкрытияПерсональныхДанных       - Число - дней до скрытия персональных данных субъектов.
//
Функция НастройкиСкрытияПерсональныхДанныхСистемы() Экспорт
	
	НастройкиСкрытия = Новый Структура;
	НастройкиСкрытия.Вставить("ИспользоватьСкрытиеПерсональныхДанных", Константы.ИспользоватьСкрытиеПерсональныхДанныхСубъектов.Получить());
	НастройкиСкрытия.Вставить("ДнейДоСкрытияПерсональныхДанных", Константы.ДнейДоСкрытияПерсональныхДанныхСубъектов.Получить());
	
	Возврат НастройкиСкрытия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыВопросаПодтвержденияСкрытия(Субъекты) Экспорт
	
	ТекстВопроса = "";
	ПараметрыВопроса = Новый Структура;
	
	СкрываемыеСубъекты = Новый Массив;
	СкрываемыеСубъектыБезСогласия = Новый Массив;
	СкрываемыеСубъектыССогласием = Новый Массив;
	
	ДатаСеанса = НачалоДня(ТекущаяДатаСеанса());
	ПустаяДата = Дата(1, 1, 1);
	
	ДнейДоСкрытия = ЗащитаПерсональныхДанных.ДнейДоСкрытияПерсональныхДанныхСубъектов();
	НастройкиСубъектов = ЗащитаПерсональныхДанных.ПрочитатьНастройкиСкрытияСубъектов(Субъекты);
	
	Для Каждого НастройкиСкрытия Из НастройкиСубъектов Цикл
		
		Субъект = НастройкиСкрытия.Ключ;
		Настройки = НастройкиСкрытия.Значение;
		
		Если Настройки.Состояние = Перечисления.СостоянияСубъектовДляСкрытия.СкрытиеОтменено 
			Или Настройки.Состояние = Перечисления.СостоянияСубъектовДляСкрытия.СкрытиеВыполнено Тогда
			
			Если Настройки.Состояние = Перечисления.СостоянияСубъектовДляСкрытия.СкрытиеОтменено Тогда
				ТекстПричины = НСтр("ru = 'Скрытие ранее отменено по причине: %1.'");
				ТекстПричины = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПричины, Настройки.ПричинаОтменыСкрытия);
			Иначе
				ТекстПричины = НСтр("ru = 'Скрытие уже выполнено.'");
			КонецЕсли;
			
			ТекстСообщения = НСтр("ru = 'Персональные данные субъекта ""%1"" не могут быть скрыты.
				|%2'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Субъект, ТекстПричины);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			Продолжить;
			
		ИначеЕсли ЗначениеЗаполнено(Настройки.Основание) 
			И (Настройки.ДатаСкрытия = ПустаяДата Или Настройки.ДатаСкрытия - ДнейДоСкрытия * 86400 > ДатаСеанса) Тогда
			СкрываемыеСубъектыССогласием.Добавить(Субъект);
		Иначе
			СкрываемыеСубъектыБезСогласия.Добавить(Субъект);
		КонецЕсли;
		
		СкрываемыеСубъекты.Добавить(Субъект);
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СкрываемыеСубъектыБезСогласия) Тогда
		
		Заголовок = НСтр("ru = 'Будут скрыты персональные данные субъектов:'");
		ТекстВопроса = ПредставлениеСпискаСубъектов(Заголовок, СкрываемыеСубъектыБезСогласия);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СкрываемыеСубъектыССогласием) Тогда
		
		Заголовок = НСтр("ru = 'Несмотря на полученное согласие на обработку ПДн, будут скрыты персональные данные субъектов:'");
		ТекстВопроса = ?(ЗначениеЗаполнено(ТекстВопроса), ТекстВопроса + Символы.ПС, "") + ПредставлениеСпискаСубъектов(Заголовок, СкрываемыеСубъектыССогласием);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстВопроса) Тогда
		ТекстВопроса = ТекстВопроса + Символы.ПС + НСтр("ru = 'Восстановление данных будет невозможно. Продолжить?'");
	КонецЕсли;
	
	ПараметрыВопроса.Вставить("Субъекты", СкрываемыеСубъекты);
	ПараметрыВопроса.Вставить("ТекстВопроса", ТекстВопроса);
	
	Возврат ПараметрыВопроса;
	
КонецФункции

Функция ПредставлениеСпискаСубъектов(Заголовок, Субъекты)
	
	ПредставлениеСписка = "";
	ПредставлениеСписка = Заголовок + Символы.ПС;
	
	Если Субъекты.Количество() = 1 Тогда
		ПредставлениеСписка = СтрЗаменить(ПредставлениеСписка, НСтр("ru = 'субъектов'"), НСтр("ru = 'субъекта'"));
	КонецЕсли;
	
	Номер = 1;
	Для Каждого Субъект Из Субъекты Цикл
		
		ПредставлениеСписка = ПредставлениеСписка + ?(Номер <> 1, ", ", "");
		ПредставлениеСписка = ПредставлениеСписка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1'"), Субъект);
		
		Номер = Номер + 1;
		
	КонецЦикла;
	
	Возврат ПредставлениеСписка + "." + Символы.ПС;
	
КонецФункции

Процедура СкрытьПерсональныеДанныеСубъектов(Субъекты, СообщатьОбИсключениях = Ложь) Экспорт
	
	ЗащитаПерсональныхДанных.СкрытьПерсональныеДанныеСубъектов(Субъекты, СообщатьОбИсключениях);
	
КонецПроцедуры

Процедура СохранитьПоложениеОтбораПоказыватьСоСкрытымиПДн(ИмяФормы, ПоложениеОтбора) Экспорт
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ПоказыватьСоСкрытымиПДн", ПоложениеОтбора);
КонецПроцедуры

#КонецОбласти