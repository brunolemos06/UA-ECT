LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY counter_3bit IS
		PORT( clk, rstGr: IN STD_LOGIC;
				count : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
				);
END counter_3bit;

ARCHITECTURE Behavioral OF counter_3bit IS
	SIGNAL s_count : UNSIGNED(2 DOWNTO 0) :="000";

BEGIN
		PROCESS(clk)
			BEGIN
				IF (rising_edge(clk)) THEN 
					IF(rstGr = '1') THEN
						s_count <= "000";
					ELSE
						s_count <= s_count +1;
					END IF;
				END IF;
		END PROCESS;
 
 count <= STD_LOGIC_VECTOR(s_count);
END Behavioral;
