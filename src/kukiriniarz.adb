with Ada.Text_IO;
use Ada.Text_IO;
with Warehouse;

package body Kukiriniarz is
   task body Kid is
      Is_End : Boolean := False;
   begin
      while not Is_End loop
         select
            accept Transport (ShrimpType : Character; Quantity : Integer) do
               Put_Line ("[K" & Id'Image & "] Otrzymano zadanie transportu");

               Put_Line ("[K" & Id'Image & "] Jedzie do magazynu...");
               delay 4.0;
            
               Warehouse.Storage.Accept_Delivery (ShrimpType, Quantity);
               Put_Line ("[K" & Id'Image & "] Dostarczono towar, kukiriniarz ma wolne");
            end Transport;
         or
            accept Finish;
            Is_End := True;
         end select;
      end loop;

      Put_Line ("[K" & Id'Image & "] Koniec pracy kukiriniarza");
   end Kid;
end Kukiriniarz;