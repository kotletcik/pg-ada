package Delivery is
   
   -- Dane dostawy krewetek.
   type ShrimpsDelivery is record
      Id    : Integer;
      Towar : String(1 .. 8);
      Ilosc : Integer;
   end record;
   -- Przyjecie dostawy i koniec zmiany.
   task Unloading is
      entry Przyjecie_dostawy (ShrimpsTruck : ShrimpsDelivery);
      entry Zakoncz;
   end Unloading;
end Delivery;