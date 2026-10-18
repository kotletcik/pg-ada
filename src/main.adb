with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Delivery;
with Kukiriniarz;
with Warehouse;
with MonsterTrucks;

procedure main is
   -- w taki sposob definiuje sie losowanie liczb calkowitych, z poradnika
   -- wybieramy zakres

   subtype OurDelay is Integer range 1 .. 10;
   
   -- tworzymy pakiet dla liczb losowych
   package Randomizing is
   new Ada.Numerics.Discrete_Random(OurDelay);
   
   -- tworzymy generator
   Gen : Randomizing.Generator;
   -- zmienna z nasza losowa liczba
   DelayTimeTrucks : OurDelay;

   -- tworzenie dostawczakow
   TrucksMonster : Array(1 .. 10) of MonsterTrucks.Truck;

   --tworzenie kukiriniarzy
   KukiriniarzG2 : Kukiriniarz.Kid (Kukiriniarz.Skiba_Kukiriniarz);
   KukiriniarzG4 : Kukiriniarz.Kid (Kukiriniarz.Maniek_Kukiriniarz);
begin
   Randomizing.Reset(Gen);
   -- losowe wysylanie ciezarowek
    
   for I in TrucksMonster'Range loop
      DelayTimeTrucks := Randomizing.Random(Gen);
      delay Duration(DelayTimeTrucks);

      TrucksMonster(I).Start(
         Id => I,
         Ilosc => Randomizing.Random(Gen) *10
      );
   end loop;
   for I in TrucksMonster'Range loop
      TrucksMonster(I).Departure;
   end loop;
   Delivery.Unloading.Zakoncz;
   KukiriniarzG2.Finish;
   KukiriniarzG4.Finish;
   -- Wyświetlamy stan magazynu
   Warehouse.Storage.Check_Stock;
end main;
