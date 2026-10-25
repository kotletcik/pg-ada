with Ada.Numerics.Discrete_Random;
with Unloading_Point;
with Kukiriniarz;
with Warehouse;
with MonsterTrucks;
with Monitoring_Centre;
with Data_Analyzer;

procedure main is
   -- opoznienie przyjazdu cieazrowki
   subtype OurDelay is Integer range 4 .. 8;
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
   Cumulative_Time : Integer := 0;
begin
   Delay_Randomizing.Reset(Gen);
   Quantity_Randomizing.Reset(Quantity_Gen);
   Shrimp_Randomizing.Reset(Shrimp_Gen);
   Priority_randomize.Reset(Priority_Gen);

   Monitoring_Centre.Screen.Init_Screen;
   
   -- petla tworzenia monstertuckow
   for I in TrucksMonster'Range loop
      Cumulative_Time := Cumulative_Time + Delay_Randomizing.Random(Gen);
      TrucksMonster(I).Start(
         Id => I,
         Quantity => Quantity_Randomizing.Random(Quantity_Gen) * 10,
         Travel_Time => Cumulative_Time,
         Shrimp_Name => Shrimp_Randomizing.Random(Shrimp_Gen),
         Priority => Priority_randomize.Random(Priority_Gen) = 4
      );
   end loop;
   
   -- Aktywne czekanie na koniec wszystkich dostaw
   declare
      P, N, Served : Integer := 0;
   begin
      while Served < 10 loop
         delay 0.5;
         Unloading_Point.Queue.Get_Stats(P, N, Served);
      end loop;
   end;
   
   Unloading_Point.Unloading.Close;
   Unloading_Point.Unloading.Wait_Until_Done;
   Kukiriniarz.Finish_All;
   
   -- zakonczenie dzialania wyswietlania
   Data_Analyzer.Monitor.Stop;
   
   -- ostatnie odswiezenie wyswietlania, zeby nie bylo pustego ekranu
   Monitoring_Centre.Screen.Reset_Screen;
end main;