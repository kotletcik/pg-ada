package Warehouse is
   task Storage is
      entry Accept_Delivery (GoodType : Character; Quantity : Integer);
      entry Check_Stock;
   end Storage;
end Warehouse;-- komentarz