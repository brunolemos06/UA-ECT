library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_1bit is
    Port ( IN1 : in  STD_LOGIC;      -- XOR gate input 1
           IN2 : in  STD_LOGIC;      -- XOR gate input 2
           Y   : out  STD_LOGIC);     -- XOR gate output
end or_1bit;

architecture Behavioral of or_1bit is
begin
Y <= IN1 or IN2;		-- 2 input exclusive-OR gate
end Behavioral;