#Область ОписаниеПеременных

&НаСервере
Перем МенеджерМонитора;

#Конецобласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроверитьДоступностьСервераYellowColllector(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьФорму();	
	УстановитьВидимостьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбщийДокументПоВсемОшибкамПриАктивизации(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_ОбщийДокументПоВсемОшибкамПриАктивизации", 0.3, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбщийДокументПоВсемОшибкамОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры   

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьДанныеМонитора();
КонецПроцедуры

&НаКлиенте
Процедура Детали(Команда)
	
	Элементы.Детали.Пометка = НЕ Элементы.Детали.Пометка;
	ПодключитьОбработчикОжидания("Подключаемый_ОбщийДокументПоВсемОшибкамПриАктивизации", 0.5, Истина);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСФормой

&НаСервере
Процедура ИнициализироватьФорму()

	ИнициализироватьСхемуКомпоновки();
	ИнициализироватьКомпоновщикНастроек();

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьСхемуКомпоновки()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ПодготовитьМониторКРаботеПриНеобходимости(ПараметрыМонитораДляПодготовки());
	
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек()
	
	КомпоновщикНастроекОбщийДокумент
	   .Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Объект.АдресСхемы));
	КомпоновщикНастроекОбщийДокумент
	   .ЗагрузитьНастройки(ПолучитьИзВременногоХранилища(Объект.АдресСхемы).НастройкиПоУмолчанию);

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьНаСервере()
	УстановитьВидимостьОбластиДеталейОшибокНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ПроверкаДоступности

&НаСервере
Процедура ПроверитьДоступностьСервераYellowColllector(Отказ)
	
	Если НЕ YellowCollectorЗапросы.СерверДоступен() Тогда
	
		Отказ = Истина;
		ОбщегоНазначения
		     .СообщитьПользователю(НСтр("ru='Не удалось установить соединение с сервером ""Yellow Collector""'"));
	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОтображениеДеталейОшибок

//@skip-check module-empty-method
&НаКлиенте
Процедура Подключаемый_ОбщийДокументПоВсемОшибкамПриАктивизации()
	
	УстановитьВидимостьОбластиДеталейОшибокНаКлиенте();
	УстановитьЗаголовокКнопкиДеталиОшибок();
	Если ОтображатьДетальнуюИнформацию() Тогда
		ЗаполнитьДетальнуюИнформациюНаКлиенте();
		РаскрытьВсеУровниДереваДетальнойИнформации();
	Иначе
		ОчиститьДеревоДетальнойИнформации(ДетальнаяИнформацияКакДерево);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьВсеУровниДереваДетальнойИнформации()
	РаскрытьЭлементыУровняРекурсивно(ДетальнаяИнформацияКакДерево.ПолучитьЭлементы());
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьЭлементыУровняРекурсивно(ЭлементыДерева)
	Для Каждого ЭлементДеревева Из ЭлементыДерева Цикл
		Элементы.ДетальнаяИнформацияКакДерево.Развернуть(ЭлементДеревева.ПолучитьИдентификатор());
		РаскрытьЭлементыУровняРекурсивно(ЭлементДеревева.ПолучитьЭлементы());
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ОтображатьДетальнуюИнформацию()
	Возврат Элементы.Детали.Пометка;
КонецФункции

&НаКлиенте
Процедура УстановитьЗаголовокКнопкиДеталиОшибок()
	
	Если ОтображатьДетальнуюИнформацию() Тогда
		Элементы.Детали.Заголовок = НСтр("ru='Скрыть детали'");
	Иначе
		Элементы.Детали.Заголовок = НСтр("ru='Показать детали'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьОбластиДеталейОшибокНаКлиенте()
	Элементы.ГруппаДетали.Видимость = ОтображатьДетальнуюИнформацию();	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОбластиДеталейОшибокНаСервере()
	Элементы.ГруппаДетали.Видимость = Элементы.Детали.Пометка;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДетальнуюИнформациюНаКлиенте()

	ТекущаяОбластьДокумента = Элементы.ОбщийДокументПоВсемОшибкам.ТекущаяОбласть;
	Если ТекущаяОбластьДокумента = Неопределено 
	     ИЛИ ТекущаяОбластьДокумента.Расшифровка = Неопределено Тогда	
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДетальнуюИнформациюОбОшибкеНаСервере(ТекущаяОбластьДокумента.Расшифровка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДетальнуюИнформациюОбОшибкеНаСервере(Расшифровка)
	
	Перем ИДОтчетаОбОшибке, ДетальнаяИнформация;
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Объект.АдресДанныхРасшифровки);
	Если НЕ Тип("ДанныеРасшифровкиКомпоновкиДанных") = ТипЗнч(ДанныеРасшифровки) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементРасшифровки = ДанныеРасшифровки.Элементы.Получить(Расшифровка);
	Если НЕ Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") = ЭлементРасшифровки Тогда
	
	КонецЕсли;
	
	ПоляРасшифровки = ЭлементРасшифровки.ПолучитьПоля();
	Для Каждого ПолеРасшифровки Из ПоляРасшифровки Цикл
		Если ПолеРасшифровки.Поле = "ИД" Тогда
			ИДОтчетаОбОшибке = ПолеРасшифровки.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ИДОтчетаОбОшибке) Тогда
		ДетальнаяИнформация =  МенеджерМонитора.ПолучитьДетальнуюИнформациюОтчетаОбОшибке(ИДОтчетаОбошибке);
		ЗаполнитьДеревоДетальнойИнформацииПоданнымОтчетаОбОшибке(ДетальнаяИнформация);
	Иначе
		ОчиститьДеревоДетальнойИнформации(ДетальнаяИнформацияКакДерево);
	КонецЕсли;
	
