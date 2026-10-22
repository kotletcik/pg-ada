with Ada.Text_IO;
use Ada.Text_IO;

package body Unloading_Point is
   task body Unloading is
      End_Of_Shift : Boolean := False;
   begin
      while not End_Of_Shift loop
         select
            -- to jest nasz glowny punkt rozladunkowy
            -- tutaj zaczynamy rozladunek, kazda ciezarowka 
            -- jest rozladowywana odpowiednio dlugow w zaleznosci od ilosci krewetek
            accept DeliveryAcceptance (ShrimpsTruck : ShrimpsDelivery) do
               Put_Line("Pracownik: Rozpoczynamy rozladunek Monstertrucka" & ShrimpsTruck.Id'Image);
               Put_Line("Pracownik: Aktualnie w kolejce czeka " & DeliveryAcceptance'Count'Image & " innych aut");
               -- tutaj wykazalem sie sprytem Wiktorii               
               delay Duration(Float(ShrimpsTruck.Quantity) * 0.2); 
               Put_Line("Pracownik: Zakonczylismy rozladunek Monstertrucka" & ShrimpsTruck.Id'Image);
            end DeliveryAcceptance;
            
            if DeliveryAcceptance'Count = 0 then
               Put_Line("Pracownik: Skonczylismy, nie ma juz aut w kolejce");
            end if;
         or
            accept Finish;
            End_Of_Shift := True;
         end select;   
      end loop;
   end Unloading;
end Unloading_Point;