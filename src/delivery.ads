package Delivery is
   
   -- Nasza dostawa krewetek
   type ShrimpsDelivery is record
      Id    : Integer;
      Commodity : String(1 .. 8);
      Quantity : Integer;
   end record;
   -- deklaracja tasków, przyjecie dostawy i koniec zmiany
   task Unloading is
      entry DeliveryAcceptance (ShrimpsTruck : ShrimpsDelivery);
      entry Finish;
   end Unloading;
end Delivery;