-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "11/13/2022 16:22:44"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          counter_3bit
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY counter_3bit_vhd_vec_tst IS
END counter_3bit_vhd_vec_tst;
ARCHITECTURE counter_3bit_arch OF counter_3bit_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL count : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL rstGr : STD_LOGIC;
COMPONENT counter_3bit
	PORT (
	clk : IN STD_LOGIC;
	count : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	rstGr : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : counter_3bit
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	count => count,
	rstGr => rstGr
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
	FOR i IN 1 TO 12
	LOOP
		clk <= '0';
		WAIT FOR 40000 ps;
		clk <= '1';
		WAIT FOR 40000 ps;
	END LOOP;
	clk <= '0';
WAIT;
END PROCESS t_prcs_clk;

-- rstGr
t_prcs_rstGr: PROCESS
BEGIN
	rstGr <= '0';
	WAIT FOR 400000 ps;
	rstGr <= '1';
	WAIT FOR 80000 ps;
	rstGr <= '0';
WAIT;
END PROCESS t_prcs_rstGr;
END counter_3bit_arch;
