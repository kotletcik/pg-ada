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
               Put_Line("Kukirniarze: Przyjelismy ladunek o ID: " & ShrimpsTruck.Id'Image & ", Towar: " & ShrimpsTruck.Towar & ", Ilosc: " & ShrimpsTruck.Ilosc'Image);
            end Przyjecie_dostawy;
            
            Put_Line("Kukirniarze: Rozpoczynamy rozladunek");
            delay 3.0; 
            Put_Line("Kukirniarze: Skonczylismy, czekamy na kolejne auta");
         or
            accept Zakoncz;
            End_Of_Shift := True;
         end select;   
      end loop;
      Put_Line("Kukirniarze: Jedziemy do domu 67");
   end Unloading;
end Delivery;
