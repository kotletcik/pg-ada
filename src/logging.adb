with Ada.Real_Time;
with Ada.Text_IO;

package body Logging is
   use type Ada.Real_Time.Time;

   Start_Time : Ada.Real_Time.Time := Ada.Real_Time.Clock;

   procedure Start is
   begin
      Start_Time := Ada.Real_Time.Clock;
   end Start;

   procedure Put_Line (Message : String) is
      Elapsed : constant Duration :=
        Ada.Real_Time.To_Duration (Ada.Real_Time.Clock - Start_Time);
   begin
      Ada.Text_IO.Put_Line ("[" & Duration'Image (Elapsed) & " s] " & Message);
   end Put_Line;
end Logging;
