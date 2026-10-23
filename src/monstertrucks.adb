with Ada.Text_IO; use Ada.Text_IO;
with Unloading_Point; 

package body MonsterTrucks is
   task body Truck is
      TruckCargo : Unloading_Point.ShrimpsDelivery;
      Delay_Time : Integer;
   begin
      -- to jest po prostu stworzenie ciezarowki
      accept Start(Id : Integer; Quantity : Integer; Travel_Time : Integer; Shrimp_Name : Unloading_Point.Shrimp_Name; Priority : Boolean) do
         TruckCargo.Id := Id;
         TruckCargo.Commodity := Shrimp_Name;
         TruckCargo.Quantity := Quantity;
         TruckCargo.Priority := Priority;
         Delay_Time := Travel_Time;
      end Start; 
      -- tutaj sie taski spotykaja, jezeli jakas ciezarowka
      -- podjechala pod rozladunek i zadna inna nie jest rozladowywana
      -- to zaczyna sie jej rozladunek, a tak to czeka na zakonczenie rozladunku innej ciezarowki
      delay Duration(Delay_Time);
      Put_Line("MonsterTruck nr" & TruckCargo.Id'Image & " z " & TruckCargo.Commodity'Image & " dojechal pod pod rozladunek i czeka w kolejce");
      Unloading_Point.Queue.Add(TruckCargo);
      Put_Line("MonsterTruck nr" & TruckCargo.Id'Image & " wraca pusty do bazy");
      accept Departure;
   end Truck;
end MonsterTrucks;