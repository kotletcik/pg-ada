package Kukiriniarz is
   task type Kid (Id : String) is
      entry Transport (ShrimpType : Character; Quantity : Integer);
      entry Finish;
   end Kid;
end Kukiriniarz;