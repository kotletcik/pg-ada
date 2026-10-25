with Unloading_Point;

-- to jest po prostu deklaracja naszych monsterturkcow
package MonsterTrucks is

   type Truck_State is (W_Bazie, W_Drodze, W_Kolejce, Powrot);
   type Truck_Array is array (1 .. 10) of Truck_State;

   protected Tracker is
      procedure Update (Id : Integer; State : Truck_State);
      procedure Get_States (States : out Truck_Array);
   private
      Stan_Ciezarowek : Truck_Array := (others => W_Bazie);
   end Tracker;

   task type Truck is
      entry Start(Id : Integer; Quantity : Integer; Travel_Time : Integer; Shrimp_Name : Unloading_Point.Shrimp_Name; Priority : Boolean);
      entry Departure;
   end Truck;

end MonsterTrucks;