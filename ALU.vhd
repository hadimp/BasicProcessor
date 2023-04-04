library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;

entity ALU is
	port	(D:	in	std_logic_vector(7	downto	0);
	      B: in std_logic_vector(11 downto 0);
			In_E:	in	std_logic;
			In_AC:	in	std_logic_vector(15	downto	0);
			In_DR:	in	std_logic_vector(15	downto	0);
			PC_Inc:   out std_logic;			
			Out_E:	out	std_logic;
			Out_AC:	out	std_logic_vector(15	downto	0));
end ALU;

architecture Behavioral of ALU is
	signal	Data:	std_logic_vector(16	downto	0);
begin
   Process(D,In_E,In_AC,In_DR,B,Data)
	begin
	-----------------------------------------------------------------------------
	Out_E	<=	Data(16);	Out_AC	<=	Data(15	downto	0);
	
   --- Memory Reference instructions ---
  
   CASE D IS
	   
--- AND	   
		WHEN "00000001" =>
		     
				Data <= ( In_E & ( In_DR and In_AC ) );
				PC_Inc <= '0';

--- ADD
      WHEN "00000010" =>
		
				Data <= ( ('0' & In_DR) + ( '0' & In_AC ) );
				PC_Inc <= '0';
				
--- LDA
      WHEN "00000100" =>
		
				Data <= ( IN_E & IN_DR );
				PC_Inc <= '0';
				
			
--- ISZ
      WHEN "01000000" =>
		      
				if ( In_DR = x"0000" ) then 
				    PC_Inc <= '1';
		       	 Data <= ( In_E	&	In_AC );

				else  
				    PC_Inc <= '0';
		       	 Data <= ( In_E	&	In_AC );
				end if;
				
   --- Register Reference instructions ---
	
	   WHEN "10000000" =>
		
   	   CASE B IS

--- CLA
      
		       WHEN "100000000000" =>
      
					   Data <= ( In_E & x"0000" );  
						PC_Inc <= '0';

--- CLE      						
                
				 WHEN "010000000000" =>
				      
						Data <= ( '0' & In_AC );
						PC_Inc <= '0';

--- CMA
 
             WHEN "001000000000" =>
				 
					   Data <= ( In_E & (not(In_AC)) );
						PC_Inc <= '0';

--- CME

             WHEN "000100000000"	=>
				 
   				   Data <= ( (not(In_E)) & In_AC );
						PC_Inc <= '0';

--- CIR

             WHEN "000010000000" =>
				 
					   Data <= ( In_AC(0)	&	In_E	&	In_AC(15	downto	1) );
						PC_Inc <= '0';

				 
--- CIL

             WHEN "000001000000" =>
				 
					   Data <= ( In_AC	&	In_E ); 
						PC_Inc <= '0';

						
--- SPA
            
			    WHEN "000000010000" =>
				 
					   if ( In_AC (15) = '0' ) then                                    
						
   						PC_Inc <= '1'; 
				    		Data <= ( In_E	&	In_AC );
							
               	else 
						   PC_Inc <= '0';
      		       	Data <= ( In_E	&	In_AC );

						end if;				 
 
--- SNA
            
			    WHEN "000000001000" =>
				 
					   if ( In_AC (15) = '1' ) then                                    
						
   						PC_Inc <= '1'; 
				    		Data <= ( In_E	&	In_AC );
							
               	else 
						   PC_Inc <= '0';
      		       	Data <= ( In_E	&	In_AC );

						end if;

--- SZA
            
			    WHEN "000000000100" =>
				 
					   if ( In_AC  = x"0000" ) then                                    
						
   						PC_Inc <= '1'; 
				    		Data <= ( In_E	&	In_AC );
							
               	else 
						   PC_Inc <= '0';
      		       	Data <= ( In_E	&	In_AC );

						end if;	

--- SZE
            
			    WHEN "000000000010" =>
				 
					   if ( In_E = '0' ) then                                    
						
   						PC_Inc <= '1'; 
				    		Data <= ( In_E	&	In_AC );
							
               	else 
						   PC_Inc <= '0';
      		       	Data <= ( In_E	&	In_AC );

						end if;

             WHEN OTHERS =>

				    		Data <= ( In_E	&	In_AC );
							PC_Inc <= '0';

        
		  END CASE;  
		  
	  WHEN OTHERS =>
    
   	 Data <= ( In_E	&	In_AC );
		 PC_Inc <= '0';

	 END CASE;

  
   end process;	
end Behavioral;

