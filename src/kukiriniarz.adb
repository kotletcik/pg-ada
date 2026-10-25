with Monitoring_Centre;
with Warehouse;
with Charger;

package body Kukiriniarz is
   Kukiriniarz_G2 : Kid (Skiba_Kukiriniarz);
   Kukiriniarz_G4 : Kid (Maniek_Kukiriniarz);
   Next_Kukiriniarz : Kukiriniarz_Name := Skiba_Kukiriniarz;

   protected body Tracker is
      -- a to po prostu na poczatku i koncu transportu pobiera baterie kukiriniarza
      procedure Update (Id : Kukiriniarz_Name; Battery : Integer; Busy : Boolean) is
      begin
         Baterie(Id) := Battery;
         Zajetosc(Id) := Busy;
      end Update;

      -- to po prostu pobiera statystyki do tabeli
      procedure Get_State (Id : Kukiriniarz_Name; Battery : out Integer; Busy : out Boolean) is
      begin
         Battery := Baterie(Id);
         Busy := Zajetosc(Id);
      end Get_State;
   end Tracker;



   procedure Assign_Transport
     (Shrimp_Type : Unloading_Point.Shrimp_Name;
      Quantity : Integer) is
   begin
      if Next_Kukiriniarz = Skiba_Kukiriniarz then
         Kukiriniarz_G2.Transport (Shrimp_Type, Quantity);
         Next_Kukiriniarz := Maniek_Kukiriniarz;
      else
         Kukiriniarz_G4.Transport (Shrimp_Type, Quantity);
         Next_Kukiriniarz := Skiba_Kukiriniarz;
      end if;
   end Assign_Transport;

   procedure Finish_All is
   begin
      Kukiriniarz_G2.Finish;
      Kukiriniarz_G4.Finish;
   end Finish_All;

   task body Kid is
      Is_End : Boolean := False;
      Batery_Level : Integer := 100;
      Level_Needed : constant Integer := 40; -- do uzgodnienia ile zużywa się energii na transport
   begin
      Tracker.Update(Id, Batery_Level, False);
      while not Is_End loop
         select
            accept Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer) do
               Tracker.Update(Id, Batery_Level, True);
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Otrzymano zadanie transportu");

               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Jedzie do magazynu...");
               delay 4.0;
            
               Warehouse.Storage.Accept_Delivery (Shrimp_Type, Quantity);

               Batery_Level := Batery_Level - Level_Needed;
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Poziom baterii: " & Batery_Level'Image);

               --  Jeśli poziom baterii jest niski, to kukiriniarz jedzie do stacji ladowania
               if Batery_Level < Level_Needed then
               Monitoring_Centre.Screen.Log("[K" & Id'Image & "] Poziom baterii niski, jade do stacji ladowania...");
               
               -- Zastosowanie instrukcji select ... else do asynchronicznego sprawdzenia zajętości
               select
                  Charger.Charging.Start_Charging (Id'Image);
               else
                  Monitoring_Centre.Screen.Log("[K" & Id'Image & "] Ladowarka zajeta, grzecznie czekam w kolejce...");
                  -- Wywołanie blokujące, zmuszające robota do faktycznego poczekania
                  Charger.Charging.Start_Charging (Id'Image);
               end select;

               Batery_Level := 100;
               Monitoring_Centre.Screen.Log("[K" & Id'Image & "] Naladowany, poziom baterii: " & Batery_Level'Image);
               end if;


               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Dostarczono towar, kukiriniarz ma wolne");
               Tracker.Update(Id, Batery_Level, False);
            end Transport;
         or
            accept Finish;
            Is_End := True;
         end select;
      end loop;

      Monitoring_Centre.Screen.Log("[" & Id'Image & "] Koniec pracy kukiriniarza");
   end Kid;
end Kukiriniarz;