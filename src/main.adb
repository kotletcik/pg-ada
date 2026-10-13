with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Delivery;
with Kukiriniarz;
with Warehouse;


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
   DelayTime : OurDelay;
   New_Delivery : Delivery.ShrimpsDelivery;

   --tworzenie kukiriniarzy
   KukiriniarzG2 : Kukiriniarz.Kid ("G2");
   KukiriniarzG4 : Kukiriniarz.Kid ("G4");
begin
   Randomizing.Reset(Gen);
   for I in 1 .. 10 loop
      
      --tworzenie dostaw
      New_Delivery.Id := I;
      New_Delivery.Towar := "Krewetki";
      New_Delivery.Ilosc := Randomizing.Random(Gen);
      Put_line("Przyjechal samochod"  & Integer'Image(I) & " i czeka na rozladunek");
     
      -- Wywołanie naszego spotkania, dwa taski
      -- się synchronizują
      Delivery.Unloading.Przyjecie_dostawy(New_Delivery);
      
      DelayTime := Randomizing.Random(Gen);
      delay Duration(DelayTime);


   end loop;
   Delivery.Unloading.Zakoncz;
   KukiriniarzG2.Finish;

   -- Wyświetlamy stan magazynu
   Warehouse.Storage.Check_Stock;
end main;
