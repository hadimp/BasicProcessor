library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_Arith.ALL;
use IEEE.STD_LOGIC_Unsigned.ALL;

entity Mainv01 is port(
    Clk,Rst :	in	std_logic;
	 SCClr : out std_logic;
	 PC_o: out std_logic_vector(11 downto 0);
	 opcode : out std_logic_vector(3 downto 0);
	 Count : out std_logic_vector(2 downto 0);
	 IR_o,DR_o,AC_o:	out std_logic_vector(15	downto	0);
	 System_Bus : out std_logic_vector(15 downto 0);
	 AR_o: out std_logic_vector(11 downto 0);
	 AlU_o: out std_logic_vector(16 downto 0));
end Mainv01;

architecture Behavioral of Mainv01 is
	signal	T,D:	std_logic_vector(7	downto	0);
	signal	Counter:	std_logic_vector(2	downto	0);
	signal	Sel:	std_logic_vector(2	downto	0);
	signal	PC_R, PC_L, PC_I, PC_Inc, PC_Incr, IR_R, IR_L, IR_I, Mem_R, Mem_W:	std_logic;
	signal   AC_R, AC_L, AC_I, E_L, E_Dout, AR_R, AR_L, AR_I, DR_R, DR_L, DR_I, SC_Clr, HLT: std_logic;
	signal	IR_Dout,AC_Dout,DR_Dout,Data_Bus:	std_logic_vector(15	downto	0);
	signal	Address, PC_Dout:	std_logic_vector(11	downto	0);
	signal	B:	std_logic_vector(11	downto	0);
	signal	ALU_Dout:	std_logic_vector(16	downto	0); 

begin
   Sel <= IR_Dout(14 downto 12);
	PC_Incr <= ( PC_I or PC_Inc );
	System_Bus <= Data_Bus;
	ALU_o <= ALU_Dout;
	Count <= Counter;
	IR_o <= IR_Dout;
	DR_o <= DR_Dout;
	AC_o <= AC_Dout;
	PC_o <= PC_Dout;
	SCClr <= SC_Clr;
	Ar_o <= Address;
	Opcode <= IR_Dout(15 downto 12);
	-------------------------------- Control Unit Code (Sequence Counter, Decoder and Combinational Logic Unit)
	Control:	entity	work.Control
		port	map(T	=>	T,	D	=>	D,	I	=>	IR_Dout(15), B_Ctrl => IR_Dout(11 downto 0),
					PC_R	=>	PC_R,	PC_L => PC_L, PC_I => PC_I,
					IR_R	=>	IR_R,	IR_L=>	IR_L,	IR_I	=>	IR_I,
					Mem_R	=>	Mem_R, Mem_W  =>	Mem_W,
					AC_R	=>	AC_R,	AC_L => AC_L,	AC_I	=>	AC_I,
               E_L => E_L,					
					AR_R	=>	AR_R,	AR_L => AR_L,	AR_I	=>	AR_I,
					DR_R	=>	DR_R,	DR_L => DR_L,	DR_I	=>	DR_I,					
					SC_Clr	=>	SC_Clr, HLT => HLT
					);

	process(Clk, HLT)
	begin
	 if( HLT = '1') then
        Null;
    else
		if ( rising_edge(Clk))	then	
			if(SC_Clr = '1')	then	Counter	<=	"000";
			else	Counter	<=	(Counter	+	"001");	
			end	if;
		end	if;
	 end if;
	end	process;


	T	<=	b"00000001"	when	(Counter	=	"000")	else
			b"00000010"	when	(Counter	=	"001")	else
			b"00000100"	when	(Counter	=	"010")	else
			b"00001000"	when	(Counter	=	"011")	else
			b"00010000"	when	(Counter	=	"100")	else
			b"00100000"	when	(Counter	=	"101")	else
			b"01000000"	when	(Counter	=	"110")	else
			b"10000000";
	D	<=	b"00000001"	when	(Sel  =	"000")	else
			b"00000010"	when	(Sel	=	"001")	else
			b"00000100"	when	(Sel	=	"010")	else
			b"00001000"	when	(Sel	=	"011")	else
			b"00010000"	when	(Sel	=	"100")	else
			b"00100000"	when	(Sel	=	"101")	else
			b"01000000"	when	(Sel	=	"110")	else
			b"10000000";
	------------------------------------------------------------ ALU	Block
   		B <= IR_Dout(11 downto 0);
	ALU:		entity	work.ALU
		port	map( D  =>	D,	 B => B,   In_E => E_Dout,	In_DR	=>	DR_Dout,
					In_AC	=>	AC_Dout,  PC_Inc => PC_Inc,	Out_E	=>	ALU_Dout(16),	Out_AC	=>	ALU_Dout(15	downto	0));   
	------------------------------------------------------------ E	Flip-Flop
	E:		entity	work.E
		port	map(Clk	=>	Clk,	C	=>	 Rst,  L	=>	E_L,	Din =>	ALU_Dout(16),	Dout	=>	E_Dout);
	
	------------------------------------------------------------ Registers
	AC:		entity	work.AC
		port	map(Clk	=>	Clk,	C	=>	 Rst,  R	=>	AC_R,	 L	=>	AC_L,	I	=>	AC_I,
					Data	=>	Data_Bus,	Din	=>	ALU_Dout(15	downto	0),	Dout	=>	AC_Dout);
   ----
	DR:		entity	work.DR
		port	map(Clk	=>	Clk,	C	=>	 Rst,	 R	=>	DR_R,	 L	=>	DR_L,	I	=>	DR_I,
					Data	=>	Data_Bus,	Dout	=>	DR_Dout);
   ----
	IR:		entity	work.IR
		port	map(Clk	=>	Clk,	C	=>	 Rst,	 R	=>	IR_R,	 L	=>	IR_L,	I	=>	IR_I,
					Data	=>	Data_Bus,	Dout	=>	IR_Dout);
   ----
	PC:		entity	work.PC
		port	map(Clk	=>	Clk,	C	=>	 Rst,	 R	=>	PC_R,	 L	=>	PC_L,	I	=>	PC_Incr,
					Dout => PC_Dout, Data	=>	Data_Bus(11	downto	0));
   ----
	AR:		entity	work.AR
		port	map(Clk	=>	Clk,	C	=>	 Rst,	 R	=>	AR_R,	 L	=>	AR_L,	I	=>	AR_I,
					Data	=>	Data_Bus(11	downto	0),	Dout	=>	Address);
   ----
	Memory:	entity	work.Memory
		port	map(Clk	=>	Clk,	R	=>	Mem_R,	W	=>	Mem_W,	Addr	=>	Address,
         		Data	=>	Data_Bus);
	
	------------------------------------------------------------
end Behavioral;

