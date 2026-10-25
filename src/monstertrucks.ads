with Unloading_Point;

package MonsterTrucks is
   type Truck_State is (W_Bazie, W_Drodze, W_Kolejce, Rozladunek, Powrot);
   type Truck_Array is array (1 .. 10) of Truck_State;
   subtype Truck_Index is Integer range 1 .. 10;

   protected Tracker is
      procedure Update (Id : Integer; State : Truck_State);
      procedure Get_States (States : out Truck_Array);
   private
      Stan_Ciezarowek : Truck_Array := (others => W_Bazie);
   end Tracker;

   task type Truck is
      entry Start(Id : Integer; Quantity : Integer; Travel_Time : Integer; Shrimp_Name : Unloading_Point.Shrimp_Name; Priority : Boolean);
   end Truck;
end MonsterTrucks;