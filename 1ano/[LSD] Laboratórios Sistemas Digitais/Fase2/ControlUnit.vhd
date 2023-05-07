Library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ControlUnit is

port( 
		clk      : in std_logic;
		rst      : in std_logic;
		opcode   : in std_logic_vector(2 downto 0);
		func     : in std_logic_vector(3 downto 0);
		EnPc     : out std_logic;
		RI       : out std_logic;
		RegWr    : out std_logic;
		RegDst   : out std_logic;
		ALUSrc   : out std_logic;
		ALUOp    : out std_logic_vector(3 downto 0);
		MemWr    : out std_logic;
		MemtoReg : out std_logic;
		EnPCOff  : out std_logic
		);
		
end ControlUnit;



architecture Behavioral of ControlUnit is
	type t_state is (RESET,FETCH0,FETCH1,DECODE,EXECUTE,REG_UPDATE,WRITE_MEM,PC_BRANCH);
	signal state,next_state : t_state; 
	
begin

	sync_proc : process (clk)
	begin	
		if(rising_edge(clk)) then
			if(rst ='1') then
				state <= RESET;
			else
				state <= next_state;
			end if;
		end if;
	end process;
	

	-- Processo que implementa a maquina de estados da unidade de controlo
	-- Uma vez que todos os blocos que utilizam o clk estao sincronizados 
	-- o rising edge, esta maquina vai mudar os sinais no falling para os blocos 
	-- apanhem os sinais estáveis.
	control_proc :	process(clk)
	begin
		if(falling_edge(clk)) then
		
			case state is
				
				when RESET =>                --reset
					EnPc     <= '0';    
					RI       <= '0'; 
					RegWr    <= '0'; 
					RegDst   <= '0';  
					ALUSrc   <= '0'; 
					ALUOp    <= "0000"; 
					MemWr    <= '0';
					MemtoReg <= '0';
					EnPCOff  <= '0';
					next_state <= FETCH0;
			
				-- FETCH STATE 				
				-- Este estado foi dividido em 2 para nao acertar o
				-- RI e o PC ao mesmo tempo
				when FETCH0 =>              --fetch0 (RI = 1)
					EnPc     <= '0';    
					RI       <= '1'; 
					RegWr    <= '0'; 
					RegDst   <= '0';  
					ALUSrc   <= '0'; 
					ALUOp    <= "0000"; 
					MemWr    <= '0';
					MemtoReg <= '0';
					EnPCOff  <= '0';
					next_state <= FETCH1;
						
				when FETCH1 =>              --fetch1 (EnPC=1)
					EnPc     <= '1';    
					RI       <= '0'; 
					next_state <= DECODE;
					
				when DECODE =>             -- decode
						EnPc     <= '0';
					if(opcode = "000") then  -- NOP  												
						next_state      <=  FETCH0 ;
					else
						next_state      <=  EXECUTE;						
					end if;
					
				when EXECUTE =>
					if(opcode = "001") then
					   ALUSrc   <= '0';
						ALUOp <= func; -- vem na instrucao tipo I
						next_state      <= REG_UPDATE;
					elsif(opcode = "110") then
						ALUSrc   <= '1'; 
						ALUOp <= "0000"; --ADD (calculo do endereceo de memoria de dados)
						next_state      <= WRITE_MEM ;
					elsif(opcode = "111") then
						ALUSrc   <= '1';
						ALUOp <= "0000"; --ADD (calculo do endereco a memoria de dados)
						next_state      <= REG_UPDATE ;
					elsif(opcode = "100") then
						ALUSrc   <= '1';
						ALUOp <= "0000"; --ADD (calculo do endereco a memoria de dados)
						next_state      <= REG_UPDATE ;
					elsif(opcode = "010") then -- BEQ
						ALUOp <= "1011";  --EQ (op1 == op2)
						next_state <= PC_BRANCH;
					else
						next_state      <= FETCH0 ;
						
					end if;
					
				
				when WRITE_MEM =>         -- memory update
					MemWr <= '1';
					next_state   <=  FETCH0 ;
					
				when REG_UPDATE =>         -- reg update
					 if(opcode = "111") then --LW
						MemtoReg <= '1';
						RegDst   <= '1';
					 elsif(opcode ="100") then --ADDI
						RegDst   <= '1';
					 end if;
					 
					 RegWr <= '1';
					 next_state   <=  FETCH0 ;
					 
				when PC_BRANCH =>	
					EnPCOff <= '1';
					EnPC    <= '1';
					next_state <= FETCH0;
					 
				when others =>				
					next_state <= RESET;
			end case;
		end if;		
	end process;
			

end Behavioral;