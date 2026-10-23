with Unloading_Point;

package Kukiriniarz is
   type Kukiriniarz_Name is (Skiba_Kukiriniarz,Maniek_Kukiriniarz);

   task type Kid (Id : Kukiriniarz_Name) is
      entry Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer);
      entry Finish;
   end Kid;

   procedure Assign_Transport
     (Shrimp_Type : Unloading_Point.Shrimp_Name;
      Quantity : Integer);

   procedure Finish_All;
end Kukiriniarz;