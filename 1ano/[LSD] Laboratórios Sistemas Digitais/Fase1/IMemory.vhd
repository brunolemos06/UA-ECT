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
	"1110000010000001",  -- LW  $0, $1,  1 -> carregar no registo 1 dados que se encontram no endereco [registo0 +1] na memoria de dados 
	"1110000100000000",  -- LW  $0, $2,  1 -> carregar no registo 2 dados que se encontram no endereco [registo0 +0] na memoria de dados
	"0010010100110000",  -- ADD $1, $2, $3 -> realizar a operacao registo3 = registo1  +  registo2
	"0010010101001100",	-- SLS $1, $2, $4 -> realizar a operacao registo4 = registo1 SLS registo2								 
	"1100010110000000",  -- SW  $1, $3,  0 -> escrever no endereco[registo1+0] na memoria de dados o conteudo do registo 3
	"1100011000000001",  -- SW  $1, $4,  1 -> escrever no endereco[registo1+1] na memoria de dados o conteudo do registo 4
	"0000000000000000",  -- NOP            -> nao fazer nada
	"0000000000000000"   -- NOP            -> nao fazer nada
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