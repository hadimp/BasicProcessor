LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

 
ENTITY TestBench IS
END TestBench;
 
ARCHITECTURE behavior OF TestBench IS 
 
 
    COMPONENT Mainv01
    PORT(
         Clk : IN  std_logic;
         Rst : IN  std_logic;
         SCClr : OUT  std_logic;
         PC_o : OUT  std_logic_vector(11 downto 0);
         opcode : OUT  std_logic_vector(3 downto 0);
         Count : OUT  std_logic_vector(2 downto 0);
         IR_o : OUT  std_logic_vector(15 downto 0);
         DR_o : OUT  std_logic_vector(15 downto 0);
         AC_o : OUT  std_logic_vector(15 downto 0);
         System_Bus : OUT  std_logic_vector(15 downto 0);
         AR_o : OUT  std_logic_vector(11 downto 0);
         AlU_o : OUT  std_logic_vector(16 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
   signal SCClr : std_logic;
   signal PC_o : std_logic_vector(11 downto 0);
   signal opcode : std_logic_vector(3 downto 0);
   signal Count : std_logic_vector(2 downto 0);
   signal IR_o : std_logic_vector(15 downto 0);
   signal DR_o : std_logic_vector(15 downto 0);
   signal AC_o : std_logic_vector(15 downto 0);
   signal System_Bus : std_logic_vector(15 downto 0);
   signal AR_o : std_logic_vector(11 downto 0);
   signal AlU_o : std_logic_vector(16 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
   uut: Mainv01 PORT MAP (
          Clk => Clk,
          Rst => Rst,
          SCClr => SCClr,
          PC_o => PC_o,
          opcode => opcode,
          Count => Count,
          IR_o => IR_o,
          DR_o => DR_o,
          AC_o => AC_o,
          System_Bus => System_Bus,
          AR_o => AR_o,
          AlU_o => AlU_o
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   stim_proc: process
   begin		
      wait for 100 ns;	

      wait for Clk_period*10;


      wait;
   end process;

END;
