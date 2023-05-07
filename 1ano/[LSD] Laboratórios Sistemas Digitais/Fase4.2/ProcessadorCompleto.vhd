library IEEE;
use IEEE.STD_LOGIC_1164.All;
use IEEE.NUMERIC_STD.ALL;

entity ProcessadorCompleto is
	
	port   ( clk      : in std_logic;
				reset    : in std_logic);

end ProcessadorCompleto;

architecture Structural of ProcessadorCompleto is

	signal s_EnPc     : std_logic;
	signal s_RI       : std_logic;
	signal s_RegWr    : std_logic;
	signal s_RegDst   : std_logic;
	signal s_ALUSrc   : std_logic;
	signal s_ALUOp    : std_logic_vector(3 downto 0);
	signal s_MemWr    : std_logic;
	signal s_MemtoReg : std_logic;
	signal s_EnPCOff  : std_logic;
	signal s_opcode   : std_logic_vector(2 downto 0);
	signal s_func     : std_logic_vector(3 downto 0);
	
	
begin

F_datapath : entity work.DataPath(Structural)
		generic map( BUS_SIZE => 4 )
		port map(
			clk      =>  clk,
			reset    =>  reset,
			EnPc     =>  s_EnPc,  
			RI       =>  s_RI,      
			RegWr    =>  s_RegWr,
			RegDst   =>  s_RegDst,
			ALUSrc   =>  s_ALUSrc,
			ALUOP    =>  s_ALUOp,
			MemWr    =>  s_MemWr,
			MemtoReg => s_MemtoReg,
			EnPCOff  => s_EnPCOff,
			opcode   => s_opcode,
			func     => s_func
			);

F_ControlUnit : entity work.ControlUnit(Behavioral)
		port map(
			clk      =>  clk,
			rst      =>  reset,
			EnPc     =>  s_EnPc,  
			RI       =>  s_RI,      
			RegWr    =>  s_RegWr,
			RegDst   =>  s_RegDst,
			ALUSrc   =>  s_ALUSrc,
			ALUOP    =>  s_ALUOp,
			MemWr    =>  s_MemWr,
			MemtoReg =>  s_MemtoReg,
			EnPCOff  =>  s_EnPCOff,
			opcode   =>  s_opcode,
			func     =>  s_func
			);			

			
end Structural;