package Delivery is
   
   -- Nasza dostawa krewetek
   type ShrimpDelivery is record
      Id    : Integer;
      Towar : Character;
      Ilosc : Integer;
   end record;
   
end Delivery;