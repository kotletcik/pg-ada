with Ada.Text_IO; use Ada.Text_IO;
with Delivery; 

package body MonsterTrucks is
   task body Truck is
      Ladunek : Delivery.ShrimpsDelivery;
   begin
      accept Start(Id : Integer; Ilosc : Integer) do
         Ladunek.Id := Id;
         Ladunek.Towar := "Krewetki";
         Ladunek.Ilosc := Ilosc;
      end Start;
      
      Put_Line("Mafia Krewetkowa: MonsterTruck " & Ladunek.Id'Image & " wyruszyl w trasce i zaraz sie zamelduje");
      
      Delivery.Unloading.Przyjecie_dostawy(Ladunek);
      
      Put_Line("Mafia Krewetkowa: MonsterTruck " & Ladunek.Id'Image & " wraca puste do bazy.");
      accept Departure;
   end Truck;
end MonsterTrucks;