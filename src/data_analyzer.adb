with Monitoring_Centre;
with Kukiriniarz;
with MonsterTrucks;
with Warehouse;
with Unloading_Point;

package body Data_Analyzer is
   task body Monitor is
      Is_End : Boolean := False;
      -- stan kukiriniarzy
      G2_Free, G4_Free : Integer;
      G2_Busy, G4_Busy : Boolean;
      -- stan ciezarowek
      T_States : MonsterTrucks.Truck_Array;
      W_Drodze, W_Kolejce, Powrot, W_Bazie, Rozladunek : Integer;
      -- stan magazynu
      Tygrys, Zolt, Rozowe, Biale, W_Total, W_Max : Integer;
      Q_Priority, Q_Normal, Q_Served : Integer;

      -- funkcja pomocnicza do formatowania stanu kukiriniarzy
      function Format_Busy(Is_Busy : Boolean) return String is
      begin
         if Is_Busy then return "pracuje"; else return "wolny  "; end if;
      end Format_Busy;
      -- odswieza cala tabele wyswietlania wszystkie stany i takie tam, te na dole ekranu
      procedure Refresh_Data is
      begin
         Kukiriniarz.Tracker.Get_State(Kukiriniarz.Skiba_Kukiriniarz, G2_Free, G2_Busy);
         Kukiriniarz.Tracker.Get_State(Kukiriniarz.Maniek_Kukiriniarz, G4_Free, G4_Busy);

         MonsterTrucks.Tracker.Get_States(T_States);
         W_Drodze := 0; W_Kolejce := 0; Powrot := 0; W_Bazie := 0; Rozladunek := 0;
         for I in T_States'Range loop
            case T_States(I) is
               when MonsterTrucks.W_Bazie   => W_Bazie := W_Bazie + 1;
               when MonsterTrucks.W_Drodze  => W_Drodze := W_Drodze + 1;
               when MonsterTrucks.W_Kolejce => W_Kolejce := W_Kolejce + 1;
               when MonsterTrucks.Powrot    => Powrot := Powrot + 1;
               when MonsterTrucks.Rozladunek => Rozladunek := Rozladunek + 1;
            end case;
         end loop;
         
         Warehouse.Storage.Get_State(Tygrys, Zolt, Rozowe, Biale, W_Total, W_Max);
         Unloading_Point.Queue.Get_Stats(Q_Priority, Q_Normal, Q_Served);
         
         Monitoring_Centre.Screen.Update_Monitor(22, "Kolejka oczekujacych : Priorytet: " & Q_Priority'Image & " | Zwykle: " & Q_Normal'Image);
         Monitoring_Centre.Screen.Update_Monitor(23, "Odprawione pojazdy   : " & Q_Served'Image);
         Monitoring_Centre.Screen.Update_Monitor(24, "Flota ciezarowek     : " & W_Drodze'Image & " w drodze | " & W_Kolejce'Image & " w kolejce | Rozladunek: " & Rozladunek'Image & " | Wraca: " & Powrot'Image & " | W bazie: " & W_Bazie'Image);
         Monitoring_Centre.Screen.Update_Monitor(25, "Kukiriniarz Skiba    : " & Format_Busy(G2_Busy) & " | Bateria: " & G2_Free'Image & "%");
         Monitoring_Centre.Screen.Update_Monitor(26, "Kukiriniarz Maniek   : " & Format_Busy(G4_Busy) & " | Bateria: " & G4_Free'Image & "%");
         Monitoring_Centre.Screen.Update_Monitor(27, "Magazyn (" & W_Total'Image & "/" & W_Max'Image & ")    : Tygrysie:" & Tygrys'Image & " | Zolte:" & Zolt'Image & " | Rozowe:" & Rozowe'Image & " | Biale:" & Biale'Image);
         Monitoring_Centre.Screen.Update_Monitor(28, "");
      end Refresh_Data;

      -- na okraglo uzywa refresha, po to by tabela sie akttualizowal
      begin
         while not Is_End loop
            select
               accept Stop do
                  Is_End := True;
               end Stop;
            or
               delay 1.0; 
               Refresh_Data;
            end select;
         end loop;
         
      -- ostatnie odswiezanie, by miala stan ostateczny magazynu
      Refresh_Data;
   end Monitor;
end Data_Analyzer;