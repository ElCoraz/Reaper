﻿//******************************************************************************
&НаКлиенте
Процедура Расшифровать(Команда) 
	
	Количество = 1;
	
	Пока Истина Цикл 
		
		Результат = ""; 
		
		Попытка
			
			Для А = 1 По Количество Цикл 
				
				ПервоеЧисло = Число(Сред(Объект.ПерваяСтрока,(А - 1) * 4 + 1, 4));
				ВтороеЧисло = Число(Символ(КодСимвола(Объект.ВтораяСтрокаСтр2, А)));
				
				Результат = Результат + Символ(ПервоеЧисло - ВтороеЧисло);
				
			КонецЦикла;
			
			Количество = Количество + 1;
			
		Исключение
			
			Прервать;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Объект.Результат = Результат; 
	
КонецПроцедуры
//******************************************************************************