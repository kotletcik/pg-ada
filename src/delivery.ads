package Delivery is
   
   -- Dane dostawy krewetek.
   type ShrimpsDelivery is record
      Id    : Integer;
      Commodity : String(1 .. 8);
      Quantity : Integer;
   end record;
   -- Przyjecie dostawy i koniec zmiany.
   task Unloading is
      entry DeliveryAcceptance (ShrimpsTruck : ShrimpsDelivery);
      entry Finish;
   end Unloading;
end Delivery;-- komentarz