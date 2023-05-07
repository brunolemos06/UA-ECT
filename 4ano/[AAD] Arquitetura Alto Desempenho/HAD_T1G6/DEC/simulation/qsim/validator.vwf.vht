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
-- Generated on "11/13/2022 17:20:56"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          validator
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY validator_vhd_vec_tst IS
END validator_vhd_vec_tst;
ARCHITECTURE validator_arch OF validator_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL m : STD_LOGIC;
SIGNAL v : STD_LOGIC;
SIGNAL x : STD_LOGIC_VECTOR(3 DOWNTO 0);
COMPONENT validator
	PORT (
	m : OUT STD_LOGIC;
	v : OUT STD_LOGIC;
	x : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : validator
	PORT MAP (
-- list connections between master ports and signals
	m => m,
	v => v,
	x => x
	);
-- x[3]
t_prcs_x_3: PROCESS
BEGIN
	FOR i IN 1 TO 62
	LOOP
		x(3) <= '0';
		WAIT FOR 8000 ps;
		x(3) <= '1';
		WAIT FOR 8000 ps;
	END LOOP;
	x(3) <= '0';
WAIT;
END PROCESS t_prcs_x_3;
-- x[2]
t_prcs_x_2: PROCESS
BEGIN
	FOR i IN 1 TO 31
	LOOP
		x(2) <= '0';
		WAIT FOR 16000 ps;
		x(2) <= '1';
		WAIT FOR 16000 ps;
	END LOOP;
	x(2) <= '0';
WAIT;
END PROCESS t_prcs_x_2;
-- x[1]
t_prcs_x_1: PROCESS
BEGIN
	FOR i IN 1 TO 15
	LOOP
		x(1) <= '0';
		WAIT FOR 32000 ps;
		x(1) <= '1';
		WAIT FOR 32000 ps;
	END LOOP;
	x(1) <= '0';
	WAIT FOR 32000 ps;
	x(1) <= '1';
WAIT;
END PROCESS t_prcs_x_1;
-- x[0]
t_prcs_x_0: PROCESS
BEGIN
	FOR i IN 1 TO 7
	LOOP
		x(0) <= '0';
		WAIT FOR 64000 ps;
		x(0) <= '1';
		WAIT FOR 64000 ps;
	END LOOP;
	x(0) <= '0';
	WAIT FOR 64000 ps;
	x(0) <= '1';
WAIT;
END PROCESS t_prcs_x_0;
END validator_arch;
