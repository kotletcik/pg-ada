package Unloading_Point is
   type Shrimp_Name is (Krewetki_Tygyysie,Krewetki_Zolte,Krewetki_Rozowe,Krewetki_Biale);
   -- Nasza dostawa krewetek
   type ShrimpsDelivery is record
      Id    : Integer;
      Commodity : Shrimp_Name;
      Quantity : Integer;
   end record;
   -- deklaracja tasków, przyjecie dostawy i koniec zmiany
   task Unloading is
      entry DeliveryAcceptance (ShrimpsTruck : ShrimpsDelivery);
      entry Finish;
   end Unloading;
end Unloading_Point;-- komentarz