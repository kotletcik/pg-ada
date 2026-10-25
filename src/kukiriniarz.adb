with Monitoring_Centre;
with Warehouse;
with Charger;

package body Kukiriniarz is
   Kukiriniarz_G2 : Kid (Skiba_Kukiriniarz);
   Kukiriniarz_G4 : Kid (Maniek_Kukiriniarz);
   Next_Kukiriniarz : Kukiriniarz_Name := Skiba_Kukiriniarz;

   protected body Tracker is
      procedure Update (Id : Kukiriniarz_Name; Battery : Integer; Busy : Boolean) is
      begin
         Baterie(Id) := Battery;
         Zajetosc(Id) := Busy;
      end Update;

      procedure Get_State (Id : Kukiriniarz_Name; Battery : out Integer; Busy : out Boolean) is
      begin
         Battery := Baterie(Id);
         Busy := Zajetosc(Id);
      end Get_State;
   end Tracker;

   procedure Assign_Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer) is
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
      Level_Needed : constant Integer := 40; 
      
      -- Zmienne lokalne do zapamietania ladunku
      My_Shrimp : Unloading_Point.Shrimp_Name;
      My_Quantity : Integer;
   begin
      Tracker.Update(Id, Batery_Level, False);
      while not Is_End loop
         select
            accept Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer) do
               Tracker.Update(Id, Batery_Level, True);
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Otrzymano zadanie transportu");
               My_Shrimp := Shrimp_Type;
               My_Quantity := Quantity;
            end Transport;
            
            Monitoring_Centre.Screen.Log("[" & Id'Image & "] Jedzie do magazynu...");
            delay 4.0;
         
            Warehouse.Storage.Accept_Delivery (My_Shrimp, My_Quantity);

            Batery_Level := Batery_Level - Level_Needed;
            Monitoring_Centre.Screen.Log("[" & Id'Image & "] Poziom baterii: " & Batery_Level'Image);

            if Batery_Level < Level_Needed then
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Poziom baterii niski, jade do stacji ladowania...");
               
               select
                  Charger.Charging.Start_Charging (Id'Image);
               else
                  Monitoring_Centre.Screen.Log("[" & Id'Image & "] Ladowarka zajeta, grzecznie czekam w kolejce...");
                  Charger.Charging.Start_Charging (Id'Image);
               end select;

               Batery_Level := 100;
               Monitoring_Centre.Screen.Log("[" & Id'Image & "] Naladowany, poziom baterii: " & Batery_Level'Image);
            end if;

            Monitoring_Centre.Screen.Log("[" & Id'Image & "] Dostarczono towar, kukiriniarz ma wolne");
            Tracker.Update(Id, Batery_Level, False);
         or
            accept Finish;
            Is_End := True;
         end select;
      end loop;

      Monitoring_Centre.Screen.Log("[" & Id'Image & "] Koniec pracy kukiriniarza");
   end Kid;
end Kukiriniarz;