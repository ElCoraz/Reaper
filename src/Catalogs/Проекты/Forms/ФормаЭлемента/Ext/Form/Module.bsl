﻿//*****************************************************************************************
&НаКлиентеПроцедура ПослеЗакрытияВопросаЗагрузка(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда

		Возврат;
		
	КонецЕсли;	Фильтр = "Внешнаяя обработка (*.epf)|*.epf|"
	+ "Внешний отчет (*.erf)|*.erf|"
	+ "Конфигурация (*.cf)|*.cf|"
	+ "Расширение конфигурации (*.cfe)|*.cfe|"
	+ "Текст (*.txt)|*.txt|"
	+ "Все фалы (*.*)|*.*|";
	
	Диалог = Новый ПараметрыДиалогаПомещенияФайлов("Выберите файл", Ложь, Фильтр);
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбора", ЭтаФорма);
	
	НачатьПомещениеФайлаНаСервер(Оповещение,,,, Диалог, УникальныйИдентификатор);  
КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура ЗагрузитьФайл(Команда) 

	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗагрузка", ЭтотОбъект, Параметры), "Загрузить файл?", РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры       
//*****************************************************************************************
&НаКлиентеПроцедура ПослеЗакрытияДиалогаВыбора(ОписаниеФайла, ДополнительныеПараметры) Экспорт		Если ОписаниеФайла.ПомещениеФайлаОтменено Тогда 
				Возврат;		
	КонецЕсли;
	
	Объект.Расширение	 = ОписаниеФайла.СсылкаНаФайл.Расширение; 
	Объект.Наименование	 = ОписаниеФайла.СсылкаНаФайл.Имя; 
		АдресВХранилище = ОписаниеФайла.Адрес;	
	ОбработатьФайл(ОписаниеФайла.СсылкаНаФайл.Файл.ПолноеИмя);
	КонецПроцедуры
//*****************************************************************************************
&НаСервере
Функция ПолучитьДвоичныеДанные() 
	
	Возврат ПолучитьОбщийМакет("v8unpack_win_x64");
	
КонецФункции
//*****************************************************************************************
&НаКлиенте
Процедура ПослеЧтенияФайла(Параметры) Экспорт 
	
	Записать();
	
	Текст = Параметры.ТекстовыйДокумент.ПолучитьТекст(); 
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		Данные = Парсинг.ВыполнитьПарсинг(Текст); 
		
		ТочкаВхода = Парсинг.ОбработатьФайлНаСервере(Объект.Ссылка, Параметры.Файл, Данные); 

		НоваяСтрока = Объект.Файлы.Добавить();
		
		НоваяСтрока.Путь		 = СтрЗаменить(Параметры.Файл, Параметры.Каталог, ""); 
		НоваяСтрока.Text		 = Текст; 
		НоваяСтрока.ТочкаВхода	 = ТочкаВхода; 
		НоваяСтрока.Наименование = Параметры.Файл; 
		
	КонецЕсли;
	
КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура ЗавершитьПроверкуЭтоФайл(ЭтоФайл, ДополнительныеПараметры) Экспорт

	Если ЭтоФайл Тогда   
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		
		ПараметрыЧтения = Новый Структура("Файл, Каталог, ТекстовыйДокумент", ДополнительныеПараметры.Файл, ДополнительныеПараметры.Каталог, ТекстовыйДокумент);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЧтенияФайла", ЭтаФорма, ПараметрыЧтения);		
		
		ТекстовыйДокумент.НачатьЧтение(ОписаниеОповещения, ДополнительныеПараметры.Файл.ПолноеИмя);
		
	КонецЕсли;
	
КонецПроцедуры
//*****************************************************************************************   
&НаКлиенте
Процедура НачатьПоискФайловЗавершение(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	Для Каждого Файл из НайденныеФайлы Цикл

		Файл.НачатьПроверкуЭтоФайл(Новый ОписаниеОповещения("ЗавершитьПроверкуЭтоФайл", ЭтотОбъект, Новый Структура("Файл, Каталог", Файл, ДополнительныеПараметры.Каталог)));

	КонецЦикла;

КонецПроцедуры
//***************************************************************************************** 
&НаКлиенте
Процедура СкопироватьФайлЗавершение(Файл, ДополнительныеПараметры) Экспорт  
	
	Соответствие = Новый Соответствие;
	
	Соответствие.Вставить("*.cf");
	Соответствие.Вставить("*.epf");
	Соответствие.Вставить("*.erf");
	Соответствие.Вставить("*.cfe");
	
	
	Если Соответствие.Получить(Объект.Расширение) <> Неопределено Тогда  
		
		ИмяФайла = ДополнительныеПараметры.Каталог + "v8unpack.exe"; 
		
		ДвоичныеДанные = ПолучитьДвоичныеДанные();
		
		ДвоичныеДанные.Записать(ИмяФайла); 
		
		КомандаСистемы("v8unpack.exe -P " + ДополнительныеПараметры.ИмяКаталогаИФайла + Объект.Расширение + " " + ДополнительныеПараметры.ИмяКаталогаИФайла, ДополнительныеПараметры.Каталог);  
		
		НачатьПоискФайлов(Новый ОписаниеОповещения("НачатьПоискФайловЗавершение", ЭтотОбъект, Новый Структура("Каталог", ДополнительныеПараметры.Каталог)), ДополнительныеПараметры.Каталог + ДополнительныеПараметры.ИмяКаталогаИФайла, "image", Истина);
		
	Иначе

		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		
		ПараметрыЧтения = Новый Структура("Файл, Каталог, ТекстовыйДокумент", ДополнительныеПараметры.Файл, ДополнительныеПараметры.Каталог, ТекстовыйДокумент);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЧтенияФайла", ЭтаФорма, ПараметрыЧтения);		
		
		ТекстовыйДокумент.НачатьЧтение(ОписаниеОповещения, ДополнительныеПараметры.Файл);
		
	КонецЕсли;
	
КонецПроцедуры
//***************************************************************************************** 
&НаКлиенте
Процедура ПолучитьКаталогВременныхФайловЗавершение(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	ИмяКаталогаИФайла = Строка(Новый УникальныйИдентификатор());
	
	Структура = Новый Структура;    
	
	Структура.Вставить("Файл",				 ДополнительныеПараметры.Файл);
	Структура.Вставить("Каталог",			 ИмяКаталогаВременныхФайлов);
	Структура.Вставить("ИмяКаталогаИФайла",	 ИмяКаталогаИФайла);

	НачатьКопированиеФайла(Новый ОписаниеОповещения("СкопироватьФайлЗавершение", ЭтотОбъект, Структура), ДополнительныеПараметры.Файл, ИмяКаталогаВременныхФайлов + ИмяКаталогаИФайла + Объект.Расширение);

КонецПроцедуры
//***************************************************************************************** 
&НаКлиенте
Процедура ОбработатьФайл(ОписаниеФайла) 
	
	Структура = Новый Структура("Файл", ОписаниеФайла);

	НачатьПолучениеКаталогаВременныхФайлов(Новый ОписаниеОповещения("ПолучитьКаталогВременныхФайловЗавершение", ЭтотОбъект, Структура));

КонецПроцедуры
//*****************************************************************************************
&НаСервере
Процедура ПередЗаписьюНаСервере()     

	РеквизитФормыВЗначение("Объект").СохранитьФайл(АдресВХранилище);

КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура ФайлыCodeНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	ТекстовыйДокумент.УстановитьТекст(Элементы.Файлы.ТекущиеДанные.Code);
	
	ТекстовыйДокумент.Показать("Code");
	
КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура ФайлыTextНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	ТекстовыйДокумент.УстановитьТекст(Элементы.Файлы.ТекущиеДанные.Text);
	
	ТекстовыйДокумент.Показать("Text");
	
КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура ПослеЗакрытияВопросаСохранение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда

		Возврат;
		
	КонецЕсли;

КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура ВыгрузитьФайл(Команда)

	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопросаСохранение", ЭтотОбъект, Параметры), "Сохранить файл?", РежимДиалогаВопрос.ДаНет, 0);
	
КонецПроцедуры
//*****************************************************************************************
&НаСервере
Процедура УдалитьДанныеНаСервере()
	
	Code = РегистрыСведений.Code.СоздатьНаборЗаписей();
	
	Code.Отбор.Проект = Объект.Ссылка;
	
	Code.Записать();  
	
	CodeText = РегистрыСведений.CodeText.СоздатьНаборЗаписей();
	
	CodeText.Отбор.Проект = Объект.Ссылка;
	
	CodeText.Записать();
	
	History = РегистрыСведений.History.СоздатьНаборЗаписей();
	
	History.Отбор.Проект = Объект.Ссылка;
	
	History.Записать();
	
	Labels = РегистрыСведений.Labels.СоздатьНаборЗаписей();
	
	Labels.Отбор.Проект = Объект.Ссылка;
	
	Labels.Записать();
	
	Memory = РегистрыСведений.Memory.СоздатьНаборЗаписей();
	
	Memory.Отбор.Проект = Объект.Ссылка;
	
	Memory.Записать();
	
	Stack = РегистрыСведений.Stack.СоздатьНаборЗаписей();
	
	Stack.Отбор.Проект = Объект.Ссылка;
	
	Stack.Записать();
	
	StackTMP = РегистрыСведений.StackTMP.СоздатьНаборЗаписей();
	
	StackTMP.Отбор.Проект = Объект.Ссылка;
	
	StackTMP.Записать();
	
	Значения = РегистрыСведений.Значения.СоздатьНаборЗаписей();
	
	Значения.Отбор.Проект = Объект.Ссылка;
	
	Значения.Записать();
	
	ЗначенияПроцедурФункций = РегистрыСведений.ЗначенияПроцедурФункций.СоздатьНаборЗаписей();
	
	ЗначенияПроцедурФункций.Отбор.Проект = Объект.Ссылка;
	
	ЗначенияПроцедурФункций.Записать();

	ПроцедурыФункции = РегистрыСведений.ПроцедурыФункции.СоздатьНаборЗаписей();
	
	ПроцедурыФункции.Отбор.Проект = Объект.Ссылка;
	
	ПроцедурыФункции.Записать();

КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт

	Если Результат = КодВозвратаДиалога.Нет Тогда

		Возврат;

	КонецЕсли;

    УдалитьДанныеНаСервере();
	
	ПоказатьПредупреждение(, "Данные по регистрам удалены");
	
КонецПроцедуры
//*****************************************************************************************
&НаКлиенте
Процедура Очистить(Команда)

	ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект, Параметры), "Удалить данные по все регистрам?", РежимДиалогаВопрос.ДаНет, 0);

КонецПроцедуры
//*****************************************************************************************
