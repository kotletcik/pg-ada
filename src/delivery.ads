package Delivery is
   
   -- Nasza dostawa krewetek
   type ShrimpsDelivery is record
      Id    : Integer;
      Towar : String(1 .. 8);
      Ilosc : Integer;
   end record;
   -- deklaracja tasków, przyjecie dostawy i koniec zmiany
   task Unloading is
      entry Przyjecie_dostawy (ShrimpsTruck : ShrimpsDelivery);
      entry Zakoncz;
   end Unloading;
end Delivery;