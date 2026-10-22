with Logging;

package body Kukiriniarz is
   -- Pracownik czeka na zadanie albo koniec zmiany.
   task body Kid is
      Is_End : Boolean := False;
   begin
      while not Is_End loop
         select
            accept Transport (ShrimpType : Character; Quantity : Integer) do
               Logging.Put_Line ("[K" & Id'Image & "] Otrzymano zadanie transportu");
            end Transport;

            Logging.Put_Line ("[K" & Id'Image & "] Jedzie do magazynu...");
            delay 4.0;

            Logging.Put_Line ("[K" & Id'Image & "] Dostarczono towar, kukiriniarz ma wolne");

         or
            accept Finish;
            Is_End := True;
         end select;
      end loop;

      Logging.Put_Line ("[K" & Id'Image & "] Koniec pracy kukiriniarza");
   end Kid;
end Kukiriniarz;