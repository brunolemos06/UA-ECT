-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "05/25/2020 22:13:20"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          ControlUnit
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ControlUnit_vhd_vec_tst IS
END ControlUnit_vhd_vec_tst;
ARCHITECTURE ControlUnit_arch OF ControlUnit_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL ALUOp : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ALUSrc : STD_LOGIC;
SIGNAL clk : STD_LOGIC;
SIGNAL EnPc : STD_LOGIC;
SIGNAL func : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL MemtoReg : STD_LOGIC;
SIGNAL MemWr : STD_LOGIC;
SIGNAL opcode : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL RegDst : STD_LOGIC;
SIGNAL RegWr : STD_LOGIC;
SIGNAL RI : STD_LOGIC;
SIGNAL rst : STD_LOGIC;
COMPONENT ControlUnit
	PORT (
	ALUOp : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	ALUSrc : OUT STD_LOGIC;
	clk : IN STD_LOGIC;
	EnPc : OUT STD_LOGIC;
	func : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	MemtoReg : OUT STD_LOGIC;
	MemWr : OUT STD_LOGIC;
	opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	RegDst : OUT STD_LOGIC;
	RegWr : OUT STD_LOGIC;
	RI : OUT STD_LOGIC;
	rst : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : ControlUnit
	PORT MAP (
-- list connections between master ports and signals
	ALUOp => ALUOp,
	ALUSrc => ALUSrc,
	clk => clk,
	EnPc => EnPc,
	func => func,
	MemtoReg => MemtoReg,
	MemWr => MemWr,
	opcode => opcode,
	RegDst => RegDst,
	RegWr => RegWr,
	RI => RI,
	rst => rst
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 25000 ps;
	clk <= '1';
	WAIT FOR 25000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- rst
t_prcs_rst: PROCESS
BEGIN
	rst <= '0';
	WAIT FOR 20000 ps;
	rst <= '1';
	WAIT FOR 80000 ps;
	rst <= '0';
	WAIT FOR 470000 ps;
	rst <= '1';
	WAIT FOR 60000 ps;
	rst <= '0';
WAIT;
END PROCESS t_prcs_rst;
-- opcode[2]
t_prcs_opcode_2: PROCESS
BEGIN
	opcode(2) <= '0';
WAIT;
END PROCESS t_prcs_opcode_2;
-- opcode[1]
t_prcs_opcode_1: PROCESS
BEGIN
	opcode(1) <= '0';
WAIT;
END PROCESS t_prcs_opcode_1;
-- opcode[0]
t_prcs_opcode_0: PROCESS
BEGIN
	opcode(0) <= '1';
WAIT;
END PROCESS t_prcs_opcode_0;
-- func[3]
t_prcs_func_3: PROCESS
BEGIN
	func(3) <= '0';
WAIT;
END PROCESS t_prcs_func_3;
-- func[2]
t_prcs_func_2: PROCESS
BEGIN
	func(2) <= '0';
WAIT;
END PROCESS t_prcs_func_2;
-- func[1]
t_prcs_func_1: PROCESS
BEGIN
	func(1) <= '1';
WAIT;
END PROCESS t_prcs_func_1;
-- func[0]
t_prcs_func_0: PROCESS
BEGIN
	func(0) <= '0';
WAIT;
END PROCESS t_prcs_func_0;
END ControlUnit_arch;
