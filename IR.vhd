library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;
entity IR is
	port	(R,C,L,I,Clk:	in	std_logic;
			Dout:	out	std_logic_vector(15 downto	0);
			Data:	inout	std_logic_vector(15 downto	0));
end IR;
architecture Behavioral of IR is
	signal	Data1:	std_logic_vector(15	downto	0):=x"0000";
begin
	G1:	for	i	in	0	to	15	generate
		Data(i)	<=	Data1(i)	when	(R	=	'1')	else	'Z';
	end	generate	G1;
	Dout	<=	Data1;
	process(Clk)
	begin
		if(rising_edge(Clk))	then
			if	(C	=	'1')	then	Data1	<=	x"0000";
			elsif	((L	=	'1')and(I	=	'0'))	then	Data1	<=	Data;
			elsif	((L	=	'0')and(I	=	'1'))	then	Data1	<=	(Data1	+	x"0001");
			end	if;
		end	if;
	end process;
end Behavioral;

