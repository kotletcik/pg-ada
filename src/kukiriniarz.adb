with Logging;
with Warehouse;

package body Kukiriniarz is
   -- A worker waits for transport requests or for the end-of-shift entry.
   task body Kid is
      Is_End : Boolean := False;
   begin
      while not Is_End loop
         select
            accept Transport (ShrimpType : Character; Quantity : Integer) do
               Logging.Put_Line ("[K" & Id'Image & "] Otrzymano zadanie transportu");
               Logging.Put_Line ("[K" & Id'Image & "] Jedzie do magazynu...");
               delay 4.0;
            
               Warehouse.Storage.Accept_Delivery (ShrimpType, Quantity);
               Logging.Put_Line ("[K" & Id'Image & "] Dostarczono towar, kukiriniarz ma wolne");
            end Transport;
         or
            accept Finish;
            Is_End := True;
         end select;
      end loop;

      Logging.Put_Line ("[K" & Id'Image & "] Koniec pracy kukiriniarza");
   end Kid;
end Kukiriniarz;