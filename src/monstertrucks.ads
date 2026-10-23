with Unloading_Point;

-- to jest po prostu deklaracja naszych monsterturkcow
package MonsterTrucks is
   task type Truck is
      entry Start(Id : Integer; Quantity : Integer; Travel_Time : Integer; Shrimp_Name : Unloading_Point.Shrimp_Name; Priority : Boolean);
      entry Departure;
   end Truck;
end MonsterTrucks;