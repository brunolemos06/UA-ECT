library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ROM is
	generic( addrSize : integer :=4;
				dataSize : integer :=10);
	port(	address : in std_logic_vector(addrSize-2 downto 0);
			dataOut : out std_logic_vector(dataSize-1 downto 0));
end ROM;

architecture Behavioral of ROM is

	subtype TDataWord is std_logic_vector(dataSize-1 downto 0);
	type TROM is array (0 to (2*addrSize-1)) of TDataWord;
	-- kx 8bits -busy -reset
--	constant c_memory: TROM := ("0000000010", "0101010110", "0011001110", "0000111110", "1111111110","1111111110", "0000000000","0000000000");
	constant c_memory: TROM := ("0000000001", "0101010110", "0011001110", "0000111110", "1111111111","0000000000", "0000000000","0000000000");

	
begin	

dataOut <= c_memory(to_integer(unsigned(address)));

end Behavioral;