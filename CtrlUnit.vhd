library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;

entity Control is
	port	(T,D :	in	std_logic_vector(7	downto	0);
			I :	in	std_logic;
			B_Ctrl : in std_logic_vector(11 downto 0);
			PC_R, PC_L, PC_I, IR_R, IR_L, IR_I, Mem_R, Mem_W, E_L :	out	std_logic;
			SC_Clr, HLT, AC_R, AC_L, AC_I, AR_R, AR_L, AR_I, DR_R, DR_L, DR_I :	out	std_logic);
end Control;

architecture Behavioral of Control is
	signal r : std_logic ;
	signal p : std_logic ;
begin
      r <=	( D(7) and T(3) and (not(I)) );
      p <=	( D(7) and T(3) and I );		
	---------------------------------------------------------
	PC_R	<=	(T(0) or (T(4) and D (5)));
	PC_L	<=	((T(4) and D(4)) or (T(5) and D(5)));
	PC_I	<=	(T(1));
	IR_R	<=	(T(2));
	IR_L	<=	(T(1));
	IR_I	<=	'0';	
	Mem_R	<=	(T(1)	or	( T(3)	and	I	and	(not(D(7))) ) or (T(4) and (D(0))) or (T(4) and (D(1))) or (T(4) and (D(2))));
	Mem_W	<=	((T(4) and D(3))	or	(T(4)	and D(5)) or (T(6) and (D(6))));
	E_L <= ( ( D(1) and T(5)) or ( r and B_Ctrl(10) ) or ( r and B_Ctrl(8) ) or ( r and B_Ctrl(7) ) or ( r and B_Ctrl(6) ) ); 
	AC_R  <= ((T(5) and D(0)) or (T(4) and D(3)) or (p and B_Ctrl(10)) or (r and B_Ctrl(9)) or (r and B_Ctrl(7)) or (r and B_Ctrl(6)) or (r and B_Ctrl(4)) or (r and B_Ctrl(3)) or (r and B_Ctrl(2)));
	AC_L  <= ((T(5) and D(0)) or (T(5) and D(1)) or (T(5) and D(2)) or (p and B_Ctrl(11)) or (r and B_Ctrl(9)) or (r and B_Ctrl(7)) or (r and B_Ctrl(6)));
	AC_I  <= (r and B_Ctrl(5));
	AR_R	<=	((T(4) and D(4)) or (T(5) and D(5)));
	AR_L	<=	(T(0)	or	T(2)	or	(T(3)	and	I	and	(not(D(7)))));
	AR_I	<=	(T(4) and D(5));
	DR_R	<=	((T(6) and (D(6))));
	DR_L	<=	((T(4) and D(0))	or	(T(4)	and D(1)) or (T(4) and (D(2))) or (T(4) and (D(6))));
	DR_I	<=	(T(5) and D(6));
	HLT   <= (r and B_Ctrl(0));
   SC_Clr  <= ( T(7) or (T(5) and D(0)) or (T(5) and D(1)) or (T(5) and D(2)) or (T(4) and D(3)) or (T(4) and D(4)) or (T(5) and D(5)) or (T(6) and D(6)) or (T(3) and D(7)) or r or p or (r and B_Ctrl(8)) or (r and B_Ctrl(1)));
	---------------------------------------------------------
end Behavioral;
