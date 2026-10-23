package Unloading_Point is
   type Shrimp_Name is (Krewetki_Tygyysie,Krewetki_Zolte,Krewetki_Rozowe,Krewetki_Biale);
   -- Nasza dostawa krewetek
   type ShrimpsDelivery is record
      Id    : Integer;
      Commodity : Shrimp_Name;
      Quantity : Integer;
      Priority : Boolean;
   end record;

   type Delivery_Array is array (1 .. 10) of ShrimpsDelivery;

   protected type Delivery_Queue is
      -- Dodaje dostawę do kolejki priorytetowej albo zwykłej.
      procedure Add (Delivery : ShrimpsDelivery);
      -- Pobiera następną dostawę; Available mówi, czy kolejka nie została zamknięta i opróżniona.
      entry Take (Delivery : out ShrimpsDelivery; Available : out Boolean);
      procedure Close;
   private
      Priority_Deliveries : Delivery_Array;
      Normal_Deliveries : Delivery_Array;
      Priority_Count : Natural := 0;
      Normal_Count : Natural := 0;
      Closed : Boolean := False;
      procedure Print_State;
   end Delivery_Queue;

   Queue : Delivery_Queue;

   -- Task pracownika pobierajacy dostawy z kolejki.
   task Unloading is
   end Unloading;
end Unloading_Point;-- komentarz