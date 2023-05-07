library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- Entidade sem portos
entity ControlUnit_tb is
end ControlUnit_tb;
architecture Stimulus of ControlUnit_tb is
 
 --sinais para ligar as entradas do ControlUnit
	signal s_clk      : std_logic;    
	signal s_reset    : std_logic :='1';
	signal s_EnPc     : std_logic;  
	signal s_RI       : std_logic;   
	signal s_RegWr    : std_logic;   
	signal s_RegDst   : std_logic;   
	signal s_ALUSrc   : std_logic;   
	signal s_ALUOp    : std_logic_vector(3 downto 0);   
	signal s_MemWr    : std_logic;   
	signal s_MemtoReg : std_logic; 
	signal s_opcode   : std_logic_vector(2 downto 0); 
	signal s_func     : std_logic_vector(3 downto 0);
	
	constant clk_period : time := 50 ns;
	
begin
 -- InstanciaÃ§Ã£o da ControlUnit
 ControlUnit: entity work.ControlUnit(Behavioral)
 
 port map(
			   clk      => s_clk,
				rst      => s_reset,
				opcode   => s_opcode,
				func     => s_func,
			   RI       => s_RI,
			   RegWr    => s_RegWr,
				RegDst   => s_RegDst,
				ALUSrc   => s_ALUSrc,
				ALUOp    => s_ALUOp,
				MemWr    => s_MemWr,
				MemtoReg => s_MemtoReg,
				EnPc     => s_EnPc
			);

			
 
			
 --Process clock
 clk_proc : process
 begin
	s_clk <= '0';
	wait for clk_period/2;
	s_clk <= '1';
	wait for clk_period/2;
 end process;
 
  
 --Process stim
 stim_proc : process
 begin
	--if(rising_edge(s_clk)) then
	
		s_reset <= '1';
		wait for 2*clk_period;
		s_reset <= '0';
		s_opcode <= "001";
		s_func   <= "0001"; -- testar funÃ§Ã£o sub
		
		wait for 5*clk_period;
		s_opcode  <= "110";
		s_func   <= "0000"; -- o func nao interessa (inst TIPO II )
		
		wait for 5*clk_period;
		s_opcode <= "111"; 
		s_func   <= "1010"; --  o func nao interessa (inst TIPO II)
		
		wait for 5* clk_period;
		s_opcode <= "100";
		s_func   <= "0000";

		wait for 5* clk_period;
		s_opcode <= "000";
		s_func   <= "0000";
		
		wait for 5*clk_period;
	--end if;
end process;
end Stimulus;