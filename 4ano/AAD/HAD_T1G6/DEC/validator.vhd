LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY validator IS
  PORT (x: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        m, v: OUT STD_LOGIC);
END validator;

ARCHITECTURE structure OF validator IS
  SIGNAL m1_2, m3_4, dev_m, v1_2, nv1_2, v3_4, nv3_4, dev_v: STD_LOGIC;
  COMPONENT and_1bit
    PORT (IN1, IN2: IN STD_LOGIC;
          Y: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT or_1bit
    PORT (IN1, IN2: IN STD_LOGIC;
          Y: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT xor_1bit
    PORT (IN1, IN2: IN STD_LOGIC;
          Y: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT not_1bit
    PORT (IN1: IN STD_LOGIC;
          Y: OUT STD_LOGIC);
  END COMPONENT;
 --m = C1.C2 + C3C4
 --v = (C1.C2 + C3C4) XOR (NOT (C1+C2) + NOT (C3+C4))
BEGIN
  and1: and_1bit PORT MAP(x(0),x(1), m1_2);		--C1.C2
  and2: and_1bit PORT MAP(x(2),x(3), m3_4);		--C3.C4
  or1 : or_1bit  PORT MAP(m1_2, m3_4, dev_m);
        m <= dev_m;										--m'
  or2 : or_1bit  PORT MAP(x(0),x(1), v1_2);		--C1+C2
  not1: not_1bit PORT MAP(v1_2, nv1_2);			-- NOT (C1+C2)
  or3 : or_1bit  PORT MAP(x(2),x(3), v3_4);		--C3+C4
  not2: not_1bit PORT MAP(v3_4, nv3_4);			-- NOT (C3+C4)
  or4 : or_1bit  PORT MAP(nv1_2, nv3_4, dev_v);	-- NOT (C1+C2) + NOT (C3+C4)
  xor1: xor_1bit PORT MAP(dev_m, dev_v, v);
END structure;