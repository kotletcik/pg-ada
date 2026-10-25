with Unloading_Point;

package Warehouse is
   task Storage is
      entry Accept_Delivery (Shrimp_Type : Unloading_Point.Shrimp_Name; Quantity : Integer);
      entry Get_State (Tygrys, Zolt, Roz, Bial : out Integer; Total, Max : out Integer);
   end Storage;
end Warehouse;