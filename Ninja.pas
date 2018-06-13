uses graphABC;

type
  point = record
    x, y: integer;
    fruit: picture;
    isFull: boolean;
  end;

const
  NUMBER_OF_FRUITS = 10;

const
  BUCKET_SPEED = 6;

var
  bucket, background: picture;
  Left, Right, x, y, i, score: integer;
  vy: real;
  storedScore: string;
  fruits: array [1..NUMBER_OF_FRUITS] of point;
  game, active, how, gameover: boolean;
  database: text;

//Клавиша нажата
procedure KeyDown(Key: integer);
begin
  //если нажата левая кнопка на клавиатуре, то устанавливаем флаг
  if Key = vk_Left then Left := 1;
  //если нажата правая кнопка на клавиатуре, то устанавливаем флаг
  if Key = vk_Right then Right := 1;
  //если нажата ESC кнопка на клавиатуре, то останавливаем все экраны и возвращаемся на экран с меню
  if key = vk_Escape then
  begin
    game := false;
    how := false;
    gameover := false;
  end;
end;

//Клавиша отпушена
procedure KeyUp(Key: integer);
begin
  //если нажата левая кнопка на клавиатуре, то сбрасываем флаг
  if Key = vk_Left then Left := 0;
  //если нажата правая кнопка на клавиатуре, то сбрасываем флаг
  if Key = vk_Right then Right := 0;
end;

procedure MouseUp(x, y, mb: integer);
begin
  //Проверяем была ли нажата кнопка start левой кнопкой мыши
  if (mb = 1) and (x > 360) and (x < 600) and (y > 133) and (y < 183) then game := true;
  //Проверяем была ли нажата кнопка how to play левой кнопкой мыши
  if (mb = 1) and (x > 360) and (x < 600) and (y > 190) and (y < 240) then 
  begin
    how := true;
    //сюда можешь вставлять открытие справки .chm
  end;
  //Проверяем была ли нажата кнопка exit левой кнопкой мыши
  if (mb = 1) and (x > 360) and (x < 600) and (y > 247) and (y < 297) then active := false;
  //Проверяем была ли нажата кнопка restart левой кнопкой мыши
  if (mb = 1) and (x > 380) and (x < 580) and (y > 233) and (y < 283) and (gameover = true) then 
  begin
    game := true; //начинаем игру
    active := true;
    gameover := false; //закрываем экран с результатом партии
  end;
end;

//Печать счета
procedure printScore();
begin
  SetPenColor(clBlack);//устанавливает цвет пера
  SetFontColor(clBlue);//устанавливает цвет шрифта
  SetBrushColor(clTransparent);//цвет заливки окна
  setfontsize(20);//Размер текста
  TextOut(10, 10, score.ToString);//выводим сам текст, начиная с пикселя 10, 10
end;

//Печать скорости
procedure printSpeed();
begin
  SetPenColor(clBlack);
  SetFontColor(clBlue);
  SetBrushColor(clTransparent);
  setfontsize(20);
  TextOut(10, 40, (Round(vy * 100) / 100).ToString);
end;

//Меню игры
procedure drawMenu();
begin
  SetPenColor(clBlack);
  SetFontColor(clBlue);
  SetBrushColor(clTransparent);
  setfontsize(20);
  TextOut(450, 30, 'Ninja');
  Line(10, 70, 950, 70);//Рисуем линию
  
  SetPenColor(clRed);
  SetBrushColor(clYellowGreen);
  setfontsize(20);
  Rectangle(360, 133, 600, 183);//Рисует прямоугольник начиная с пикселя 360, 133 до 600, 183
  TextOut(450, 140, 'Start');
  
  Rectangle(360, 190, 600, 240);
  TextOut(415, 197, 'How to play');
  
  Rectangle(360, 247, 600, 297);
  TextOut(460, 254, 'Exit');
  
  Rectangle(340, 400, 620, 600);
  SetFontColor(clYellow);
  setfontsize(30);
  TextOut(370, 420, 'Your record:');
  SetFontColor(clRed);
  TextOut(440, 500, storedScore);//Выводим лучший результат
end;

//Отрисовываем результаты одно сессии игры
procedure drawSessionResult();
begin
  ClearWindow;// очищаем все что было
  OnMouseUp := MouseUp; //назначаем листенеров
  background.Draw(0, 0); //Отрисовываем бэкграунд
  SetBrushColor(clTransparent);
  SetFontColor(clBlue);
  TextOut(420, 150, 'Game over!');
  SetBrushColor(clYellowGreen);
  Rectangle(380, 233, 580, 283);
  TextOut(440, 240, 'Restart');
  SetBrushColor(clYellow);
  Rectangle(380, 303, 580, 353);
  TextOut(440, 310, 'Score: ');
  TextOut(530, 310, score.ToString);
end;

//Загружаем картинки и задаем им стартовые рандомные значения
//В приницпе все очевидно
procedure initFruits();
var
  i: integer;
