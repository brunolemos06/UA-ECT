LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY control_unit IS
	PORT (clk			: in STD_LOGIC;
			rstGR			: in STD_LOGIC;
			kx				: out STD_LOGIC_VECTOR(9 DOWNTO 0));	
END control_unit;



ARCHITECTURE structure OF control_unit IS
	SIGNAL counter_out: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL SIGNAL_KX  : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0101010110";
	
	-- COUNTER - 3 BIT
	COMPONENT counter_3bit
		PORT(clk, rstGr: IN STD_LOGIC;
			  count				: OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;
	
	-- ROM
	COMPONENT ROM
		PORT(address			: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			  dataOut			: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	END COMPONENT;
	
	
BEGIN
	Block_Counter	:	counter_3bit PORT MAP (clk,rstGR,counter_out);			--Counter
	Block_ROM	 	:	ROM PORT MAP (counter_out,SIGNAL_KX);						--ROM
	kx <= SIGNAL_KX;
	
END structure;