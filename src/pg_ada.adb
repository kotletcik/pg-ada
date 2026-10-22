with Ada.Numerics.Discrete_Random;
with Delivery;
with Kukiriniarz;
with Logging;

procedure Pg_Ada is
   subtype OurDelay is Integer range 1 .. 10;

   -- Generator losuje ilosc dostawy i opoznienie.
   package Randomizing is
      new Ada.Numerics.Discrete_Random (OurDelay);

   Gen : Randomizing.Generator;
   DelayTime : OurDelay;
   New_Delivery : Delivery.ShrimpsDelivery;

   -- Pracownicy dzialaja jako niezalezne taski.
   KukiriniarzG2 : Kukiriniarz.Kid (Kukiriniarz.G2);
   KukiriniarzG4 : Kukiriniarz.Kid (Kukiriniarz.G4);
begin
   -- Od tego momentu mierzony jest czas programu.
   Logging.Start;
   Randomizing.Reset (Gen);

   for I in 1 .. 10 loop
      New_Delivery.Id := I;
      New_Delivery.Towar := "Krewetki";
      New_Delivery.Ilosc := Randomizing.Random (Gen);

      Logging.Put_Line
        ("Przyjechal samochod" & Integer'Image (I)
         & " i czeka na rozladunek");

      -- Entry synchronizuje samochod z taskiem rozladunku.
      Delivery.Unloading.Przyjecie_dostawy (New_Delivery);

      DelayTime := Randomizing.Random (Gen);
      delay Duration (DelayTime);
   end loop;

   -- Zakonczenie pracy taskow.
   Delivery.Unloading.Zakoncz;
   KukiriniarzG2.Finish;
   KukiriniarzG4.Finish;
end Pg_Ada;
