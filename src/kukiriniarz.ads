package Kukiriniarz is
   type Kukiriniarz_Name is (Skiba_Kukiriniarz,Maniek_Kukiriniarz);
   task type Kid (Id : Kukiriniarz_Name) is
      entry Transport (ShrimpType : Character; Quantity : Integer);
      entry Finish;
   end Kid;
end Kukiriniarz;