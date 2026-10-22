package MonsterTrucks is
   task type Truck is
      entry Start(Id : Integer; Quantity : Integer);
      entry Departure;
   end Truck;
end MonsterTrucks;-- komentarz