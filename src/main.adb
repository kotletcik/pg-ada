with Ada.Numerics.Discrete_Random;
with Logging;
with Delivery;
with Kukiriniarz;
with Warehouse;
with MonsterTrucks;

procedure main is
   -- Zakres losowanych opoznien.

   subtype OurDelay is Integer range 1 .. 10;
   
   -- Pakiet do losowania opoznien.
   package Randomizing is
   new Ada.Numerics.Discrete_Random(OurDelay);
   
   Gen : Randomizing.Generator;
   -- zmienna z nasza losowa liczba
   DelayTimeTrucks : OurDelay;

   -- tworzenie dostawczakow
   TrucksMonster : Array(1 .. 10) of MonsterTrucks.Truck;

<<<<<<< HEAD
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


=======
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
>>>>>>> 78b162657467158cae6c590e3165a7609206b1b1
   end loop;
   for I in TrucksMonster'Range loop
      TrucksMonster(I).Departure;
   end loop;
   Delivery.Unloading.Finish;
   KukiriniarzG2.Finish;
   KukiriniarzG4.Finish;
<<<<<<< HEAD
=======
   -- Wyświetlamy stan magazynu
   Warehouse.Storage.Check_Stock;
>>>>>>> 78b162657467158cae6c590e3165a7609206b1b1
end main;
