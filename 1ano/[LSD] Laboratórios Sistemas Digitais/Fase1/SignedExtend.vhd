library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SignedExtend is
	port   (	input    : in std_logic_vector(6 downto 0);
				output   : out std_logic_vector(7 downto 0));
end SignedExtend;

architecture Behavioral of SignedExtend is
Begin
	output <= "0" & input when input(6) = '0' else
				 "1" & input;
end Behavioral;