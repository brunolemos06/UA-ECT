LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY calc_y IS
	PORT (clk	: in STD_LOGIC;
			rstGR	: in STD_LOGIC;
			en		: in STD_LOGIC;
			mi		: in STD_LOGIC;
			kx		: in STD_LOGIC;
			yx		: out STD_LOGIC);
END calc_y;



ARCHITECTURE structure OF calc_y IS
	SIGNAL OUT_AND, OUT1_FLIPFLOP,OUT2_FLIPFLOP, IN_FLIPFLOP : STD_LOGIC;

	-- FlipFlop
	COMPONENT flipFlopD
		PORT(	clk, D, nRst, en	: IN STD_LOGIC;
				Q: OUT STD_LOGIC);
	END COMPONENT;
	
	
	-- AND 1 BIT
	COMPONENT and_1bit
		PORT(IN1 : in  STD_LOGIC;
           IN2 : in  STD_LOGIC;
           Y   : out  STD_LOGIC);
	END COMPONENT;
	
	-- XOR 1 BIT
	COMPONENT xor_1bit
		PORT( IN1 : in  STD_LOGIC;
				IN2 : in  STD_LOGIC;
				Y   : out  STD_LOGIC);
	END COMPONENT;
	
	-- Registo
	COMPONENT Registo
		 port(clk 			: in std_logic;
			en	 				: in std_logic;
			reset				: in std_logic;
			writeData   	: in std_logic;
			dataOut			: out std_logic);
	END COMPONENT;
	
BEGIN
	mi_and_kx 					: and_1bit 	PORT MAP (mi , kx , OUT_AND);
	outand_XOR_outFlipFlop	: xor_1bit 	PORT MAP (OUT_AND , OUT1_FLIPFLOP,IN_FLIPFLOP);
	Block1_flipFlopD 			: flipFlopD PORT MAP (clk,IN_FLIPFLOP,rstGR, en or (not rstGR), OUT1_FLIPFLOP);
	BLOCK_AND 					: and_1bit  PORT MAP (OUT1_FLIPFLOP,not en, OUT2_FLIPFLOP); -- en = 1 imprime resultado
	yx <= OUT2_FLIPFLOP;
END structure;