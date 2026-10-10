with Ada.Numerics.Discrete_Random;
with Ada.Text_IO;
use Ada.Text_IO;
with Delivery;

procedure pg_ada is
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
begin
   Randomizing.Reset(Gen);
   for I in 1 .. 10 loop
      
      New_Delivery.Id := I;
      New_Delivery.Towar := "Krewetki";
      New_Delivery.Ilosc := Randomizing.Random(Gen);
      Put_line("Przyjechał samochod"  & Integer'Image(I) & " i czeka na rozładunek");
     
      -- Wywołanie naszego spotkania, dwa taski
      -- się synchronizują
      Delivery.Unloading.Przyjecie_dostawy(New_Delivery);
      
      DelayTime := Randomizing.Random(Gen);
      delay Duration(DelayTime);
   end loop;
   Delivery.Unloading.Zakoncz;
end pg_ada;
