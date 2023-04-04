library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;
entity PC is
	port	(R,C,L,I,Clk:	in	std_logic;
			Dout:	out	std_logic_vector(11 downto	0);
			Data:	inout	std_logic_vector(11 downto	0));
end PC;
architecture Behavioral of PC is
	signal	Data1:	std_logic_vector(11	downto	0):=x"000";
begin	
   Dout	<=	Data1;
	G1:	for	i	in	0	to	11	generate
		Data(i)	<=	Data1(i)	when	(R	=	'1')	else	'Z';
	end	generate	G1;
	process(Clk)
	begin
		if(rising_edge(Clk))	then
			if	(C	=	'1')	then	Data1	<=	x"000";
			elsif	((L	=	'1')and(I	=	'0'))	then	Data1	<=	Data;
			elsif	((L	=	'0')and(I	=	'1'))	then	Data1	<=	(Data1	+	x"001");
			end	if;
		end	if;
	end process;
end Behavioral;

