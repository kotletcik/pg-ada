with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Monitoring_Centre is
   ESC : constant Character := Ada.Characters.Latin_1.ESC;
   History_File : File_Type;

   protected body Screen is
      procedure Init_Screen is
      begin
         Create(History_File, Out_File, "pelny_przebieg_symulacji.txt");
         Put(ESC & "[2J"); 
         Put(ESC & "[?7l");
         
         Put(ESC & "[21;1H");
         Put(ESC & "[K");
         Put("------------------------- STATYSTYKI CENTRUM (MODUL G) -------------------------");
         Flush;
      end Init_Screen;

      procedure Log (Message : String) is
      begin
         for I in 1 .. 19 loop
            Logs(I) := Logs(I + 1);
         end loop;
         
         Logs(20) := To_Unbounded_String(Message);
         
         Put(ESC & "[?25l"); 
         for I in 1 .. 20 loop
            declare
               Row_Str : constant String := Ada.Strings.Fixed.Trim(I'Image, Ada.Strings.Left);
            begin
               Put(ESC & "[" & Row_Str & ";1H"); 
               Put(ESC & "[K");                  
               Put(To_String(Logs(I)));          
            end;
         end loop;
         Put(ESC & "[?25h"); 
         Flush;
         
         Put_Line(History_File, Message);
         Flush(History_File);
      end Log;

      procedure Update_Monitor (Row : Positive; Message : String) is
         Row_Str : constant String := Ada.Strings.Fixed.Trim(Row'Image, Ada.Strings.Left);
      begin
         Put(ESC & "[?25l");
         Put(ESC & "[" & Row_Str & ";1H"); 
         Put(ESC & "[K");                  
         Put(Message);
         Put(ESC & "[?25h");                   
         Flush;
      end Update_Monitor;

      procedure Close_History is
      begin
         if Is_Open(History_File) then
            Close(History_File);
         end if;
      end Close_History;

      procedure Reset_Screen is
      begin
         Put(ESC & "[?7h");
         Put(ESC & "[30;1H");
         Put_Line("");
         Flush;
      end Reset_Screen;
   end Screen;
end Monitoring_Centre;