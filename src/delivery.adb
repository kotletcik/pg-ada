with Ada.Text_IO;
use Ada.Text_IO;
--  Mamy pakiet dostaw, głównym zadaniem jest symulacja rozładunku
--  Dodatkowo mamy taska konczacego robote 
package body Delivery is
   task body Unloading is
      End_Of_Shift : Boolean := False;
   begin
      while not End_Of_Shift loop
         select
            accept Przyjecie_dostawy (ShrimpsTruck : ShrimpsDelivery) do
               Put_Line("Dostawa: Przyjelismy ladunek o ID: " & ShrimpsTruck.Id'Image & ", Towar: " & ShrimpsTruck.Towar & ", Ilosc: " & ShrimpsTruck.Ilosc'Image);
            end Przyjecie_dostawy;
            
            Put_Line("Dostawa: Rozpoczynamy rozladunek");
            delay 3.0; 
            Put_Line("Dostawa: Skonczylismy, czekamy na kolejne auta");
         or
            accept Zakoncz;
            End_Of_Shift := True;
         end select;   
      end loop;
      Put_Line("Dostawa: Jedziemy do domu 67");
   end Unloading;
end Delivery;
