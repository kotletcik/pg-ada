with Monitoring_Centre;
with Kukiriniarz;
with MonsterTrucks;

package body Unloading_Point is
   protected body Queue is
      procedure Add_Waiting (Priority : Boolean) is
      begin
         if Priority then
            Priority_Count := Priority_Count + 1;
         else
            Normal_Count := Normal_Count + 1;
         end if;
      end Add_Waiting;

      procedure Remove_Waiting (Priority : Boolean) is
      begin
         if Priority and then Priority_Count > 0 then
            Priority_Count := Priority_Count - 1;
         elsif not Priority and then Normal_Count > 0 then
            Normal_Count := Normal_Count - 1;
         end if;
      end Remove_Waiting;

      procedure Record_Served is
      begin
         Total_Served := Total_Served + 1;
      end Record_Served;

      procedure Get_Stats (Priority_Wait, Normal_Wait, Served : out Integer) is
      begin
         Priority_Wait := Priority_Count;
         Normal_Wait := Normal_Count;
         Served := Total_Served;
      end Get_Stats;
   end Queue;

   task body Unloading is
      Current_Delivery : ShrimpsDelivery;
   begin
      loop
         select
            accept Unload_Priority (Delivery : ShrimpsDelivery) do
               Current_Delivery := Delivery;
               MonsterTrucks.Tracker.Update(Delivery.Id, MonsterTrucks.Rozladunek);
               Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Priorytetowy rozladunek Monstertrucka" & Delivery.Id'Image);
               delay Duration(Float(Delivery.Quantity) * 0.1);
               Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Zakonczono rozladunek Monstertrucka" & Delivery.Id'Image);
            end Unload_Priority;
            Queue.Record_Served;
            Kukiriniarz.Assign_Transport(Current_Delivery.Commodity, Current_Delivery.Quantity);

         or
            -- Obsluga dostaw zwyklych tylko wtedy, gdy kolejka priorytetowa jest pusta
            when Unload_Priority'Count = 0 =>
               accept Unload_Normal (Delivery : ShrimpsDelivery) do
                  Current_Delivery := Delivery;
                  MonsterTrucks.Tracker.Update(Delivery.Id, MonsterTrucks.Rozladunek);
                  Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Zwykly rozladunek Monstertrucka" & Delivery.Id'Image);
                  delay Duration(Float(Delivery.Quantity) * 0.1);
                  Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Zakonczono rozladunek Monstertrucka" & Delivery.Id'Image);
               end Unload_Normal;
               Queue.Record_Served;
               Kukiriniarz.Assign_Transport(Current_Delivery.Commodity, Current_Delivery.Quantity);

         or
            accept Close;
            exit;
         end select;
      end loop;

      accept Wait_Until_Done;
   end Unloading;
end Unloading_Point;