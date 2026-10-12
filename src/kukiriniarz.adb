task body Kukiriniarz is
   End : Boolean := False;
   ShrimpType : Character;
   Quantity : Integer;
begin
   while not End loop
      select
         accept Transport (ShrimpType : Character; Quantity : Integer) do
            ShrimpType := ShrimpType;
            Quantity := Quantity;
            Put_Line ("[K" & Integer'Image (Id) & "] Otrzymano zadanie transportu");
         end Transport;

         Put_Line ("[K" & Integer'Image (Id) & "] Jedzie do magazynu...");
         delay 2.0;

         Magazyn.Przyjmij (Ladunek_Towar, Ladunek_Ilosc);
         Put_Line ("[K" & Integer'Image (Id) & "] Dostarczono towar, kukiriniarz jest  wolny");

      or
         accept End;
         End := True;
      end select;
   end loop;

   Put_Line ("[K" & Integer'Image (Id) & "] Koniec pracy kukiriniarza");
end Kukiriniarz;