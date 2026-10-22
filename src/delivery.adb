with Ada.Numerics.Discrete_Random;
--  Mamy pakiet dostaw, głównym zadaniem jest symulacja rozładunku
--  Dodatkowo mamy taska konczacego robote 
package body Delivery is-- komentarz
   task body Unloading is
      End_Of_Shift : Boolean := False;
      Subtype OurDelay is Integer range 1 .. 5;
      
      -- tworzymy pakiet dla liczb losowych
      package Randomizing is
      new Ada.Numerics.Discrete_Random(OurDelay);
      
      -- tworzymy generator
      Gen : Randomizing.Generator;
      -- zmienna z nasza losowa liczba
      DelayTime : OurDelay;
   begin
      -- Obsluga dostaw trwa do zakonczenia zmiany.
      while not End_Of_Shift loop
         select
            accept DeliveryAcceptance (ShrimpsTruck : ShrimpsDelivery) do
               Logging.Put_Line("Pracownik: Przyjelismy ladunek o ID: " & ShrimpsTruck.Id'Image & ", Towar: " & ShrimpsTruck.Commodity & ", Ilosc: " & ShrimpsTruck.Quantity'Image);
               Logging.Put_Line("Pracownik: Rozpoczynamy rozladunek");
               
               DelayTime := Randomizing.Random(Gen);
               delay Duration(DelayTime); 
               Logging.Put_Line("Pracownik: Skonczylismy, czekamy na kolejne auta");
            end DeliveryAcceptance;
         or
            accept Finish;
            End_Of_Shift := True;
         end select;   
      end loop;
      Logging.Put_Line("Pracownik: Jedziemy do domu 67");
   end Unloading;
end Delivery;
