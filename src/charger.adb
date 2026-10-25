with Monitoring_Centre;

package body Charger is
   task body Charging is
   begin
      loop
         select
            accept Start_Charging (Kid_Name : String) do
               Monitoring_Centre.Screen.Log("[" & Kid_Name & "] rozpoczyna ladowanie.");
               delay 5.0;
               Monitoring_Centre.Screen.Log("[" & Kid_Name & "] zakonczyl ladowanie.");
            end Start_Charging;
            or
               terminate;
         end select;
      end loop;
   end Charging;
end Charger;