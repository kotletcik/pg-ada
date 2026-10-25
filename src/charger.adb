with Monitoring_Centre;

package body Charger is
   task body Charging is
   begin
      -- oczekiwanie na zlecenia ladowania
      loop
         select
            accept Start_Charging (Kid_Name : String) do
               -- rozpoczecie pracy ladowarki dla robota
               Monitoring_Centre.Screen.Log("[" & Kid_Name & "] rozpoczyna ladowanie.");
               delay 5.0;
               -- zakonczenie ladowania po ustalonym czasie
               Monitoring_Centre.Screen.Log("[" & Kid_Name & "] zakonczyl ladowanie.");
            end Start_Charging;
         or
            -- zakonczenie zadania, gdy nie ma juz pracy
            terminate;
         end select;
      end loop;
   end Charging;
end Charger;