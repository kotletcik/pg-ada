with Monitoring_Centre;
with Unloading_Point; 

package body MonsterTrucks is
   protected body Tracker is
      -- to po prostu updatuje czy ciezarowka jedzei czy stoi
      procedure Update (Id : Integer; State : Truck_State) is
      begin
         Stan_Ciezarowek(Id) := State;
      end Update;
      -- a to pobiera wszystkie stany, ja zaraz zaczne miec stany
      procedure Get_States (States : out Truck_Array) is
      begin
         States := Stan_Ciezarowek;
      end Get_States;
   end Tracker;

   -- to po prostu symuluje czekanie na rozladowanie
   protected body Dispatcher is
      entry Wait_For_Unload (for I in Truck_Index) when Is_Done(I) is
      begin
         Is_Done(I) := False; 
      end Wait_For_Unload;

      procedure Signal_Done (Id : Truck_Index) is
      begin
         Is_Done(Id) := True;
      end Signal_Done;
   end Dispatcher;

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
      Monitoring_Centre.Screen.Log("[Centrala] MonsterTruck nr" & TruckCargo.Id'Image & " z " & TruckCargo.Commodity'Image & " w ilosci" & TruckCargo.Quantity'Image & " dojechal pod rozladunek i czeka w kolejce");
      Unloading_Point.Queue.Add(TruckCargo);
      Dispatcher.Wait_For_Unload(TruckCargo.Id);
      Tracker.Update(TruckCargo.Id, Powrot);
      Monitoring_Centre.Screen.Log("[Centrala] MonsterTruck nr" & TruckCargo.Id'Image & " wraca pusty do bazy");
      delay Duration(Delay_Time);
      accept Departure;
      Tracker.Update(TruckCargo.Id, W_Bazie);
   end Truck;
end MonsterTrucks;