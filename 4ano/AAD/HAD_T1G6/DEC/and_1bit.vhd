library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_1bit is
    Port ( IN1 : in  STD_LOGIC;      -- XOR gate input 1
           IN2 : in  STD_LOGIC;      -- XOR gate input 2
           Y   : out  STD_LOGIC);     -- XOR gate output
end and_1bit;

architecture Behavioral of and_1bit is
begin
Y <= IN1 and IN2;		-- 2 input exclusive-OR gate
end Behavioral;