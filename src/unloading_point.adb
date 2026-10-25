with Monitoring_Centre;
with Kukiriniarz;
with MonsterTrucks;

package body Unloading_Point is
   --  kolejka  obsluguje dostawy przychodzace
   -- rownoczesnie z wielu taskow
   protected body Delivery_Queue is
      --  aktualna liczba dostaw w obu kolejkach
      procedure Print_State is
      begin
         Monitoring_Centre.Screen.Log("Kolejka priorytetowa: " & Integer'Image(Priority_Count)
            & " | kolejka zwykla: " & Integer'Image(Normal_Count));
      end Print_State;

      procedure Add (Delivery : ShrimpsDelivery) is
      begin
         -- Priorytet decyduje, do ktorej kolejki trafia dostawa
         if Delivery.Priority then
            Priority_Count := Priority_Count + 1;
            Priority_Deliveries(Priority_Count) := Delivery;
            Monitoring_Centre.Screen.Log("Przyjechalo zamowienie priorytetowe nr"
               & Delivery.Id'Image);
         else
            Normal_Count := Normal_Count + 1;
            Normal_Deliveries(Normal_Count) := Delivery;
            Monitoring_Centre.Screen.Log("Przyjechalo zwykle zamowienie nr"
               & Delivery.Id'Image);
         end if;
         Print_State;
      end Add;

      procedure Get_Stats (Priority_Wait, Normal_Wait, Served : out Integer) is
      begin
         Priority_Wait := Priority_Count;
         Normal_Wait := Normal_Count;
         Served := Total_Served;
      end Get_Stats;

      entry Take (Delivery : out ShrimpsDelivery;
                  Available : out Boolean)
         when Priority_Count > 0 or Normal_Count > 0 or Closed is
      begin
         -- Zawsze najpierw obslugujemy zamowienie priorytetowe
         if Priority_Count > 0 then
            Available := True;
            Delivery := Priority_Deliveries(1);
            -- Przesuwamy pozostale elementy
            for I in 1 .. Priority_Count - 1 loop
               Priority_Deliveries(I) := Priority_Deliveries(I + 1);
            end loop;
            Priority_Count := Priority_Count - 1;
         elsif Normal_Count > 0 then
            Available := True;
            Delivery := Normal_Deliveries(1);
            -- Jezeli nie ma priorytetow, pobieramy zwykle zamowienie
            for I in 1 .. Normal_Count - 1 loop
               Normal_Deliveries(I) := Normal_Deliveries(I + 1);
            end loop;
            Normal_Count := Normal_Count - 1;
         else
            Available := False;
         end if;
         if Available then
            Total_Served := Total_Served + 1;
         end if;
      end Take;

      procedure Close is
      begin
         -- Po zamknieciu nie przyjmujemy juz nowych dostaw.
         Closed := True;
      end Close;
   end Delivery_Queue;

   task body Unloading is
      Delivery : ShrimpsDelivery;
      Available : Boolean;
   begin
      -- Pracownik czeka na dostawy i konczy po zamknieciu pustej kolejki.
      loop
         Unloading_Point.Queue.Take(Delivery, Available);
         exit when not Available;

         -- Gdy dostawa jest dostepna, pobieramy ja zgodnie z priorytetem.
         Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Rozpoczynamy rozladunek Monstertrucka"
            & Delivery.Id'Image);
         Unloading_Point.Queue.Print_State;
         -- Czas rozladunku zalezy od liczby krewetek.
         delay Duration(Float(Delivery.Quantity) * 0.2);
         MonsterTrucks.Dispatcher.Signal_Done(Delivery.Id);
         Monitoring_Centre.Screen.Log("[Punkt rozladunkowy] Zakonczylismy rozladunek Monstertrucka"
            & Delivery.Id'Image);
         Kukiriniarz.Assign_Transport
           (Delivery.Commodity, Delivery.Quantity);
      end loop;

      accept Wait_Until_Done;
   end Unloading;
end Unloading_Point;