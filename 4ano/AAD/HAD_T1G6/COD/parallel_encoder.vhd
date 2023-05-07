LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY parallel_encoder IS
	PORT (m: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			x: out STD_LOGIC_VECTOR(7 DOWNTO 0)); 
END parallel_encoder;

ARCHITECTURE structure OF parallel_encoder IS
	SIGNAL iSig0, iSig1: STD_LOGIC;
	COMPONENT xor_1bit
		PORT(IN1, IN2: IN STD_LOGIC;
			  Y: OUT STD_LOGIC);
	END COMPONENT;
BEGIN
				x(0) <= m(3);										-- m4 = x0
xor_m1_m4:	xor_1bit PORT MAP (m(0), m(3), x(1));		-- m1 XOR m4 = x1
xor_m2_m4:	xor_1bit PORT MAP (m(1), m(3), x(2));		-- m2 XOR m4 = x2
xor_m1_m2:	xor_1bit PORT MAP (m(0), m(1), iSig0);		-- m1 XOR m2 = y0
xor_y0_m4:	xor_1bit PORT MAP (iSig0, m(3), x(3));		-- y0 XOR m4 = x3
xor_m3_m4:	xor_1bit PORT MAP (m(2), m(3), iSig1);		-- m3 XOR m4 = y1
				x(4) <= iSig1;										-- y1 = x4
xor_m1_x4:	xor_1bit PORT MAP (m(0), iSig1, x(5));		-- m1 XOR y1 = x5
xor_m2_x4:	xor_1bit PORT MAP (m(1), iSig1, x(6));		-- m2 XOR y1 = x6
xor_y0_x4:	xor_1bit PORT MAP (iSig0, iSig1, x(7));	-- y0 XOR y1 = x7
END structure;