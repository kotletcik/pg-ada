with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Monitoring_Centre is

   -- znak sterujacy uzywany do obslugi terminala
   ESC : constant Character := Ada.Characters.Latin_1.ESC;

   protected body Screen is

      -- Wewnętrzna metoda rysująca pływający interfejs i cofająca kursor
      procedure Redraw_Footer is
      begin
         -- odswiezenie dolnej czesci interfejsu
         Put(ESC & "[?25l"); -- Ukrycie kursora eliminuje migotanie
         Put(ESC & "[J");    -- Wyczyszczenie śmieci po starym interfejsie
         
         for I in 1 .. 7 loop
            Put_Line(To_String(Footer(I)));
         end loop;
         Put(To_String(Footer(8))); -- Ostatnia linia bez znaku nowej linii
         
         -- Cofnięcie kursora dokładnie o 7 linii w górę, na początek footera.
         -- Dzięki temu następny Log bezbłędnie nadpisze pierwszą linię statystyk.
         Put(ESC & "[7A");
         Put(ESC & "[1G");
         Put(ESC & "[?25h");
         Flush;
      end Redraw_Footer;

      procedure Init_Screen is
      begin
         -- przygotowanie pustego ekranu i bufora statystyk
         Put(ESC & "[2J");    -- Pełne czyszczenie
         Put(ESC & "[1;1H");  -- Start od samej góry
         Put(ESC & "[?7l");   -- Wyłączenie zawijania wierszy (ochrona układu)

         Footer(1) := To_Unbounded_String("------------------------- STATYSTYKI CENTRUM -------------------------");
         for I in 2 .. 8 loop
            Footer(I) := To_Unbounded_String("");
         end loop;

         Redraw_Footer;
      end Init_Screen;

      procedure Log (Message : String) is
      begin
         -- wyswietlenie komunikatu nad statystykami
         Put(ESC & "[?25l");
         Put(ESC & "[2K");    -- Agresywne czyszczenie linii przed nowym logiem
         Put(ESC & "[1G");    -- Skok na początek linii
         Put_Line(Message);   -- Wypisanie logu (terminal naturalnie scrolluje ekran)
         Redraw_Footer;       -- Narysowanie statystyk w nowym miejscu
         Flush;
      end Log;

      procedure Update_Monitor (Row : Positive; Message : String) is
         -- Mapowanie wierszy analizatora (22-28) na nasz bufor (2-8)
         Index : constant Integer := Row - 20;
      begin
         -- zapisanie komunikatu w odpowiednim wierszu statystyk
         if Index in 2 .. 8 then
            Footer(Index) := To_Unbounded_String(Message);
            Redraw_Footer;
         end if;
      end Update_Monitor;

      procedure Reset_Screen is
      begin
         -- przywrocenie ustawien terminala po zakonczeniu programu
         Put(ESC & "[?7h"); -- Przywrócenie zawijania
         
         -- Wykonujemy 8 pustych znaków nowej linii, aby bezpiecznie 
         -- wypchnąć statystyki w górę i oddać konsolę powłoce systemowej
         for I in 1 .. 8 loop
            Put_Line("");
         end loop;
         Flush;
      end Reset_Screen;

   end Screen;
end Monitoring_Centre;