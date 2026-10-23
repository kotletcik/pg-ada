with Ada.Text_IO;
use Ada.Text_IO;
with Warehouse;
with Charger;

package body Kukiriniarz is
   task body Kid is
      Is_End : Boolean := False;

      Batery_Level : Integer := 100;
      Level_Needed : constant Integer := 40; -- do uzgodnienia ile zużywa się energii na transport
   begin
      while not Is_End loop
         select
            accept Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer) do
               Put_Line ("[K" & Id'Image & "] Otrzymano zadanie transportu");

               Put_Line ("[K" & Id'Image & "] Jedzie do magazynu...");
               delay 4.0;
            
               Warehouse.Storage.Accept_Delivery (Shrimp_Type, Quantity);

               Batery_Level := Batery_Level - Level_Needed;
               Put_Line ("[K" & Id'Image & "] Poziom baterii: " & Batery_Level'Image);

               --  Jeśli poziom baterii jest niski, to kukiriniarz jedzie do stacji ladowania
               if Batery_Level < Level_Needed then
                  Put_Line ("[K" & Id'Image & "] Poziom baterii niski, jade do stacji ladowania...");
                  Charger.Charging.Start_Charging (Id'Image);
                  Batery_Level := 100;
                  Put_Line ("[K" & Id'Image & "] Naladowany, poziom baterii: " & Batery_Level'Image);
               end if;


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