package Kukiriniarz is
   type Kukiriniarz_Name is (G2, G4);

   task type Kid (Id : Kukiriniarz_Name) is
      entry Transport (ShrimpType : Character; Quantity : Integer);
      entry Finish;
   end Kid;
end Kukiriniarz;