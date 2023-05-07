library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- Entidade sem portos
entity Datapath_Tb is
end Datapath_Tb;
architecture Stimulus of Datapath_Tb is
 
 --sinais para ligar as entradas do datapath
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
	
	type t_state is (FETCH0,FETCH1,DECODE,EXECUTE,REG_UPDATE,WRITE_MEM);
	signal state,next_state : t_state;
	constant clk_period : time := 50 ns;
	
begin
 -- Instanciação da datapath
 datapath: entity work.Datapath(Structural)
 
 port map(
			   clk      => s_clk,
				reset    => s_reset,
				EnPc     => s_EnPc,
			   RI       => s_RI,
			   RegWr    => s_RegWr,
				RegDst   => s_RegDst,
				ALUSrc   => s_ALUSrc,
				ALUOp    => s_ALUOp,
				MemWr    => s_MemWr,
				MemtoReg => s_MemtoReg,
				opcode   => s_opcode,
				func     => s_func
				
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
 stim_proc : process(s_clk, s_reset)
 begin
   	

	if (falling_edge(s_clk)) then				
		
		if (s_reset = '1') then			
				s_EnPc     <= '0';    
				s_RI       <= '0'; 
				s_RegWr    <= '0'; 
				s_RegDst   <= '0';  
				s_ALUSrc   <= '0'; 
				s_ALUOp    <= "0000"; 
				s_MemWr    <= '0';
				s_MemtoReg <= '0';								
				next_state <=  FETCH0 ;
				s_reset   <= '0' ;
		else
										
			case state is
								
				when FETCH0 =>              --fetch0 (RI = 1)
					s_EnPc     <= '0';    
					s_RI       <= '1'; 
					s_RegWr    <= '0'; 
					s_RegDst   <= '0';  
					s_ALUSrc   <= '0'; 
					s_ALUOp    <= "0000"; 
					s_MemWr    <= '0';
					s_MemtoReg <= '0';
					next_state <= FETCH1;
						
				when FETCH1 =>              --fetch1 (EnPC=1)
					s_EnPc     <= '1';    
					s_RI       <= '0'; 
					next_state <= DECODE;
					
				when DECODE => -- decode
					s_EnPc <= '0';
					if(s_opcode = "000") then -- Nop irá voltar para fetch (por opcao minha)
						next_state <= FETCH0;
					else 
						next_state <= EXECUTE;
					end if;
					
				when EXECUTE =>
					if(s_opcode = "001") then
					   s_ALUSrc   <= '0';
						s_ALUOp <= s_func; -- vem na instrucao tipo I
						next_state      <= REG_UPDATE;
					elsif(s_opcode = "110") then
						s_ALUSrc   <= '1'; 
						s_ALUOp <= "0000"; --ADD (calculo do endereceo de memoria de dados)
						next_state      <= WRITE_MEM ;
					elsif(s_opcode = "111") then
						s_ALUSrc   <= '1';
						s_ALUOp <= "0000"; --ADD (calculo do endereco a memoria de dados)
						next_state      <= REG_UPDATE ;
					elsif(s_opcode = "100") then
						s_ALUSrc   <= '1';
						s_ALUOp <= "0000"; --ADD (calculo do endereco a memoria de dados)
						next_state      <= REG_UPDATE ;
					else
						next_state      <= FETCH0 ;
						
					end if;
					
				
				when WRITE_MEM =>         -- memory update
					s_MemWr <= '1';
					next_state   <=  FETCH0 ;
					
				when REG_UPDATE =>        -- reg update
					 if(s_opcode = "111") then --LW
						s_MemtoReg <= '1';
						s_RegDst   <= '1';
					 elsif (s_opcode = "100") then --ADDI
						s_RegDst   <= '1'; 
					 end if;
					 
					 
					 s_RegWr <= '1';
					 next_state   <=  FETCH0 ;
					 
				when others =>				
					next_state <= FETCH0;
						
			end case;
		end if;
	else
			state <= next_state;
	end if;
	
end process;
end Stimulus;