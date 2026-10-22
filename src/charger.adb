with Ada.Text_IO;
use Ada.Text_IO;

package body Charger is
   task body Charging is
   begin
      loop
         select
            accept Start_Charging (Kid_Name : String) do
               Put_Line("Kukiriniarz " & Kid_Name & " rozpoczyna ladowanie.");
               delay 5.0;
               Put_Line("Kukiriniarz " & Kid_Name & " zakonczyl ladowanie.");
            end Start_Charging;
            or
               terminate;
         end select;
      end loop;
   end Charging;
end Charger;