library IEEE;
use IEEE.STD_LOGIC_1164.All;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
	--generic( BUS_SIZE : positive := 3 );
	port   ( clk      : in std_logic;
				reset    : in std_logic;
				EnPc     : in std_logic;
			   RI       : in std_logic;
			   RegWr    : in std_logic;
				RegDst   : in std_logic;
				ALUSrc   : in std_logic;
				ALUOp    : in std_logic_vector(3 downto 0);
				MemWr    : in std_logic;
				MemtoReg : in std_logic;
				opcode   : out std_logic_vector(2 downto 0);
				func     : out std_logic_vector(3 downto 0));

end Datapath;

architecture Structural of Datapath is

	signal PC_out          : std_logic_vector(2 downto 0);
	signal IMemory_out     : std_logic_vector(15 downto 0);
	signal SignExtend_out  : std_logic_vector(7 downto 0);
	signal Mux_RegDst_out  : std_logic_vector(2 downto 0);
	signal Register_RD1_out: std_logic_vector(7 downto 0);
	signal Register_RD2_out: std_logic_vector(7 downto 0);
	signal Mux_ALUsrc_out  : std_logic_vector(7 downto 0);
	signal ALU_out         : std_logic_vector(7 downto 0);
	signal DMemory_out     : std_logic_vector(7 downto 0);
	signal Mux_MemToReg_out: std_logic_vector(7 downto 0);
	
begin

	--implementação deste bloco
	
	opcode <= IMemory_out(15 downto 13);
	func   <= IMemory_out( 3 downto  0);

	-- PC
	
	T_PC : entity work.PC(Behavioral)
		generic map( N => 3 )
		port map(
			En  => EnPc,
			clk => clk,
			reset => reset,
			cntOut => PC_out
			);
	
	--IMEMORY
	
	T_IMemory : entity work.IMemory(Behavioral)
	   generic map( N => 3 )
		port map(
			En  => RI,
			clk => clk,
			RA => PC_out,
			RD => IMemory_out
			);
					
	--MUX RegDst
	
	MUX_RegDsT : entity work.pMux2_1(Behavioral)
		generic map( N => 3 )
		port map(
			sel    => RegDst,
			input0 => IMemory_out(6 downto 4),
			input1 => IMemory_out(9 downto 7),
			muxOut => Mux_RegDst_out
			);
					
	--Registers
	
	Registers : entity work.Registers(Behavioral)
		port map(
			clk   => clk, 
			reset => reset,
			RA1   => IMemory_out(12 downto 10),
			RA2   => IMemory_out(9 downto 7),
			WA    => Mux_RegDst_out,
			WD    => Mux_MemToReg_out,
			WE    => RegWr,
			RD1   => Register_RD1_out,
			RD2   => Register_RD2_out				
		);
		
	--SignExtend
	
	SignExtend : entity work.SignExtend(Behavioral)
		port map(
			output => SignExtend_out, 
			input  => IMemory_out(6 downto 0)
		);
		
	--MUX ALUSrc
	
	MUX_ALUSrc : entity work.pMux2_1(Behavioral)
		generic map( N => 8 )
		port map(
			sel    => ALUSrc,
			input0 => Register_RD2_out,
			input1 => SignExtend_out,
			muxOut => Mux_ALUsrc_out
			);
			
	--ALU
	
	ALU : entity work.ALU(Behavioral)
		port map(
			op1  => Register_RD1_out,
			op2  => Mux_ALUsrc_out,
			func => ALUOp,
			res  => ALU_out
			);
	
	--DMemory
	
	DMemory : entity work.DMemory(Behavioral)
		port map(
			clk  => clk,
			WE   => MemWr,
			Addr => ALU_out,
			WD   => Register_RD2_out,
			RD   => DMemory_out
			);
			
			
	--MemtoReg
	
	MUX_MemtoReg : entity work.pMux2_1(Behavioral)
		generic map( N => 8 )
		port map(
			sel    => MemtoReg,
			input0 => ALU_out,
			input1 => DMemory_out,
			muxOut => Mux_MemToReg_out
			);
	

	
end Structural;