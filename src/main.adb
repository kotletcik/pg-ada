with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Unloading_Point;
with Kukiriniarz;
with Warehouse;
with MonsterTrucks;

procedure main is
   -- opoznienie przyjazdu cieazrowki
   subtype OurDelay is Integer range 1 .. 20;
   package Delay_Randomizing is new Ada.Numerics.Discrete_Random(OurDelay);
   Gen : Delay_Randomizing.Generator;
   
   -- ilosc krewetek w ciezarowce
   subtype CommodityQuantity is Integer range 2 .. 10;
   package Quantity_Randomizing is new Ada.Numerics.Discrete_Random(CommodityQuantity);
   Quantity_Gen : Quantity_Randomizing.Generator;

   -- generator dla nazw kreweretk
   package Shrimp_Randomizing is new Ada.Numerics.Discrete_Random(Unloading_Point.Shrimp_Name);
   Shrimp_Gen : Shrimp_Randomizing.Generator;

   -- 1/4 szansy na zamowienie priorytetowe
   subtype PriorityChance is Integer range 1 .. 4;
   package Priority_randomize is new Ada.Numerics.Discrete_Random(PriorityChance);
   Priority_Gen : Priority_randomize.Generator;


   TrucksMonster : Array(1 .. 10) of MonsterTrucks.Truck;

   KukiriniarzG2 : Kukiriniarz.Kid (Kukiriniarz.Skiba_Kukiriniarz);
   KukiriniarzG4 : Kukiriniarz.Kid (Kukiriniarz.Maniek_Kukiriniarz);
begin
   Delay_Randomizing.Reset(Gen);
   Quantity_Randomizing.Reset(Quantity_Gen);
   Shrimp_Randomizing.Reset(Shrimp_Gen);
   Priority_randomize.Reset(Priority_Gen);
   
   -- petla od tworzenia monstertuckow, nasze wsm glowne dzialanie jak narazie,
   -- bo technik geminista nie zrobil ladnego warehousea ~ +1 byczku wariacie
   -- damn ☺
   for I in TrucksMonster'Range loop
      TrucksMonster(I).Start(
         Id => I,
         Quantity => Quantity_Randomizing.Random(Quantity_Gen) * 10,
         Travel_Time => Delay_Randomizing.Random(Gen),
         Shrimp_Name => Shrimp_Randomizing.Random(Shrimp_Gen),
         Priority => Priority_randomize.Random(Priority_Gen) = 4
      );
   end loop;
   -- petla, ktora koncz dzialanie kazde trucka, dzieki niej program sie konczy inaczej wisialby w nieskonczonosc
   for I in TrucksMonster'Range loop
      TrucksMonster(I).Departure;
   end loop;
   
   Unloading_Point.Queue.Close;
   KukiriniarzG2.Finish;
   KukiriniarzG4.Finish;
   
   Warehouse.Storage.Check_Stock;
end main;