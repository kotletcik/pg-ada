with Ada.Numerics.Discrete_Random;
with Delivery;
with Kukiriniarz;
with Logging;

procedure Pg_Ada is
   subtype OurDelay is Integer range 1 .. 10;

   -- Generator controls both the delivery quantity and the delay between cars.
   package Randomizing is
      new Ada.Numerics.Discrete_Random (OurDelay);

   Gen : Randomizing.Generator;
   DelayTime : OurDelay;
   New_Delivery : Delivery.ShrimpsDelivery;

   -- Both workers are Ada tasks and can run independently of the main task.
   KukiriniarzG2 : Kukiriniarz.Kid (Kukiriniarz.G2);
   KukiriniarzG4 : Kukiriniarz.Kid (Kukiriniarz.G4);
begin
   -- All timestamps are measured from this point until program termination.
   Logging.Start;
   Randomizing.Reset (Gen);

   for I in 1 .. 10 loop
      New_Delivery.Id := I;
      New_Delivery.Towar := "Krewetki";
      New_Delivery.Ilosc := Randomizing.Random (Gen);

      Logging.Put_Line
        ("Przyjechal samochod" & Integer'Image (I)
         & " i czeka na rozladunek");

      -- Calling an entry synchronizes the car with the unloading task.
      Delivery.Unloading.Przyjecie_dostawy (New_Delivery);

      DelayTime := Randomizing.Random (Gen);
      delay Duration (DelayTime);
   end loop;

   -- Finish entries let each task leave its main loop in an orderly way.
   Delivery.Unloading.Zakoncz;
   KukiriniarzG2.Finish;
end Pg_Ada;
