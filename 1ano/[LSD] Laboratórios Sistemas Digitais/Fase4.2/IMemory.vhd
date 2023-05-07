library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity IMemory is
	generic( N     : positive := 3 ); 
	port(	clk : in std_logic;
			En  : in std_logic;
			RA  : in std_logic_vector(N-1 downto 0);
			RD  : out std_logic_vector(15 downto 0));
end IMemory;

architecture Behavioral of IMemory is
	subtype TypeDataWord is std_logic_vector(15 downto 0);
	type TypeROM is array (0 to ((2 ** N)-1)) of TypeDataWord; -- size do array é dimencionado com base no numero de bits do RA 
	constant rom_data: TypeROM := (
	
   "1110000010000000",  -- LW  $0, $1,  0 -> carregar no registo 1 dados que se encontram no endereco [registo0 + 0] na memoria de dados 
	"1110000100000001",  -- LW  $0, $2,  1 -> carregar no registo 2 dados que se encontram no endereco [registo0 + 1] na memoria de dados
	"0010010100111100",  -- SLS $1, $2, $3 -> registo3 = 1 se (signed)registo1 < (sigend)registo2 , se não dá 0.
	"1110110100000000",	-- LW  $3, $2,  0 -> carregar no registo 2 dados que se encontram no endereco [registo3 + 0] na memoria de dados
	"1110000010000010",  -- LW  $0, $1,  2 -> carregar no registo 1 dados que se encontram no endereco [registo0 + 2] na memoria de dados
	"0010010100111100",  -- SLS $1, $2, $3 -> registo3 = 1 se (signed)registo1 < (sigend)registo2 , se não dá 0.
	"1100000100000011",  -- SW  $0, $2,  3 -> escrever no endreço [registo0 + 3] na memória de dados o conteudo do registo 2 
	"1110111000000010",  -- LW  $3, $4,  2 -> carregar no registo 4 dados que se encontram no endereco [registo3 + 2] na memoria de dados
	"1100001000000011",  -- SW  $0, $4,  3 -> escrever no endreço [registo0 + 3] na memória de dados o conteudo do registo 4
	others => "0000000000000000"
	
	
	);
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if(En ='1') then
				RD <= rom_data(to_integer(unsigned(RA)));
			end if;
		end if;
	end process;
end Behavioral;