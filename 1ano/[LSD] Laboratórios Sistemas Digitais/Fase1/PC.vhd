library IEEE;
use IEEE.STD_LOGIC_1164.All;
use IEEE.NUMERIC_STD.ALL;

entity PC is

	generic( N     : positive := 3 ); 
	port   ( reset : in std_logic;
			   clk : in std_logic;
			   En : in std_logic;
			   cntOut : out std_logic_vector(N-1 downto 0));
end PC;

architecture Behavioral of PC is
	signal cntValue : unsigned(N-1 downto 0);
begin
	process(clk,reset)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				cntValue <= (others => '0');
			elsif (En = '1' and cntValue < ((2 ** N) -1)) then -- evita que o contador recomece
				cntValue <= cntValue + 1;
			end if;
		end if;
end process;

cntOut <= std_logic_vector(cntValue);

end Behavioral;