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
-- Generated on "05/23/2020 20:08:23"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          Registers
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Registers_vhd_vec_tst IS
END Registers_vhd_vec_tst;
ARCHITECTURE Registers_arch OF Registers_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL RA1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL RA2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL RD1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL RD2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL reset : STD_LOGIC;
SIGNAL WA : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL WD : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL WE : STD_LOGIC;
COMPONENT Registers
	PORT (
	clk : IN STD_LOGIC;
	RA1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	RA2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	RD1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	RD2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	reset : IN STD_LOGIC;
	WA : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	WD : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	WE : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : Registers
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	RA1 => RA1,
	RA2 => RA2,
	RD1 => RD1,
	RD2 => RD2,
	reset => reset,
	WA => WA,
	WD => WD,
	WE => WE
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

-- reset
t_prcs_reset: PROCESS
BEGIN
	reset <= '0';
	WAIT FOR 850000 ps;
	reset <= '1';
	WAIT FOR 20000 ps;
	reset <= '0';
WAIT;
END PROCESS t_prcs_reset;
-- RA1[2]
t_prcs_RA1_2: PROCESS
BEGIN
	RA1(2) <= '0';
	WAIT FOR 400000 ps;
	RA1(2) <= '1';
	WAIT FOR 400000 ps;
	RA1(2) <= '0';
WAIT;
END PROCESS t_prcs_RA1_2;
-- RA1[1]
t_prcs_RA1_1: PROCESS
BEGIN
	FOR i IN 1 TO 2
	LOOP
		RA1(1) <= '0';
		WAIT FOR 200000 ps;
		RA1(1) <= '1';
		WAIT FOR 200000 ps;
	END LOOP;
	RA1(1) <= '0';
WAIT;
END PROCESS t_prcs_RA1_1;
-- RA1[0]
t_prcs_RA1_0: PROCESS
BEGIN
LOOP
	RA1(0) <= '0';
	WAIT FOR 100000 ps;
	RA1(0) <= '1';
	WAIT FOR 100000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_RA1_0;
-- RA2[2]
t_prcs_RA2_2: PROCESS
BEGIN
	RA2(2) <= '0';
	WAIT FOR 300000 ps;
	RA2(2) <= '1';
	WAIT FOR 400000 ps;
	RA2(2) <= '0';
WAIT;
END PROCESS t_prcs_RA2_2;
-- RA2[1]
t_prcs_RA2_1: PROCESS
BEGIN
	RA2(1) <= '0';
	WAIT FOR 100000 ps;
	FOR i IN 1 TO 2
	LOOP
		RA2(1) <= '1';
		WAIT FOR 200000 ps;
		RA2(1) <= '0';
		WAIT FOR 200000 ps;
	END LOOP;
	RA2(1) <= '1';
WAIT;
END PROCESS t_prcs_RA2_1;
-- RA2[0]
t_prcs_RA2_0: PROCESS
BEGIN
LOOP
	RA2(0) <= '1';
	WAIT FOR 100000 ps;
	RA2(0) <= '0';
	WAIT FOR 100000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_RA2_0;

-- WE
t_prcs_WE: PROCESS
BEGIN
	WE <= '1';
	WAIT FOR 60000 ps;
	WE <= '0';
	WAIT FOR 50000 ps;
	WE <= '1';
	WAIT FOR 50000 ps;
	WE <= '0';
	WAIT FOR 50000 ps;
	WE <= '1';
	WAIT FOR 50000 ps;
	WE <= '0';
	WAIT FOR 50000 ps;
	WE <= '1';
	WAIT FOR 570000 ps;
	WE <= '0';
WAIT;
END PROCESS t_prcs_WE;
-- WA[2]
t_prcs_WA_2: PROCESS
BEGIN
	WA(2) <= '1';
	WAIT FOR 300000 ps;
	WA(2) <= '0';
	WAIT FOR 400000 ps;
	WA(2) <= '1';
WAIT;
END PROCESS t_prcs_WA_2;
-- WA[1]
t_prcs_WA_1: PROCESS
BEGIN
	WA(1) <= '0';
	WAIT FOR 100000 ps;
	FOR i IN 1 TO 2
	LOOP
		WA(1) <= '1';
		WAIT FOR 200000 ps;
		WA(1) <= '0';
		WAIT FOR 200000 ps;
	END LOOP;
	WA(1) <= '1';
WAIT;
END PROCESS t_prcs_WA_1;
-- WA[0]
t_prcs_WA_0: PROCESS
BEGIN
LOOP
	WA(0) <= '1';
	WAIT FOR 100000 ps;
	WA(0) <= '0';
	WAIT FOR 100000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_WA_0;
-- WD[7]
t_prcs_WD_7: PROCESS
BEGIN
	WD(7) <= '1';
WAIT;
END PROCESS t_prcs_WD_7;
-- WD[6]
t_prcs_WD_6: PROCESS
BEGIN
	WD(6) <= '0';
WAIT;
END PROCESS t_prcs_WD_6;
-- WD[5]
t_prcs_WD_5: PROCESS
BEGIN
	WD(5) <= '0';
WAIT;
END PROCESS t_prcs_WD_5;
-- WD[4]
t_prcs_WD_4: PROCESS
BEGIN
	WD(4) <= '0';
	WAIT FOR 800000 ps;
	WD(4) <= '1';
WAIT;
END PROCESS t_prcs_WD_4;
-- WD[3]
t_prcs_WD_3: PROCESS
BEGIN
	WD(3) <= '0';
	WAIT FOR 400000 ps;
	WD(3) <= '1';
	WAIT FOR 400000 ps;
	WD(3) <= '0';
WAIT;
END PROCESS t_prcs_WD_3;
-- WD[2]
t_prcs_WD_2: PROCESS
BEGIN
	FOR i IN 1 TO 2
	LOOP
		WD(2) <= '0';
		WAIT FOR 200000 ps;
		WD(2) <= '1';
		WAIT FOR 200000 ps;
	END LOOP;
	WD(2) <= '0';
WAIT;
END PROCESS t_prcs_WD_2;
-- WD[1]
t_prcs_WD_1: PROCESS
BEGIN
LOOP
	WD(1) <= '0';
	WAIT FOR 100000 ps;
	WD(1) <= '1';
	WAIT FOR 100000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_WD_1;
-- WD[0]
t_prcs_WD_0: PROCESS
BEGIN
	WD(0) <= '0';
WAIT;
END PROCESS t_prcs_WD_0;
END Registers_arch;
