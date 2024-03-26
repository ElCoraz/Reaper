﻿//*****************************************************************************************
&НаКлиенте
Процедура ЗагрузитьФайл(Команда) 

	Фильтр = "Внешнаяя обработка (*.epf)|*.epf|"	+ "Внешний отчет (*.erf)|*.erf|"	+ "Конфигурация (*.cf)|*.cf|"	+ "Расширение конфигурации (*.cfe)|*.cfe|";		Диалог = Новый ПараметрыДиалогаПомещенияФайлов("Выберите файл", Ложь, Фильтр);			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияДиалогаВыбораПодписи", ЭтаФорма);		НачатьПомещениеФайлаНаСервер(Оповещение,,,, Диалог, УникальныйИдентификатор);	
КонецПроцедуры       
//*****************************************************************************************
&НаКлиентеПроцедура ПослеЗакрытияДиалогаВыбораПодписи (ОписаниеФайла, ДопПараметры) Экспорт		Если ОписаниеФайла.ПомещениеФайлаОтменено Тогда 
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
	
	НоваяСтрока = Объект.Файлы.Добавить();
	
	НоваяСтрока.Путь		 = СтрЗаменить(Параметры.Файл.ПолноеИмя, Параметры.Каталог, ""); 
	НоваяСтрока.Text		 = Параметры.ТекстовыйДокумент.ПолучитьТекст(); 
	НоваяСтрока.Наименование = Параметры.Файл.Имя; 
	
	
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

	ИмяФайла = ДополнительныеПараметры.Каталог + "v8unpack.exe"; 
	
	ДвоичныеДанные = ПолучитьДвоичныеДанные();
	
	ДвоичныеДанные.Записать(ИмяФайла); 
	
	КомандаСистемы("v8unpack.exe -P " + ДополнительныеПараметры.ИмяКаталогаИФайла + Объект.Расширение + " " + ДополнительныеПараметры.ИмяКаталогаИФайла, ДополнительныеПараметры.Каталог);  
	
	НачатьПоискФайлов(Новый ОписаниеОповещения("НачатьПоискФайловЗавершение", ЭтотОбъект, Новый Структура("Каталог", ДополнительныеПараметры.Каталог)), ДополнительныеПараметры.Каталог + ДополнительныеПараметры.ИмяКаталогаИФайла, "image", Истина);

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
