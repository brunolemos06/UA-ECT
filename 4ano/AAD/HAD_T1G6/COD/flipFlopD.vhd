LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY flipFlopD IS
  PORT (clk, D, nRst, en: IN STD_LOGIC;
        Q: OUT STD_LOGIC);
END flipFlopD;

ARCHITECTURE behavior OF flipFlopD IS
BEGIN
	PROCESS (clk, en,nRst)
	BEGIN

		IF (rising_edge(clk)) THEN
			IF (en = '1') THEN
				Q <= D;
			ELSIF (nRst = '1') THEN
				Q <= '0';
			END IF;
		END IF;
  END PROCESS;
  
END behavior;
