with Unloading_Point;

package Warehouse is
   task Storage is
      entry Accept_Delivery (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer);
      entry Check_Stock;
   end Storage;
end Warehouse;