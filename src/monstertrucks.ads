with Unloading_Point;

-- to jest po prostu deklaracja naszych monsterturkcow
package MonsterTrucks is
   type Truck_State is (W_Bazie, W_Drodze, W_Kolejce, Rozladunek, Powrot);
   type Truck_Array is array (1 .. 10) of Truck_State;
   subtype Truck_Index is Integer range 1 .. 10;
   type Done_Array is array (Truck_Index) of Boolean;

   protected Tracker is
      procedure Update (Id : Integer; State : Truck_State);
      procedure Get_States (States : out Truck_Array);
   private
      Stan_Ciezarowek : Truck_Array := (others => W_Bazie);
   end Tracker;

   protected Dispatcher is
      entry Wait_For_Unload (Truck_Index);
      procedure Signal_Done (Id : Truck_Index);
   private
      Is_Done : Done_Array := (others => False);
   end Dispatcher;
   
   task type Truck is
      entry Start(Id : Integer; Quantity : Integer; Travel_Time : Integer; Shrimp_Name : Unloading_Point.Shrimp_Name; Priority : Boolean);
      entry Departure;
   end Truck;
end MonsterTrucks;