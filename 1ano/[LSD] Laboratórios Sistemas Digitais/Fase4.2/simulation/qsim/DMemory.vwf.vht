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
-- Generated on "05/23/2020 19:22:42"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          DMemory
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY DMemory_vhd_vec_tst IS
END DMemory_vhd_vec_tst;
ARCHITECTURE DMemory_arch OF DMemory_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL Addr : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL clk : STD_LOGIC;
SIGNAL RD : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL WD : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL WE : STD_LOGIC;
COMPONENT DMemory
	PORT (
	Addr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	clk : IN STD_LOGIC;
	RD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	WD : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	WE : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : DMemory
	PORT MAP (
-- list connections between master ports and signals
	Addr => Addr,
	clk => clk,
	RD => RD,
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
-- Addr[7]
t_prcs_Addr_7: PROCESS
BEGIN
	Addr(7) <= '0';
	WAIT FOR 30000 ps;
	Addr(7) <= '1';
	WAIT FOR 180000 ps;
	Addr(7) <= '0';
	WAIT FOR 190000 ps;
	Addr(7) <= '1';
	WAIT FOR 420000 ps;
	Addr(7) <= '0';
WAIT;
END PROCESS t_prcs_Addr_7;
-- Addr[6]
t_prcs_Addr_6: PROCESS
BEGIN
	Addr(6) <= '0';
	WAIT FOR 80000 ps;
	Addr(6) <= '1';
	WAIT FOR 130000 ps;
	Addr(6) <= '0';
	WAIT FOR 190000 ps;
	Addr(6) <= '1';
	WAIT FOR 270000 ps;
	Addr(6) <= '0';
WAIT;
END PROCESS t_prcs_Addr_6;
-- Addr[5]
t_prcs_Addr_5: PROCESS
BEGIN
	Addr(5) <= '0';
	WAIT FOR 80000 ps;
	Addr(5) <= '1';
	WAIT FOR 130000 ps;
	Addr(5) <= '0';
	WAIT FOR 190000 ps;
	Addr(5) <= '1';
	WAIT FOR 270000 ps;
	Addr(5) <= '0';
WAIT;
END PROCESS t_prcs_Addr_5;
-- Addr[4]
t_prcs_Addr_4: PROCESS
BEGIN
	Addr(4) <= '0';
	WAIT FOR 80000 ps;
	Addr(4) <= '1';
	WAIT FOR 130000 ps;
	Addr(4) <= '0';
	WAIT FOR 190000 ps;
	Addr(4) <= '1';
	WAIT FOR 270000 ps;
	Addr(4) <= '0';
WAIT;
END PROCESS t_prcs_Addr_4;
-- Addr[3]
t_prcs_Addr_3: PROCESS
BEGIN
	Addr(3) <= '0';
	WAIT FOR 80000 ps;
	Addr(3) <= '1';
	WAIT FOR 130000 ps;
	Addr(3) <= '0';
	WAIT FOR 190000 ps;
	Addr(3) <= '1';
	WAIT FOR 270000 ps;
	Addr(3) <= '0';
WAIT;
END PROCESS t_prcs_Addr_3;
-- Addr[2]
t_prcs_Addr_2: PROCESS
BEGIN
	Addr(2) <= '0';
	WAIT FOR 80000 ps;
	Addr(2) <= '1';
	WAIT FOR 130000 ps;
	Addr(2) <= '0';
	WAIT FOR 190000 ps;
	Addr(2) <= '1';
	WAIT FOR 270000 ps;
	Addr(2) <= '0';
WAIT;
END PROCESS t_prcs_Addr_2;
-- Addr[1]
t_prcs_Addr_1: PROCESS
BEGIN
	Addr(1) <= '0';
	WAIT FOR 80000 ps;
	Addr(1) <= '1';
	WAIT FOR 130000 ps;
	Addr(1) <= '0';
	WAIT FOR 190000 ps;
	Addr(1) <= '1';
	WAIT FOR 270000 ps;
	Addr(1) <= '0';
WAIT;
END PROCESS t_prcs_Addr_1;
-- Addr[0]
t_prcs_Addr_0: PROCESS
BEGIN
	Addr(0) <= '0';
	WAIT FOR 80000 ps;
	Addr(0) <= '1';
	WAIT FOR 130000 ps;
	Addr(0) <= '0';
	WAIT FOR 190000 ps;
	Addr(0) <= '1';
	WAIT FOR 270000 ps;
	Addr(0) <= '0';
	WAIT FOR 150000 ps;
	Addr(0) <= '1';
WAIT;
END PROCESS t_prcs_Addr_0;
-- WD[7]
t_prcs_WD_7: PROCESS
BEGIN
	WD(7) <= '1';
	WAIT FOR 30000 ps;
	WD(7) <= '0';
WAIT;
END PROCESS t_prcs_WD_7;
-- WD[6]
t_prcs_WD_6: PROCESS
BEGIN
	WD(6) <= '1';
	WAIT FOR 80000 ps;
	WD(6) <= '0';
WAIT;
END PROCESS t_prcs_WD_6;
-- WD[5]
t_prcs_WD_5: PROCESS
BEGIN
	WD(5) <= '1';
	WAIT FOR 30000 ps;
	WD(5) <= '0';
	WAIT FOR 50000 ps;
	WD(5) <= '1';
	WAIT FOR 130000 ps;
	WD(5) <= '0';
WAIT;
END PROCESS t_prcs_WD_5;
-- WD[4]
t_prcs_WD_4: PROCESS
BEGIN
	WD(4) <= '1';
	WAIT FOR 210000 ps;
	WD(4) <= '0';
WAIT;
END PROCESS t_prcs_WD_4;
-- WD[3]
t_prcs_WD_3: PROCESS
BEGIN
	WD(3) <= '1';
	WAIT FOR 30000 ps;
	WD(3) <= '0';
	WAIT FOR 50000 ps;
	WD(3) <= '1';
	WAIT FOR 130000 ps;
	WD(3) <= '0';
WAIT;
END PROCESS t_prcs_WD_3;
-- WD[2]
t_prcs_WD_2: PROCESS
BEGIN
	WD(2) <= '1';
	WAIT FOR 30000 ps;
	WD(2) <= '0';
WAIT;
END PROCESS t_prcs_WD_2;
-- WD[1]
t_prcs_WD_1: PROCESS
BEGIN
	WD(1) <= '1';
	WAIT FOR 30000 ps;
	WD(1) <= '0';
WAIT;
END PROCESS t_prcs_WD_1;
-- WD[0]
t_prcs_WD_0: PROCESS
BEGIN
	WD(0) <= '1';
	WAIT FOR 30000 ps;
	WD(0) <= '0';
WAIT;
END PROCESS t_prcs_WD_0;

-- WE
t_prcs_WE: PROCESS
BEGIN
	WE <= '1';
	WAIT FOR 20000 ps;
	WE <= '0';
	WAIT FOR 20000 ps;
	WE <= '1';
	WAIT FOR 30000 ps;
	WE <= '0';
	WAIT FOR 110000 ps;
	WE <= '1';
	WAIT FOR 30000 ps;
	WE <= '0';
WAIT;
END PROCESS t_prcs_WE;
END DMemory_arch;
