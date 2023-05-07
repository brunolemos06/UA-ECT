library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity pMux2_1 is
	generic( N : positive := 8 ); -- facilitar a simulacao
	port   (	sel    : in std_logic;
			   input0 : in std_logic_vector(N-1 downto 0);
				input1 : in std_logic_vector(N-1 downto 0);
				muxOut : out std_logic_vector(N-1 downto 0));
end pMux2_1;

architecture Behavioral of pMux2_1 is
begin

muxOut <= input0 when (sel = '0')else
			 input1 when (sel = '1');

end Behavioral;
