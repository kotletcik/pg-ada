with Ada.Text_IO;
use Ada.Text_IO;

package body Kukiriniarz is
   task body Kid is
      Is_End : Boolean := False;
   begin
      while not Is_End loop
         select
            accept Transport (ShrimpType : Character; Quantity : Integer) do
               Put_Line ("[K" & Id & "] Otrzymano zadanie transportu");
            end Transport;

            Put_Line ("[K" & Id & "] Jedzie do magazynu...");
            delay 4.0;

            Put_Line ("[K" & Id & "] Dostarczono towar, kukiriniarz ma wolne");

         or
            accept Finish;
            Is_End := True;
         end select;
      end loop;

      Put_Line ("[K" & Id & "] Koniec pracy kukiriniarza");
   end Kid;
end Kukiriniarz;