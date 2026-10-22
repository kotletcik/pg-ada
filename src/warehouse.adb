with Ada.Text_IO; 
use Ada.Text_IO;

package body Warehouse is

   task body Storage is
      -- Stan różnych rodzajów towarów
      Goods_A : Integer := 0;
      Goods_B : Integer := 0;
      Goods_C : Integer := 0;

      -- Zmienna pomocnicza
      Max_Capacity : constant Integer := 100;
   begin
      loop-- komentarz
         select
            -- Akceptujemy dostawę TYLKO, gdy jest miejsce w magazynie
            when (Goods_A + Goods_B + Goods_C) < Max_Capacity =>
               accept Accept_Delivery (GoodType : Character; Quantity : Integer) do
                  -- Zwiekszamy ilość towaru w magazynie w zależności od typu
                  if GoodType = 'A' then
                     Goods_A := Goods_A + Quantity;
                  elsif GoodType = 'B' then
                     Goods_B := Goods_B + Quantity;
                  elsif GoodType = 'C' then
                     Goods_C := Goods_C + Quantity;
                  end if;
                  Put_Line ("[M] Przyjeto dostawe: " & Quantity'Image & " sztuk towaru typu " & GoodType'Image);
               end Accept_Delivery;

         or
            -- Wyświetlamy stan magazynu
            accept Check_Stock do
               Put_Line ("[M] Stan magazynu: A: " & Goods_A'Image & ", B: " & Goods_B'Image & ", C: " & Goods_C'Image);
            end Check_Stock;
         or
            terminate;
         end select;
      end loop;
   end Storage;

end Warehouse;