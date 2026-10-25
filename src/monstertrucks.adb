with Monitoring_Centre;
with Unloading_Point; 

package body MonsterTrucks is
   protected body Tracker is
      procedure Update (Id : Integer; State : Truck_State) is
      begin
         Stan_Ciezarowek(Id) := State;
      end Update;

      procedure Get_States (States : out Truck_Array) is
      begin
         States := Stan_Ciezarowek;
      end Get_States;
   end Tracker;

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
      Tracker.Update(TruckCargo.Id, W_Drodze);
      delay Duration(Delay_Time);
      Tracker.Update(TruckCargo.Id, W_Kolejce);
      Monitoring_Centre.Screen.Log("MonsterTruck nr" & TruckCargo.Id'Image & " z " & TruckCargo.Commodity'Image & " dojechal pod pod rozladunek i czeka w kolejce");
      Unloading_Point.Queue.Add(TruckCargo);
      Tracker.Update(TruckCargo.Id, Powrot);
      Monitoring_Centre.Screen.Log("MonsterTruck nr" & TruckCargo.Id'Image & " wraca pusty do bazy");
      accept Departure;
      Tracker.Update(TruckCargo.Id, W_Bazie);
   end Truck;
end MonsterTrucks;