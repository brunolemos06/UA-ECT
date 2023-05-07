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
-- Generated on "11/13/2022 16:13:41"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          calc_y
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY calc_y_vhd_vec_tst IS
END calc_y_vhd_vec_tst;
ARCHITECTURE calc_y_arch OF calc_y_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL en : STD_LOGIC;
SIGNAL kx : STD_LOGIC;
SIGNAL mi : STD_LOGIC;
SIGNAL rstGR : STD_LOGIC;
SIGNAL yx : STD_LOGIC;
COMPONENT calc_y
	PORT (
	clk : IN STD_LOGIC;
	en : IN STD_LOGIC;
	kx : IN STD_LOGIC;
	mi : IN STD_LOGIC;
	rstGR : IN STD_LOGIC;
	yx : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : calc_y
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	en => en,
	kx => kx,
	mi => mi,
	rstGR => rstGR,
	yx => yx
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 40000 ps;
	clk <= '1';
	WAIT FOR 40000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- en
t_prcs_en: PROCESS
BEGIN
LOOP
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	en <= '1';
	WAIT FOR 320000 ps;
	en <= '0';
	WAIT FOR 80000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_en;

-- kx
t_prcs_kx: PROCESS
BEGIN
	kx <= '0';
	WAIT FOR 240000 ps;
	kx <= '1';
	WAIT FOR 80000 ps;
	kx <= '0';
	WAIT FOR 80000 ps;
	kx <= '1';
	WAIT FOR 80000 ps;
	kx <= '0';
	WAIT FOR 160000 ps;
	kx <= '1';
	WAIT FOR 80000 ps;
	kx <= '0';
	WAIT FOR 160000 ps;
	kx <= '1';
	WAIT FOR 80000 ps;
	kx <= '0';
	WAIT FOR 80000 ps;
	kx <= '1';
	WAIT FOR 80000 ps;
	kx <= '0';
	WAIT FOR 80000 ps;
	kx <= '1';
	WAIT FOR 140000 ps;
	kx <= '0';
	WAIT FOR 100000 ps;
	kx <= '1';
	WAIT FOR 80000 ps;
	kx <= '0';
	WAIT FOR 240000 ps;
	kx <= '1';
	WAIT FOR 160000 ps;
	kx <= '0';
	WAIT FOR 80000 ps;
	kx <= '1';
	WAIT FOR 80000 ps;
	kx <= '0';
	WAIT FOR 80000 ps;
	kx <= '1';
	WAIT FOR 160000 ps;
	kx <= '0';
	WAIT FOR 160000 ps;
	kx <= '1';
	WAIT FOR 240000 ps;
	kx <= '0';
	WAIT FOR 80000 ps;
	kx <= '1';
	WAIT FOR 320000 ps;
	kx <= '0';
WAIT;
END PROCESS t_prcs_kx;

-- mi
t_prcs_mi: PROCESS
BEGIN
LOOP
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	mi <= '1';
	WAIT FOR 320000 ps;
	mi <= '0';
	WAIT FOR 80000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_mi;

-- rstGR
t_prcs_rstGR: PROCESS
BEGIN
LOOP
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	rstGR <= '0';
	WAIT FOR 320000 ps;
	rstGR <= '1';
	WAIT FOR 80000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_rstGR;
END calc_y_arch;
