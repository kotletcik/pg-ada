with Unloading_Point;

package Kukiriniarz is
   type Kukiriniarz_Name is (Skiba_Kukiriniarz,Maniek_Kukiriniarz);
   task type Kid (Id : Kukiriniarz_Name) is
      entry Transport (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer);
      entry Finish;
   end Kid;
end Kukiriniarz;