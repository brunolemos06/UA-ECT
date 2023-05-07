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
-- Generated on "11/16/2022 10:13:45"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          serial_encoder
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY serial_encoder_vhd_vec_tst IS
END serial_encoder_vhd_vec_tst;
ARCHITECTURE serial_encoder_arch OF serial_encoder_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL m : STD_LOGIC;
SIGNAL rstGr : STD_LOGIC;
SIGNAL Y : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT serial_encoder
	PORT (
	clk : IN STD_LOGIC;
	m : IN STD_LOGIC;
	rstGr : IN STD_LOGIC;
	Y : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : serial_encoder
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	m => m,
	rstGr => rstGr,
	Y => Y
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 40000 ps;
	clk <= '1';
	WAIT FOR 40000 ps;
	IF (NOW >= 10000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- m
t_prcs_m: PROCESS
BEGIN
	m <= '0';
	WAIT FOR 180000 ps;
	m <= '1';
	WAIT FOR 50000 ps;
	m <= '0';
	WAIT FOR 120000 ps;
	m <= '1';
	WAIT FOR 30000 ps;
	m <= '0';
	WAIT FOR 300000 ps;
	m <= '1';
	WAIT FOR 80000 ps;
	m <= '0';
	WAIT FOR 320000 ps;
	m <= '1';
	WAIT FOR 80000 ps;
	m <= '0';
	WAIT FOR 200000 ps;
	m <= '1';
	WAIT FOR 200000 ps;
	m <= '0';
	WAIT FOR 80000 ps;
	m <= '1';
	WAIT FOR 320000 ps;
	m <= '0';
	WAIT FOR 160000 ps;
	m <= '1';
	WAIT FOR 320000 ps;
	m <= '0';
	WAIT FOR 80000 ps;
	m <= '1';
	WAIT FOR 80000 ps;
	m <= '0';
	WAIT FOR 160000 ps;
	m <= '1';
	WAIT FOR 80000 ps;
	m <= '0';
WAIT;
END PROCESS t_prcs_m;

-- rstGr
t_prcs_rstGr: PROCESS
BEGIN
	rstGr <= '1';
	WAIT FOR 60000 ps;
	rstGr <= '0';
	WAIT FOR 1660000 ps;
	rstGr <= '1';
	WAIT FOR 80000 ps;
	rstGr <= '0';
WAIT;
END PROCESS t_prcs_rstGr;
END serial_encoder_arch;
