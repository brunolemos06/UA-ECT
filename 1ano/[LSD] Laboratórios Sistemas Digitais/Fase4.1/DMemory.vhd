library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity DMemory is

port( clk  : in std_logic;
		WE   : in std_logic;
		Addr : in std_logic_vector(7 downto 0);
		WD   : in std_logic_vector(7 downto 0);
		RD   : out std_logic_vector(7 downto 0));
end DMemory;

architecture Behavioral of DMemory is

	constant NUM_WORDS : integer :=256;
	subtype TypeDataWord is std_logic_vector(7 downto 0);
	type TypeMemory is array (0 to NUM_WORDS-1) of TypeDataWord;
	signal data_memory : TypeMemory := (X"05",X"04", others => X"00");
	
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (WE = '1') then
				data_memory(to_integer(unsigned(Addr))) <= WD;
			end if;
		end if;
	end process;
	
	RD <= data_memory(to_integer(unsigned(Addr)));
end Behavioral;