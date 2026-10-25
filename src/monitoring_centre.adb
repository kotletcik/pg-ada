with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Monitoring_Centre is
   ESC : constant Character := Ada.Characters.Latin_1.ESC;

   protected body Screen is
      -- ta procderua rysuje ekran na dole konsoli, trzyma go sztywno za twarz
      procedure Redraw_Footer is
      begin
         Put(ESC & "[?25l"); -- teoretycznie powinno ukryc migotanie kursora
         Put(ESC & "[J");    -- czysci stary interfejs
         
         for I in 1 .. 7 loop
            Put_Line(To_String(Footer(I)));
         end loop;
         Put(To_String(Footer(8))); -- blokada znaku na ostatniej linijsce
         
         -- to cos cofa kursor do gory po to by tabelka sie ladnie wyswietlala
         Put(ESC & "[7A");
         Put(ESC & "[1G");
         Put(ESC & "[?25h");
         Flush;
      end Redraw_Footer;

      -- resertuje konsole po prostu
      procedure Init_Screen is
      begin
         Put(ESC & "[2J");
         Put(ESC & "[1;1H");
         Put(ESC & "[?7l");

         Footer(1) := To_Unbounded_String("------------------------- STATYSTYKI CENTRUM -------------------------");
         for I in 2 .. 8 loop
            Footer(I) := To_Unbounded_String("");
         end loop;

         Redraw_Footer;
      end Init_Screen;

      -- spamuje logami
      procedure Log (Message : String) is
      begin
         Put(ESC & "[?25l");
         Put(ESC & "[2K");    
         Put(ESC & "[1G");
         Put_Line(Message);
         Redraw_Footer;
         Flush;
      end Log;

      -- to robi nam miejsce na bufor dla tabeli
      procedure Update_Monitor (Row : Positive; Message : String) is
         Index : constant Integer := Row - 20;
      begin
         if Index in 2 .. 8 then
            Footer(Index) := To_Unbounded_String(Message);
            Redraw_Footer;
         end if;
      end Update_Monitor;
      -- a to nie zgadniecie, resetuje nasz bufor
      procedure Reset_Screen is
      begin
         Put(ESC & "[?7h");
         for I in 1 .. 8 loop
            Put_Line("");
         end loop;
         Flush;
      end Reset_Screen;
   end Screen;
end Monitoring_Centre;