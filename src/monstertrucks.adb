with Ada.Text_IO; use Ada.Text_IO;
with Delivery; 

package body MonsterTrucks is
   task body Truck is
      TruckCargo : Delivery.ShrimpsDelivery;
   begin
      accept Start(Id : Integer; Quantity : Integer) do
         TruckCargo.Id := Id;
         TruckCargo.Commodity := "Krewetki";
         TruckCargo.Quantity := Quantity;
      end Start;
      
      Put_Line("Mafia Krewetkowa: MonsterTruck " & TruckCargo.Id'Image & " wyruszyl w trase i zaraz sie zamelduje");
      
      Delivery.Unloading.DeliveryAcceptance(TruckCargo);
      
      Put_Line("Mafia Krewetkowa: MonsterTruck " & TruckCargo.Id'Image & " wraca pusty do bazy.");
      accept Departure;
   end Truck;
end MonsterTrucks;-- komentarz