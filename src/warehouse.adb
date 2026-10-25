with Monitoring_Centre;
with Unloading_Point;

package body Warehouse is

   task body Storage is
      Max_Capacity : constant Integer := 1000;

      Shrimp_Stock : array (Unloading_Point.Shrimp_Name) of Integer := (others => 0);
      Total_Shrimps : Integer := 0;
   begin
      loop
         select
            -- Akceptujemy dostawę TYLKO, gdy jest miejsce
            when Total_Shrimps < Max_Capacity =>
               accept Accept_Delivery (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer) do
                  Shrimp_Stock(Shrimp_Type) := Shrimp_Stock(Shrimp_Type) + Quantity;
                  Total_Shrimps := Total_Shrimps + Quantity;
                  Monitoring_Centre.Screen.Log("[M] Przyjeto dostawe: " & Quantity'Image & " sztuk, rodzaj: " & Shrimp_Type'Image);
               end Accept_Delivery;

         or
            -- Wyświetlamy stan magazynu
            accept Check_Stock do
               Monitoring_Centre.Screen.Log("[M] --- STAN MAGAZYNU KREWETEK ---");
               for Krewetka in Unloading_Point.Shrimp_Name loop
                  Monitoring_Centre.Screen.Log("[M] " & Krewetka'Image & ": " & Shrimp_Stock(Krewetka)'Image);
               end loop;
               Monitoring_Centre.Screen.Log("[M] Calkowite zapelnienie: " & Total_Shrimps'Image & " / " & Max_Capacity'Image);
               Monitoring_Centre.Screen.Log("[M] --------------------------------");
            end Check_Stock;
         or
            accept Get_State (Tygrys, Zolt, Roz, Bial : out Integer; Total, Max : out Integer) do
               Tygrys := Shrimp_Stock(Unloading_Point.Krewetki_Tygyysie);
               Zolt   := Shrimp_Stock(Unloading_Point.Krewetki_Zolte);
               Roz    := Shrimp_Stock(Unloading_Point.Krewetki_Rozowe);
               Bial   := Shrimp_Stock(Unloading_Point.Krewetki_Biale);
               Total  := Total_Shrimps;
               Max    := Max_Capacity;
            end Get_State;
         or
            terminate;
         end select;
      end loop;
   end Storage;

end Warehouse;