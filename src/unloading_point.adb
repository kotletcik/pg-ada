with Monitoring_Centre;
with Kukiriniarz;

package body Unloading_Point is

   protected body Stats_Tracker is

      -- aktualna liczba dostaw w obu kolejkach
      procedure Print_State is
      begin
         Monitoring_Centre.Screen.Log("Kolejka priorytetowa: " & Integer'Image(Priority_Count)
            & " | kolejka zwykla: " & Integer'Image(Normal_Count));
      end Print_State;

      procedure Join_Queue (Priority : Boolean) is
      begin
         if Priority then
            Priority_Count := Priority_Count + 1;
         else
            Normal_Count := Normal_Count + 1;
         end if;
         Print_State;
      end Join_Queue;

      procedure Leave_Queue (Priority : Boolean) is
      begin
         if Priority and Priority_Count > 0 then
            Priority_Count := Priority_Count - 1;
         elsif not Priority and Normal_Count > 0 then
            Normal_Count := Normal_Count - 1;
         end if;
      end Leave_Queue;

      procedure Get_Stats (Priority_Wait, Normal_Wait, Served : out Integer) is
      begin
         Priority_Wait := Priority_Count;
         Normal_Wait := Normal_Count;
         Served := Total_Served;
      end Get_Stats;

      procedure Record_Served is
      begin
         Total_Served := Total_Served + 1;
      end Record_Served;

   end Stats_Tracker;

   task body Unloading is
      Done : Boolean := False;
   begin
      -- obsluga dostaw do momentu zakonczenia symulacji
      while not Done loop
         select
            accept Unload_Priority (Delivery : in ShrimpsDelivery) do
               -- rozpoczecie obslugi dostawy priorytetowej
               Queue.Leave_Queue(True);
               Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Rozpoczynamy rozladunek Monstertrucka"
                  & Delivery.Id'Image);
               Queue.Print_State;
               -- Czas rozladunku zalezy od liczby krewetek.
               delay Duration(Float(Delivery.Quantity) * 0.1);
               Queue.Record_Served;
               Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Zakonczylismy rozladunek Monstertrucka"
                  & Delivery.Id'Image);
               Kukiriniarz.Assign_Transport(Delivery.Commodity, Delivery.Quantity);
            end Unload_Priority;
         or
            when Unload_Priority'Count = 0 =>
               accept Unload_Normal (Delivery : in ShrimpsDelivery) do
                  -- obsluga dostawy zwyklej, gdy brak priorytetow
                  Queue.Leave_Queue(False);
                  Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Rozpoczynamy rozladunek Monstertrucka"
                     & Delivery.Id'Image);
                  Queue.Print_State;
                  -- Czas rozladunku zalezy od liczby krewetek.
                  delay Duration(Float(Delivery.Quantity) * 0.1);
                  Queue.Record_Served;
                  Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Zakonczylismy rozladunek Monstertrucka"
                     & Delivery.Id'Image);
                  Kukiriniarz.Assign_Transport(Delivery.Commodity, Delivery.Quantity);
               end Unload_Normal;
         or
            when Unload_Priority'Count = 0 and Unload_Normal'Count = 0 =>
               -- zakonczenie pracy po obsluzeniu wszystkich dostaw
               accept Wait_Until_Done;
               Done := True;
         end select;
      end loop;
   end Unloading;

end Unloading_Point;