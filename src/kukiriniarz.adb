with Monitoring_Centre;
with Warehouse;
with Charger;

package body Kukiriniarz is

   -- utworzenie dwoch robotow obslugujacych transport
   Kukiriniarz_G2 : Kid (Skiba_Kukiriniarz);
   Kukiriniarz_G4 : Kid (Maniek_Kukiriniarz);
   Next_Kukiriniarz : Kukiriniarz_Name := Skiba_Kukiriniarz;

   protected body Tracker is
      procedure Update (Id : Kukiriniarz_Name; Battery : Integer; Busy : Boolean) is
      begin
         -- zapisanie najnowszego stanu robota
         Baterie(Id) := Battery;
         Zajetosc(Id) := Busy;
      end Update;

      procedure Get_State (Id : Kukiriniarz_Name; Battery : out Integer; Busy : out Boolean) is
      begin
         -- odczytanie stanu wybranego robota
         Battery := Baterie(Id);
         Busy := Zajetosc(Id);
      end Get_State;
   end Tracker;

   procedure Assign_Transport
     (Shrimp_Type : Unloading_Point.Shrimp_Name;
      Quantity : Integer) is
   begin
      -- proba przydzielenia zadania wolnemu robotowi
      select
         Kukiriniarz_G2.Transport (Shrimp_Type, Quantity);
      else
         select
            Kukiriniarz_G4.Transport (Shrimp_Type, Quantity);
         else
            if Next_Kukiriniarz = Skiba_Kukiriniarz then
               -- naprzemienny wybor robota, gdy oba sa zajete
               Kukiriniarz_G2.Transport (Shrimp_Type, Quantity);
               Next_Kukiriniarz := Maniek_Kukiriniarz;
            else
               Kukiriniarz_G4.Transport (Shrimp_Type, Quantity);
               Next_Kukiriniarz := Skiba_Kukiriniarz;
            end if;
         end select;
      end select;
   end Assign_Transport;

   procedure Finish_All is
   begin
      -- wyslanie sygnalu zakonczenia do obu robotow
      Kukiriniarz_G2.Finish;
      Kukiriniarz_G4.Finish;
   end Finish_All;

   task body Kid is
      Is_End : Boolean := False;
      Batery_Level : Integer := 100;
      Level_Needed : constant Integer := 40; -- do uzgodnienia ile zużywa się energii na transport
      Current_Shrimp : Unloading_Point.Shrimp_Name;
      Current_Quantity : Integer;
      Has_Job : Boolean := False;
   begin
      -- zgloszenie poczatkowego stanu robota
      Tracker.Update(Id, Batery_Level, False);

      while not Is_End loop
         select
            accept Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer) do
               -- przyjecie nowego zadania transportowego
               Current_Shrimp := Shrimp_Type;
               Current_Quantity := Quantity;
               Has_Job := True;
               Tracker.Update(Id, Batery_Level, True);
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Otrzymano zadanie transportu");
            end Transport;
         or
            accept Finish;
            Is_End := True;
         end select;

         if Has_Job then
            -- przejazd do magazynu i dostarczenie ladunku
            Monitoring_Centre.Screen.Log("[" & Id'Image & "] Jedzie do magazynu...");
            delay 4.0;
            
            Warehouse.Storage.Accept_Delivery (Current_Shrimp, Current_Quantity);
            Batery_Level := Batery_Level - Level_Needed;
            Monitoring_Centre.Screen.Log("[" & Id'Image & "] Poziom baterii: " & Batery_Level'Image);

            -- Jeśli poziom baterii jest niski, to kukiriniarz jedzie do stacji ladowania
            if Batery_Level < Level_Needed then
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Poziom baterii niski, jade do stacji ladowania...");
               
               -- Zastosowanie instrukcji select ... else do asynchronicznego sprawdzenia zajętości
               select
                  Charger.Charging.Start_Charging (Id'Image);
               else
                  Monitoring_Centre.Screen.Log("[" & Id'Image & "] Ladowarka zajeta, grzecznie czekam w kolejce...");
                  -- Wywołanie blokujące, zmuszające robota do faktycznego poczekania
                  Charger.Charging.Start_Charging (Id'Image);
               end select;

               Batery_Level := 100;
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Naladowany, poziom baterii: " & Batery_Level'Image);
            end if;

            -- oznaczenie zakonczenia zadania i zwolnienie robota
            Monitoring_Centre.Screen.Log("[" & Id'Image & "] Dostarczono towar, kukiriniarz ma wolne");
            Tracker.Update(Id, Batery_Level, False);
            Has_Job := False;
         end if;
      end loop;
      Monitoring_Centre.Screen.Log("[" & Id'Image & "] Koniec pracy kukiriniarza");
   end Kid;

end Kukiriniarz;