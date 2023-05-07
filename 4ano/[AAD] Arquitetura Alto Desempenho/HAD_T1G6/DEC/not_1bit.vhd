LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY not_1bit IS
  PORT (IN1: IN STD_LOGIC;
        Y: OUT STD_LOGIC);
END not_1bit;

ARCHITECTURE Behavioral OF not_1bit IS
BEGIN
  Y <= NOT IN1;
END Behavioral;