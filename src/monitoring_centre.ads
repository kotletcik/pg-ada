with Ada.Strings.Unbounded;

package Monitoring_Centre is
   -- Jawna deklaracja nazwanego typu tablicowego
   type Footer_Buffer is array (1 .. 8) of Ada.Strings.Unbounded.Unbounded_String;

   protected Screen is
      procedure Init_Screen;
      procedure Log (Message : String);
      procedure Update_Monitor (Row : Positive; Message : String);
      procedure Close_History;
      procedure Reset_Screen;
   private
      Footer : Footer_Buffer;
      procedure Redraw_Footer;
   end Screen;
end Monitoring_Centre;