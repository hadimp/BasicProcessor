library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;
entity E is
	port	(L,C,Clk:	in	std_logic;
			Dout:	out	std_logic;
			Din:	in	std_logic);
end E;
architecture Behavioral of E is
	signal	Data1:	std_logic:='0';
begin
	Dout	<=	Data1;
	process(Clk)
	begin
		if(rising_edge(Clk))	then
			if	(C	=	'1')	then	Data1	<=	'0';
			elsif	(L	=	'1')	then	Data1	<=	Din;
			end	if;
		end	if;
	end process;
end Behavioral;

