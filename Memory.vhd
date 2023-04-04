library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;
use ieee.std_logic_textio.all;
library STD;
use std.textio.all;

entity Memory is
	port	(R,W,Clk:	in	std_logic;
			Addr:	in		std_logic_vector(11 downto	0);
			Data:	inout	std_logic_vector(15 downto	0));
end Memory;

architecture Behavioral of Memory is
	type	Reg	is	array	(0	to	4095)	of	std_logic_vector(15	downto	0);
	----------------------------------------------------------------------
	impure function ReadMemFile return Reg is
		file RomFile : text open read_mode is "ROMData.txt";
		variable RomFileLine:	line;
		variable Result       : Reg;
	begin
		L1:	for i in 0 to 4095	loop
			if not endfile(RomFile) then
				readline(RomFile, RomFileLine);
				read(RomFileLine,Result(i));
			end if;
		end loop L1;
		return Result;
	end function;
	----------------------------------------------------------------------
	signal	Mem:	Reg:=ReadMemFile;
	signal	Data1	:	std_logic_vector(15	downto	0);
begin
	----------------------------------------------------------------------------
	G1:	for	i	in	0	to	15	generate
		Data(i)	<=	Data1(i)	when	((W='0')and(R='1'))	else	'Z';
	end	generate	G1;
	Data1	<=	Mem(CONV_INTEGER(Addr));
	----------------------------------------------------------------------------
	process(Clk)
	begin
		if (rising_edge(Clk))	then
			if((W='1')and(R='0'))	then	Mem(CONV_INTEGER(Addr))	<=	Data;	end if;
		end if;
	end process;
	----------------------------------------------------------------------------
end Behavioral;

