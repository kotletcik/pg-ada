with Ada.Numerics.Discrete_Random;
with Logging;
with Delivery;
with Kukiriniarz;
with Warehouse;
with MonsterTrucks;

procedure main is
   -- w taki sposob definiuje sie losowanie liczb calkowitych, z poradnika
   -- wybieramy zakres

   subtype OurDelay is Integer range 1 .. 10;
   
   -- The random package supplies realistic delays between incoming cars.
   package Randomizing is
   new Ada.Numerics.Discrete_Random(OurDelay);
   
   Gen : Randomizing.Generator;
   -- zmienna z nasza losowa liczba
   DelayTimeTrucks : OurDelay;

   -- tworzenie dostawczakow
   TrucksMonster : Array(1 .. 10) of MonsterTrucks.Truck;

   --tworzenie kukiriniarzy
   KukiriniarzG2 : Kukiriniarz.Kid (Kukiriniarz.Skiba_Kukiriniarz);
   KukiriniarzG4 : Kukiriniarz.Kid (Kukiriniarz.Maniek_Kukiriniarz);
begin
   Logging.Start;
   Randomizing.Reset (Gen);
   -- losowe wysylanie ciezarowek
     
   for I in TrucksMonster'Range loop
      DelayTimeTrucks := Randomizing.Random(Gen);
      delay Duration(DelayTimeTrucks);
      Logging.Put_Line ("Przyjechal samochod" & Integer'Image (I) & " i czeka na rozladunek");
      TrucksMonster(I).Start(
         Id => I,
         Quantity => Randomizing.Random(Gen) *10
      );
   end loop;
   for I in TrucksMonster'Range loop
      TrucksMonster(I).Departure;
   end loop;
   Delivery.Unloading.Finish;
   KukiriniarzG2.Finish;
   KukiriniarzG4.Finish;
   -- Wyświetlamy stan magazynu
   Warehouse.Storage.Check_Stock;
end main;
