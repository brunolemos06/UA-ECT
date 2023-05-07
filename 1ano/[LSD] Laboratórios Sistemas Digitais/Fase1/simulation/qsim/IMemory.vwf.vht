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
-- Generated on "05/23/2020 18:59:06"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          IMemory
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY IMemory_vhd_vec_tst IS
END IMemory_vhd_vec_tst;
ARCHITECTURE IMemory_arch OF IMemory_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL En : STD_LOGIC;
SIGNAL RA : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL RD : STD_LOGIC_VECTOR(15 DOWNTO 0);
COMPONENT IMemory
	PORT (
	clk : IN STD_LOGIC;
	En : IN STD_LOGIC;
	RA : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	RD : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : IMemory
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	En => En,
	RA => RA,
	RD => RD
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 12500 ps;
	clk <= '1';
	WAIT FOR 12500 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- En
t_prcs_En: PROCESS
BEGIN
	En <= '1';
	WAIT FOR 320000 ps;
	En <= '0';
	WAIT FOR 120000 ps;
	En <= '1';
	WAIT FOR 50000 ps;
	FOR i IN 1 TO 4
	LOOP
		En <= '0';
		WAIT FOR 50000 ps;
		En <= '1';
		WAIT FOR 50000 ps;
	END LOOP;
	En <= '0';
WAIT;
END PROCESS t_prcs_En;
-- RA[2]
t_prcs_RA_2: PROCESS
BEGIN
	RA(2) <= '0';
	WAIT FOR 480000 ps;
	RA(2) <= '1';
	WAIT FOR 480000 ps;
	RA(2) <= '0';
WAIT;
END PROCESS t_prcs_RA_2;
-- RA[1]
t_prcs_RA_1: PROCESS
BEGIN
	FOR i IN 1 TO 2
	LOOP
		RA(1) <= '0';
		WAIT FOR 240000 ps;
		RA(1) <= '1';
		WAIT FOR 240000 ps;
	END LOOP;
	RA(1) <= '0';
WAIT;
END PROCESS t_prcs_RA_1;
-- RA[0]
t_prcs_RA_0: PROCESS
BEGIN
	FOR i IN 1 TO 4
	LOOP
		RA(0) <= '0';
		WAIT FOR 120000 ps;
		RA(0) <= '1';
		WAIT FOR 120000 ps;
	END LOOP;
	RA(0) <= '0';
WAIT;
END PROCESS t_prcs_RA_0;
END IMemory_arch;
