with Unloading_Point;

package Kukiriniarz is
   type Kukiriniarz_Name is (Skiba_Kukiriniarz,Maniek_Kukiriniarz);

   type Battery_Array is array (Kukiriniarz_Name) of Integer;
   type Busy_Array is array (Kukiriniarz_Name) of Boolean;

   task type Kid (Id : Kukiriniarz_Name) is
      entry Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer);
      entry Finish;
   end Kid;

   protected Tracker is
      procedure Update (Id : Kukiriniarz_Name; Battery : Integer; Busy : Boolean);
      procedure Get_State (Id : Kukiriniarz_Name; Battery : out Integer; Busy : out Boolean);
   private
      -- Użycie nowo zdefiniowanych typów
      Baterie : Battery_Array := (others => 100);
      Zajetosc : Busy_Array := (others => False);
   end Tracker;

   procedure Assign_Transport
     (Shrimp_Type : Unloading_Point.Shrimp_Name;
      Quantity : Integer);

   procedure Finish_All;
end Kukiriniarz;