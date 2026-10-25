with Monitoring_Centre;
with Kukiriniarz;
with MonsterTrucks;
with Warehouse;
with Unloading_Point;

package body Data_Analyzer is
   task body Monitor is
      Is_End : Boolean := False;
      
      G2_Bat, G4_Bat : Integer;
      G2_Busy, G4_Busy : Boolean;
      
      T_States : MonsterTrucks.Truck_Array;
      W_D, W_K, P_W, W_B : Integer;

      W_Tygrys, W_Zolt, W_Roz, W_Bial, W_Total, W_Max : Integer;
      Q_Priority, Q_Normal, Q_Served : Integer;

      function Format_Busy(Is_Busy : Boolean) return String is
      begin
         if Is_Busy then return "pracuje"; else return "wolny  "; end if;
      end Format_Busy;
   begin
      while not Is_End loop
         select
            accept Stop do
               Is_End := True;
            end Stop;
         or
            delay 1.0; 
            
            -- Pobranie danych z przygotowanego wcześniej Trackera
            Kukiriniarz.Tracker.Get_State(Kukiriniarz.Skiba_Kukiriniarz, G2_Bat, G2_Busy);
            Kukiriniarz.Tracker.Get_State(Kukiriniarz.Maniek_Kukiriniarz, G4_Bat, G4_Busy);
            
            MonsterTrucks.Tracker.Get_States(T_States);
            
            W_D := 0; W_K := 0; P_W := 0; W_B := 0;
            for I in T_States'Range loop
               case T_States(I) is
                  when MonsterTrucks.W_Bazie   => W_B := W_B + 1;
                  when MonsterTrucks.W_Drodze  => W_D := W_D + 1;
                  when MonsterTrucks.W_Kolejce => W_K := W_K + 1;
                  when MonsterTrucks.Powrot    => P_W := P_W + 1;
               end case;
            end loop;

            Warehouse.Storage.Get_State(W_Tygrys, W_Zolt, W_Roz, W_Bial, W_Total, W_Max);
            Unloading_Point.Queue.Get_Stats(Q_Priority, Q_Normal, Q_Served);

            -- Wypisanie statystyk w stałych wierszach na dole ekranu
            Monitoring_Centre.Screen.Update_Monitor(22, "Kolejka oczekujacych : Priorytet: " & Q_Priority'Image & " | Zwykle: " & Q_Normal'Image);
            Monitoring_Centre.Screen.Update_Monitor(23, "Odprawione pojazdy   : " & Q_Served'Image);
            Monitoring_Centre.Screen.Update_Monitor(24, "Flota ciezarowek     : " & W_D'Image & " w drodze | " & W_K'Image & " w kolejce | " & P_W'Image & " wraca | " & W_B'Image & " w bazie");
            Monitoring_Centre.Screen.Update_Monitor(25, "Kukiriniarz Skiba    : " & Format_Busy(G2_Busy) & " | Bateria: " & G2_Bat'Image & "%");
            Monitoring_Centre.Screen.Update_Monitor(26, "Kukiriniarz Maniek   : " & Format_Busy(G4_Busy) & " | Bateria: " & G4_Bat'Image & "%");
            Monitoring_Centre.Screen.Update_Monitor(27, "Magazyn (" & W_Total'Image & "/" & W_Max'Image & ")    : Tygrysie:" & W_Tygrys'Image & " | Zolte:" & W_Zolt'Image & " | Rozowe:  " & W_Roz'Image    & " | Biale:" & W_Bial'Image);
         end select;
      end loop;
   end Monitor;
end Data_Analyzer;