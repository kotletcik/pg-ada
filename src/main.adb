with Ada.Numerics.Discrete_Random;
with Delivery;
with Kukiriniarz;
with Logging;


procedure main is
   -- Zakres losowanych opoznien.

   subtype OurDelay is Integer range 1 .. 10;
   
   -- Pakiet do losowania opoznien.
   package Randomizing is
   new Ada.Numerics.Discrete_Random(OurDelay);
   
   Gen : Randomizing.Generator;
   DelayTime : OurDelay;
   New_Delivery : Delivery.ShrimpsDelivery;

   -- Tworzenie pracownikow.
   KukiriniarzG2 : Kukiriniarz.Kid (Kukiriniarz.G2);
   KukiriniarzG4 : Kukiriniarz.Kid (Kukiriniarz.G4);
begin
   Logging.Start;
   Randomizing.Reset (Gen);
   for I in 1 .. 10 loop
      
      -- Tworzenie dostawy.
      New_Delivery.Id := I;
      New_Delivery.Towar := "Krewetki";
      New_Delivery.Ilosc := Randomizing.Random(Gen);
      Logging.Put_Line
        ("Przyjechal samochod" & Integer'Image (I)
         & " i czeka na rozladunek");
     
      -- Oczekiwanie na przyjecie dostawy.
      Delivery.Unloading.Przyjecie_dostawy(New_Delivery);
      
      DelayTime := Randomizing.Random(Gen);
      delay Duration(DelayTime);


   end loop;
   Delivery.Unloading.Zakoncz;
   KukiriniarzG2.Finish;
   KukiriniarzG4.Finish;
end main;
