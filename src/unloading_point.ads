package Unloading_Point is

   type Shrimp_Name is (Krewetki_Tygyysie, Krewetki_Zolte, Krewetki_Rozowe, Krewetki_Biale);

   -- Nasza dostawa krewetek
   type ShrimpsDelivery is record
      Id        : Integer;
      Commodity : Shrimp_Name;
      Quantity  : Integer;
      Priority  : Boolean;
   end record;

   protected type Stats_Tracker is
      procedure Join_Queue (Priority : Boolean);
      procedure Leave_Queue (Priority : Boolean);
      procedure Get_Stats (Priority_Wait, Normal_Wait, Served : out Integer);
      procedure Print_State;
      procedure Record_Served;
   private
      Priority_Count : Natural := 0;
      Normal_Count   : Natural := 0;
      Total_Served   : Integer := 0;
   end Stats_Tracker;

   Queue : Stats_Tracker;

   -- Task pracownika pobierajacy dostawy z kolejki.
   task Unloading is
      entry Unload_Priority (Delivery : in ShrimpsDelivery);
      entry Unload_Normal (Delivery : in ShrimpsDelivery);
      entry Wait_Until_Done;
   end Unloading;

end Unloading_Point;