begin
  fruits[1].x := random(960);
  fruits[1].y := random(640);
  fruits[1].fruit := picture.Create('res\lime.png');
  fruits[1].isFull := false;
  
  fruits[2].x := random(960);
  fruits[2].y := random(640);
  fruits[2].fruit := picture.Create('res\lemon.png');
  fruits[2].isFull := false;
  
  fruits[3].x := random(960);
  fruits[3].y := random(640);
  fruits[3].fruit := picture.Create('res\pineapple.png');
  fruits[3].isFull := false;
  
  fruits[4].x := random(960);
  fruits[4].y := random(640);
  fruits[4].fruit := picture.Create('res\full.png');
  fruits[4].isFull := true;
  
  fruits[5].x := random(960);
  fruits[5].y := random(640);
  fruits[5].fruit := picture.Create('res\watermelon.png');
  fruits[5].isFull := false;
  
  for i := 6 to 8 do
  begin
    fruits[i].x := random(960);
    fruits[i].y := random(640);
    fruits[i].fruit := picture.Create('res\apple.png');
    fruits[i].isFull := false;
  end;
  
  for i := 8 to NUMBER_OF_FRUITS do
  begin
    fruits[i].x := random(960);
    fruits[i].y := random(640);
    
    fruits[i].fruit := picture.Create('res\melon.png');
    fruits[i].isFull := false;
  end;
  
end;

begin
  window.Caption := 'Ninja';//Название окна
  SetWindowSize(960, 640);//Размер окна
  window.IsFixedSize := true; //Не изменяем окно
  LockDrawing;//Блокируем отрисовку, сами будем отрисовывает при необходимося, вызывая функцию Redraw;
  OnKeyDown := KeyDown;//Назнаем листенеры на нажатия клавиш
  OnKeyUp := KeyUp;
  OnMouseUp := MouseUp;
  background := picture.Create('res\background.png');//загрузили картинку для бэкграунда
  bucket := picture.Create('res\bucket.png');//загрузили ведерко
  
  initFruits();//инициализируем наш массив с фруктами
  
  game := false;
  gameover := false;
  active := true;
  //Выполняется бесконечный цикл, пока мы не нажмем exit, см.процедуру MouseUp
  while active do
  begin
    ClearWindow;//очищаем все, что отрисовали ранее
    background.Draw(0, 0); //рисуем бэкграунд, начиная с пикселя 0, 0
    //стартовое положение ведра
    x := 430;
    y := 540;
    //стартовое ускорение фруктов
    vy := 10;
    //счет в начале игры равен нулю, логично
    score := 0;
    
    assign(database, 'res\database.db');//открываем файл с результатами. В файле хранится лучшый результат по итогам всех игр
    reset(database);
    readln(database, storedScore);//читаем результаты
    close(database);// закрываем файл
    
    if not game then drawMenu();// при старте игры рисуем меню с кнопками. см.процедуру drawMenu();
    Redraw;//Отрисовали на экране все, что поместили туда
    
    //стартовала наша игра, см.процедуру MouseUp 
    while game do
    begin
      background.Draw(0, 0);
      //пробегаемся по всему массиву с фруктами нашими
      for i := 1 to NUMBER_OF_FRUITS do 
      begin
        //придаем фрукту ускороние
        fruits[i].y := fruits[i].y + round(vy);
        //если вышел за нижнюю
        if fruits[i].y > 640 then
        begin
          fruits[i].y := 0;//, то перемещаем в начало экрана
          fruits[i].x := random(960);// и задаем рандомное значение по оси икс
        end;
        fruits[i].fruit.Draw(fruits[i].x, fruits[i].y);//отрисовываем фрукт
      end;
      bucket.Draw(x, y);//Отрисовываем ведро
      
      if (Left = 1) and (x > 0) then x := x - BUCKET_SPEED;// если нажата кнопка влево, то перемещаем ведерко влево по оси икс
      if (Right = 1) and (x < 860) then x := x + BUCKET_SPEED;// если нажата кнопка вправо, то перемещаем ведерко вправо по оси икс
      vy := vy + 0.01;//увеличиваем скорость фруктов
      
      for i := 1 to NUMBER_OF_FRUITS do 
      begin
      //если фрукт попал в область ведерка 
        if(fruits[i].x > x) and (fruits[i].x + 50 < x + 100) and ((fruits[i].y + 10 < y) and (fruits[i].y + 40 > y)) then 
        begin
          fruits[i].y := 0;//, то перемещаем в начало экрана
          fruits[i].x := random(960);// и задаем рандомное значение по оси икс
          inc(score);// увеличиваем счет на 1
          if(score mod 10 = 0) then //если счет кратен 10,то уменьшаем скорость(суть игры)
          begin
            vy := vy - 0.01;
          end;
          if(fruits[i].isFull) then //если смогли поймать тарелку со всеми фруктами, то уменьшаем скорость(суть игры)
          begin
            vy := vy - 0.02;
          end;
        end;
      end;
      printSpeed();
      printScore();
      //если скорость падения фруктов превышает 30у.е., то завершаем текущий сеанс игры и показываем итог сеаснса
      if(vy > 30) then
      begin
        game := false;
        gameover := true;
      end;
      ReDraw;
    end;
    while gameover do
    begin
      drawSessionResult();
      Redraw;
    end;
    
    //если набрали очков больше,чем записано в файле, то записываем в файл новый результат
    if(score > StrToInt(storedScore)) then
    begin
      storedScore := IntToStr(score);
      assign(database, 'res\database.db');
      rewrite(database);
      writeln(database, storedScore);
      close(database);
    end;
  end;
  Halt;
end. 