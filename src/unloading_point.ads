package Unloading_Point is
   type Shrimp_Name is (Krewetki_Tygyysie,Krewetki_Zolte,Krewetki_Rozowe,Krewetki_Biale);
   
   type ShrimpsDelivery is record
      Id    : Integer;
      Commodity : Shrimp_Name;
      Quantity : Integer;
      Priority : Boolean;
   end record;

   -- Zmieniono z grubej kolejki na lekki obiekt do statystyk dla Monitora
   protected Queue is
      procedure Add_Waiting (Priority : Boolean);
      procedure Remove_Waiting (Priority : Boolean);
      procedure Record_Served;
      procedure Get_Stats (Priority_Wait, Normal_Wait, Served : out Integer);
   private
      Priority_Count : Natural := 0;
      Normal_Count : Natural := 0;
      Total_Served : Integer := 0;
   end Queue;

   -- Task pracownika, ktory TERAZ zastepuje sztuczna kolejke i uzywa mechanizmu spotkan
   task Unloading is
      entry Unload_Priority (Delivery : ShrimpsDelivery);
      entry Unload_Normal (Delivery : ShrimpsDelivery);
      entry Close;
      entry Wait_Until_Done;
   end Unloading;
end Unloading_Point;