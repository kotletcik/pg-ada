with Ada.Text_IO; 
use Ada.Text_IO;
with Unloading_Point;

package body Warehouse is

   task body Storage is
      Max_Capacity : constant Integer := 1000;

      Shrimp_Stock : array (Unloading_Point.Shrimp_Name) of Integer := (others => 0);
      Total_Shrimps : Integer := 0;
   begin
      loop
         select
            -- Akceptujemy dostawę TYLKO, gdy jest miejsce
            when Total_Shrimps < Max_Capacity =>
               accept Accept_Delivery (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer) do
                  Shrimp_Stock(Shrimp_Type) := Shrimp_Stock(Shrimp_Type) + Quantity;
                  Total_Shrimps := Total_Shrimps + Quantity;
                  Put_Line ("[M] Przyjeto dostawe: " & Quantity'Image & " sztuk, rodzaj: " & Shrimp_Type'Image);
               end Accept_Delivery;

         or
            -- Wyświetlamy stan magazynu
            accept Check_Stock do
               Put_Line ("[M] --- STAN MAGAZYNU KREWETEK ---");
               for Krewetka in Unloading_Point.Shrimp_Name loop
                  Put_Line ("[M] " & Krewetka'Image & ": " & Shrimp_Stock(Krewetka)'Image);
               end loop;
               Put_Line ("[M] Calkowite zapelnienie: " & Total_Shrimps'Image & " / " & Max_Capacity'Image);
               Put_Line ("[M] --------------------------------");
            end Check_Stock;
         or
            terminate;
         end select;
      end loop;
   end Storage;

end Warehouse;