LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY serial_encoder IS
   PORT(
      clk      : IN   	STD_LOGIC;
      rstGr    : IN   	STD_LOGIC;
		m    		: IN  	STD_LOGIC;
		Y			: OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
end serial_encoder;

ARCHITECTURE structure OF serial_encoder IS

	-- INTERNAL SIGNAL
	SIGNAL SIG_BUSY 				: STD_LOGIC;
	SIGNAL SIG_RESET  			: STD_LOGIC:='0';
	SIGNAL SIG_RESET_FLIPFLOP 	: STD_LOGIC;
	SIGNAL SIG_KX 	: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL SIG_M   : STD_LOGIC;
	
	-- CONTROL
	COMPONENT control_unit
	PORT (clk			: in STD_LOGIC;
			rstGR			: in STD_LOGIC;
			kx				: out STD_LOGIC_VECTOR(9 DOWNTO 0));
	END COMPONENT;
	
	-- CALC_Y
	COMPONENT calc_y
	PORT (clk	: in STD_LOGIC;
			rstGR	: in STD_LOGIC;
			en		: in STD_LOGIC;
			mi		: in STD_LOGIC;
			kx		: in STD_LOGIC;
			yx		: out STD_LOGIC);
	END COMPONENT;
	
	-- REGISTER
	COMPONENT FlipFlopD
  PORT (clk, D, nRst, en: IN STD_LOGIC;
        Q: OUT STD_LOGIC);
	END COMPONENT;
	
	
BEGIN
	block_control_unit 	: control_unit 		PORT MAP (clk , (SIG_RESET and SIG_BUSY) or rstGr,SIG_KX);
	SIG_RESET <= SIG_KX(0) or rstGr;
	SIG_BUSY  <= SIG_KX(1) and not rstGr;
	SIG_RESET_FLIPFLOP <= SIG_RESET and not SIG_BUSY;
	block_ffD 				: FlipFlopD 	PORT MAP	(clk , m, SIG_RESET   	, '1'      , SIG_M);
	block_calc_y0   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(2) , Y(0));
	block_calc_y1   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(3) , Y(1));
	block_calc_y2   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(4) , Y(2));
	block_calc_y3   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(5) , Y(3));
	block_calc_y4   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(6) , Y(4));
	block_calc_y5   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(7) , Y(5));
	block_calc_y6   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(8) , Y(6));
	block_calc_y7   		: calc_y 		PORT MAP	(clk , SIG_RESET_FLIPFLOP , SIG_BUSY , SIG_M     , SIG_KX(9) , Y(7));
END structure;