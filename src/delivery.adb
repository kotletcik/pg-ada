with Logging;
package body Delivery is
   -- Task odpowiedzialny za przyjmowanie i rozladunek dostaw.
   task body Unloading is
      End_Of_Shift : Boolean := False;
   begin
      -- Obsluga dostaw trwa do zakonczenia zmiany.
      while not End_Of_Shift loop
         select
            accept Przyjecie_dostawy (ShrimpsTruck : ShrimpsDelivery) do
               Logging.Put_Line("Dostawa: Przyjelismy ladunek o ID: " & ShrimpsTruck.Id'Image & ", Towar: " & ShrimpsTruck.Towar & ", Ilosc: " & ShrimpsTruck.Ilosc'Image);
            end Przyjecie_dostawy;
            
            Logging.Put_Line("Dostawa: Rozpoczynamy rozladunek");
            delay 3.0; 
            Logging.Put_Line("Dostawa: Skonczylismy, czekamy na kolejne auta");
         or
            accept Zakoncz;
            End_Of_Shift := True;
         end select;   
      end loop;
      Logging.Put_Line("Dostawa: Jedziemy do domu 67");
   end Unloading;
end Delivery;
