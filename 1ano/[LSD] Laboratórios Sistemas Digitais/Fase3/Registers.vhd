library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Registers is

port( clk   : in std_logic;
		reset : in std_logic;
		RA1   : in std_logic_vector(2 downto 0);
		RA2   : in std_logic_vector(2 downto 0);
		WA    : in std_logic_vector(2 downto 0);
		WD    : in std_logic_vector(7 downto 0);
		WE    : in std_logic;
		RD1   : out std_logic_vector(7 downto 0);
		RD2   : out std_logic_vector(7 downto 0));
end Registers;

architecture Behavioral of Registers is

	constant NUM_WORDS : integer :=8;
	subtype TypeDataWord is std_logic_vector(7 downto 0);
	type TypeRegisters is array (0 to NUM_WORDS-1) of TypeDataWord;
	signal register_mem : TypeRegisters := (others => X"00");
	
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if(reset = '1') then
				register_mem <= (others => X"00");
			elsif (WE = '1' and not (WA = "000") ) then -- o registo 0 nao pode ser escrito
				register_mem(to_integer(unsigned(WA))) <= WD;
			end if;
		end if;
	end process;
	
	RD1 <= register_mem(to_integer(unsigned(RA1)));
	RD2 <= register_mem(to_integer(unsigned(RA2)));
	
end Behavioral;