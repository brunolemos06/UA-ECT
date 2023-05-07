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
-- Generated on "11/13/2022 16:18:09"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          control_unit
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY control_unit_vhd_vec_tst IS
END control_unit_vhd_vec_tst;
ARCHITECTURE control_unit_arch OF control_unit_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL kx : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL rstGR : STD_LOGIC;
COMPONENT control_unit
	PORT (
	clk : IN STD_LOGIC;
	kx : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
	rstGR : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : control_unit
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	kx => kx,
	rstGR => rstGR
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
	FOR i IN 1 TO 12
	LOOP
		clk <= '0';
		WAIT FOR 80000 ps;
		clk <= '1';
		WAIT FOR 80000 ps;
	END LOOP;
	clk <= '0';
WAIT;
END PROCESS t_prcs_clk;

-- rstGR
t_prcs_rstGR: PROCESS
BEGIN
	rstGR <= '0';
	WAIT FOR 1440000 ps;
	rstGR <= '1';
	WAIT FOR 160000 ps;
	rstGR <= '0';
WAIT;
END PROCESS t_prcs_rstGR;
END control_unit_arch;
