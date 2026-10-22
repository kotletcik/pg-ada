with Ada.Numerics.Discrete_Random;
with Delivery;
with Kukiriniarz;
with Logging;


procedure main is
   -- w taki sposob definiuje sie losowanie liczb calkowitych, z poradnika
   -- wybieramy zakres

   subtype OurDelay is Integer range 1 .. 10;
   
   -- The random package supplies realistic delays between incoming cars.
   package Randomizing is
   new Ada.Numerics.Discrete_Random(OurDelay);
   
   Gen : Randomizing.Generator;
   DelayTime : OurDelay;
   New_Delivery : Delivery.ShrimpsDelivery;

   --tworzenie kukiriniarzy
   KukiriniarzG2 : Kukiriniarz.Kid (Kukiriniarz.G2);
   KukiriniarzG4 : Kukiriniarz.Kid (Kukiriniarz.G4);
begin
   Logging.Start;
   Randomizing.Reset (Gen);
   for I in 1 .. 10 loop
      
      --tworzenie dostaw
      New_Delivery.Id := I;
      New_Delivery.Towar := "Krewetki";
      New_Delivery.Ilosc := Randomizing.Random(Gen);
      Logging.Put_Line
        ("Przyjechal samochod" & Integer'Image (I)
         & " i czeka na rozladunek");
     
      -- The entry call blocks until the unloading task accepts the delivery.
      Delivery.Unloading.Przyjecie_dostawy(New_Delivery);
      
      DelayTime := Randomizing.Random(Gen);
      delay Duration(DelayTime);


   end loop;
   Delivery.Unloading.Zakoncz;
   KukiriniarzG2.Finish;
end main;
