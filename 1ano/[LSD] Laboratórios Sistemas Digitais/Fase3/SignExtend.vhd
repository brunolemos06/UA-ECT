library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SignExtend is
	port   (	input    : in std_logic_vector(6 downto 0);
				output   : out std_logic_vector(7 downto 0));
end SignExtend;

architecture Behavioral of SignExtend is
Begin
	output <= '0' & input;
end Behavioral;