КонецПроцедуры

#Область ФормированиеДереваДетальнойИнформации

&НаСервере
Процедура ЗаполнитьДеревоДетальнойИнформацииПоданнымОтчетаОбОшибке(ДетальнаяИнформацияВСоответствии)
	
	ДеревоДетальнойИнформации = ИнициализироватьДеревоДетальнойИнФормации();
	ЗаполнитьДеревоДетальнойИнформацииРекурсивно(ДеревоДетальнойИнформации, ДетальнаяИнформацияВСоответствии);
	
	ЗначениеВРеквизитФормы(ДеревоДетальнойИнформации, "ДетальнаяИнформацияКакДерево");

КонецПроцедуры

&НаСервере
Функция ИнициализироватьДеревоДетальнойИнФормации()
	
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Свойство");
	Дерево.Колонки.Добавить("Значение");
	Дерево.Колонки.Добавить("Тип");

	Возврат Дерево;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоДетальнойИнформацииРекурсивно(ТекущаяСтрокаДерева, УзелДетальнойИнформации)
	
	ИндексЭлементаМассива = 0;
	
	Для Каждого ЭлементДетальнойИнформации ИЗ УзелДетальнойИнформации цикл    
		
		Если ТипЗнч(ЭлементДетальнойИнформации) = Тип("КлючИЗначение") Тогда
			ОчереднаяСтрокаДерева = ТекущаяСтрокаДерева.Строки.Добавить(); 
			ОчереднаяСтрокаДерева.Свойство = ЭлементДетальнойИнформации.Ключ;
			Если ТипЗнч(ЭлементДетальнойИнформации.Значение) = Тип("Структура") 
				ИЛИ ТипЗнч(ЭлементДетальнойИнформации.Значение) = Тип("Массив")
				ИЛИ ТипЗнч(ЭлементДетальнойИнформации.Значение) = Тип("Соответствие")  Тогда
				ЗаполнитьДеревоДетальнойИнформацииРекурсивно(ОчереднаяСтрокаДерева, ЭлементДетальнойИнформации.Значение);
			Иначе
				ОчереднаяСтрокаДерева.Значение =  ЭлементДетальнойИнформации.Значение;
			КонецЕсли 
		ИначеЕсли ТипЗнч(ЭлементДетальнойИнформации)  = Тип("Строка") Тогда
			ОчереднаяСтрокаДерева = ТекущаяСтрокаДерева.Строки.Добавить(); 
			ОчереднаяСтрокаДерева.Значение = ЭлементДетальнойИнформации;
		Иначе
			ОчереднаяСтрокаДерева = ТекущаяСтрокаДерева.Строки.Добавить(); 
			ОчереднаяСтрокаДерева.Свойство = "[" + ИндексЭлементаМассива + "]";
			ИндексЭлементаМассива = ИндексЭлементаМассива + 1;
			ЗаполнитьДеревоДетальнойИнформацииРекурсивно(ОчереднаяСтрокаДерева, ЭлементДетальнойИнформации);	
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Процедура ОчиститьДеревоДетальнойИнформации(ДетальнаяИнформацияКакДерево)
	ДетальнаяИнформацияКакДерево.ПолучитьЭлементы().Очистить();
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеДанныхМонитора

&НаСервере
Процедура ОбновитьДанныеМонитора()
	
	МониторОбъект = РеквизитФормыВЗначение("Объект");
	ДанныеМонитора = МониторОбъект.ПолучитьДанныеМонитораИзКоллектора(ПараметрыМонитораДляОбновления());
	
	ДанныеМонитора.Свойство("ДокументПоВсемОшибкам", ОбщийДокументПоВсемОшибкам);
		
КонецПроцедуры

#Область ПараметрыМонитора

&НаСервере
Функция ПараметрыМонитораДляПодготовки()
	
	ПараметрыМонитора = ОбщиеПараметрыПараметрыМонитора();
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ПараметрыМонитора);
	
КонецФункции 

&НаСервере
Функция ПараметрыМонитораДляОбновления()
	
	ОбщиеПараметры = ОбщиеПараметрыПараметрыМонитора();
	
	ОбщиеПараметры.Вставить("НастройкиСКДДляДокументаПоВсемОшибкамСтрока", 
	                         ПоместитьВоВременноеХранилище(КомпоновщикНастроекОбщийДокумент.ПолучитьНастройки(),
	                                                       УникальныйИдентификатор));
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ОбщиеПараметры);
	
КонецФункции

#КонецОбласти

&НаСервере
Функция ОбщиеПараметрыПараметрыМонитора()

	ПараметрыОбновления = Новый Структура;
	ПараметрыОбновления.Вставить("УИДДляВременногоХранилищаАдресаСхемы", УникальныйИдентификатор);
	ПараметрыОбновления.Вставить("УИДДляВременногоХранилищаАдресаДанныхРасшифровки", УникальныйИдентификатор);
	
	Возврат ПараметрыОбновления;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ОбновитьДанныеМонитора()
	ОбновитьДанныеМонитора();
КонецПроцедуры

#КонецОбласти

#Область Инициализация

#Если Сервер Тогда
МенеджерМонитора = Обработки.МониторОшибок;
#КонецЕсли

#Конецобласти




