///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачалоПериода = Параметры.НачалоПериода;
	КонецПериода  = Параметры.КонецПериода;
	
	Если НачалоДня(НачалоПериода) = НачалоДня(КонецПериода) Тогда
		День = НачалоПериода;
	Иначе
		День = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если День < Параметры.ОграничениеСнизу Тогда
		День = Параметры.ОграничениеСнизу;
	КонецЕсли;
	
	Элементы.День.НачалоПериодаОтображения = Параметры.ОграничениеСнизу;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеньПриИзменении(Элемент)
	
	РезультатВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоДня(День), КонецДня(День));
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти