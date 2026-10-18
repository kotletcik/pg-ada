package MonsterTrucks is
   task type Truck is
      entry Start(Id : Integer; Ilosc : Integer);
      entry Departure;
   end Truck;
end MonsterTrucks;