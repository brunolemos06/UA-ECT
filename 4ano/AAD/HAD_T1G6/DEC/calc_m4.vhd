LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY calc_m4 IS
  PORT (x: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		  in_m: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		  m: OUT STD_LOGIC);
END calc_m4;
ARCHITECTURE structure OF calc_m4 IS
  SIGNAL i2, i4, and_1_2, or_1_2, iSig: STD_LOGIC;
  COMPONENT or_1bit
    PORT (IN1, IN2: IN STD_LOGIC;
          Y: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT and_1bit
    PORT (IN1, IN2: IN STD_LOGIC;
          Y: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT xor_1bit
    PORT (IN1, IN2: IN STD_LOGIC;
          Y: OUT STD_LOGIC);
  END COMPONENT;
BEGIN 													--m4 =x0
xor2:	xor_1bit PORT MAP(x(1), in_m(0), i2);	-- m4=x2 XOR m2  ->eq2
xor3:	xor_1bit PORT MAP(x(2), in_m(1), i4);	-- m4=x4 XOR m3  ->eq4

and1: and_1bit PORT MAP(x(0), i2, and_1_2);	--eq0 AND eq2 = and_1_2 
or1:  or_1bit  PORT MAP(x(0), i2, or_1_2);   --eq0 OR eq2 = or_1_2
and2: and_1bit PORT MAP(or_1_2, i4, iSig);	--or_1_2 AND eq4 = iSig
or2:  or_1bit  PORT MAP(and_1_2, iSig, m);   --and_1_2 OR iSIg
END structure;