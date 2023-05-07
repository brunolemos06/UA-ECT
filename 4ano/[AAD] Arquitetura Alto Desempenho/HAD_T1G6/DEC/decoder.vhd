LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decoder IS
  PORT (y: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        m: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  v: OUT STD_LOGIC);
END decoder;

ARCHITECTURE structure OF decoder IS
  SIGNAL m1_subspace, m2_subspace, m3_subspace,ms: STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL ys: STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL m1_v, m2_v, m3_v, iAnd: STD_LOGIC;
  COMPONENT Y_to_C
    PORT (y: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 c1: out STD_LOGIC_VECTOR(3 DOWNTO 0);
			 c2: out STD_LOGIC_VECTOR(3 DOWNTO 0);
			 c3: out STD_LOGIC_VECTOR(3 DOWNTO 0));
  END COMPONENT;
  COMPONENT validator
    PORT (x: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          m, v: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT calc_m4
    PORT (x: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		    in_m: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		    m: OUT STD_LOGIC);
  END COMPONENT;
  COMPONENT and_1bit
    PORT (IN1, IN2: in  STD_LOGIC;
          Y: out  STD_LOGIC);     
  END COMPONENT;
  
BEGIN
calc_c: Y_to_C PORT MAP(y, m1_subspace, m2_subspace, m3_subspace);
val_m1: validator PORT MAP(m1_subspace, ms(0), m1_v); --m1
val_m2: validator PORT MAP(m2_subspace, ms(1), m2_v); --m2
val_m3: validator PORT MAP(m3_subspace, ms(2), m3_v); --m3
		  ys(0)<= y(0);
		  ys(1)<= y(2);
		  ys(2)<= y(4);
cal_m4: calc_m4  PORT MAP(ys, ms(2 DOWNTO 1), ms(3));
and1:   and_1bit PORT MAP(m1_v, m2_v, iAnd);
and2:   and_1bit PORT MAP(iAnd, m3_v, v);
		  m<=ms;
END structure;