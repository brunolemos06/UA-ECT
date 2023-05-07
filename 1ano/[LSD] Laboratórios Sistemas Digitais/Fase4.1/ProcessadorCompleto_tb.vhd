library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- Entidade sem portos
entity ProcessadorCompleto_tb is
end ProcessadorCompleto_tb;
architecture Stimulus of ProcessadorCompleto_tb is
 
 --sinais para ligar as entradas do ProcessadorCompleto
	signal s_clk      : std_logic;    
	signal s_reset    : std_logic :='1';	
	constant clk_period : time := 50 ns;
	
begin

	T_ProcessadorCompleto : entity work.ProcessadorCompleto(Structural)
		port map(
					clk      => s_clk,
					reset      => s_reset			
				   );
			
			
		--Process clock
		 clk_proc : process
		 begin
			s_clk <= '0';
			wait for clk_period/2;
			s_clk <= '1';
			wait for clk_period/2;
		 end process;
 
 
 
		 --process reset
		 reset_proc : process
		 begin
			wait for 2*clk_period;
			s_reset <= '0';
		 end process;
	
end Stimulus;