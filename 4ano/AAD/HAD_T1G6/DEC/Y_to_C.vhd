LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Y_to_C IS
	PORT (y: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			c1: out STD_LOGIC_VECTOR(3 DOWNTO 0);
			c2: out STD_LOGIC_VECTOR(3 DOWNTO 0);
			c3: out STD_LOGIC_VECTOR(3 DOWNTO 0)
			);
END Y_to_C;

ARCHITECTURE structure OF Y_to_C IS
	COMPONENT xor_1bit
		PORT(IN1, IN2: IN STD_LOGIC;
			  Y: OUT STD_LOGIC);
	END COMPONENT;

BEGIN
xor_y0_y1:	xor_1bit PORT MAP (y(0), y(1), c1(0));		-- c1(0) = y0 xor y1
xor_y2_y3:	xor_1bit PORT MAP (y(2), y(3), c1(1));		-- c1(1) = y2 xor y3
xor_y4_y5:	xor_1bit PORT MAP (y(4), y(5), c1(2));		-- c1(2) = y4 xor y5
xor_y6_y7:	xor_1bit PORT MAP (y(6), y(7), c1(3));		-- c1(3) = y6 xor y7

xor_y0_y2:	xor_1bit PORT MAP (y(0), y(2), c2(0));		-- c2(0) = y0 xor y2
xor_y1_y3:	xor_1bit PORT MAP (y(1), y(3), c2(1));		-- c2(1) = y1 xor y3
xor_y4_y6:	xor_1bit PORT MAP (y(4), y(6), c2(2));		-- c2(2) = y4 xor y6
xor_y5_y7:	xor_1bit PORT MAP (y(5), y(7), c2(3));		-- c2(3) = y5 xor y7

xor_y0_y4:	xor_1bit PORT MAP (y(0), y(4), c3(0));		-- c3(0) = y0 xor y4
xor_y1_y5:	xor_1bit PORT MAP (y(1), y(5), c3(1));		-- c3(1) = y1 xor y5
xor_y2_y6:	xor_1bit PORT MAP (y(2), y(6), c3(2));		-- c3(2) = y2 xor y6
xor_y3_y7:	xor_1bit PORT MAP (y(3), y(7), c3(3));		-- c3(3) = y3 xor y7

END structure;