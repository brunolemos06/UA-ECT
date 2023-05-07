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
-- Generated on "05/23/2020 21:45:59"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          ALU
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY ALU_vhd_vec_tst IS
END ALU_vhd_vec_tst;
ARCHITECTURE ALU_arch OF ALU_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL func : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL op1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL op2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL res : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT ALU
	PORT (
	func : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	op1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	op2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	res : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : ALU
	PORT MAP (
-- list connections between master ports and signals
	func => func,
	op1 => op1,
	op2 => op2,
	res => res
	);
-- op1[7]
t_prcs_op1_7: PROCESS
BEGIN
	op1(7) <= '1';
	WAIT FOR 30000 ps;
	op1(7) <= '0';
	WAIT FOR 180000 ps;
	op1(7) <= '1';
	WAIT FOR 30000 ps;
	op1(7) <= '0';
	WAIT FOR 30000 ps;
	op1(7) <= '1';
	WAIT FOR 30000 ps;
	op1(7) <= '0';
	WAIT FOR 30000 ps;
	op1(7) <= '1';
	WAIT FOR 10000 ps;
	op1(7) <= '0';
	WAIT FOR 20000 ps;
	op1(7) <= '1';
	WAIT FOR 300000 ps;
	op1(7) <= '0';
	WAIT FOR 60000 ps;
	op1(7) <= '1';
	WAIT FOR 30000 ps;
	op1(7) <= '0';
	WAIT FOR 30000 ps;
	op1(7) <= '1';
	WAIT FOR 30000 ps;
	op1(7) <= '0';
	WAIT FOR 30000 ps;
	op1(7) <= '1';
	WAIT FOR 30000 ps;
	op1(7) <= '0';
	WAIT FOR 30000 ps;
	op1(7) <= '1';
	WAIT FOR 30000 ps;
	op1(7) <= '0';
WAIT;
END PROCESS t_prcs_op1_7;
-- op1[6]
t_prcs_op1_6: PROCESS
BEGIN
	op1(6) <= '1';
	WAIT FOR 30000 ps;
	op1(6) <= '0';
	WAIT FOR 120000 ps;
	op1(6) <= '1';
	WAIT FOR 30000 ps;
	op1(6) <= '0';
	WAIT FOR 60000 ps;
	op1(6) <= '1';
	WAIT FOR 30000 ps;
	op1(6) <= '0';
	WAIT FOR 70000 ps;
	op1(6) <= '1';
	WAIT FOR 20000 ps;
	op1(6) <= '0';
WAIT;
END PROCESS t_prcs_op1_6;
-- op1[5]
t_prcs_op1_5: PROCESS
BEGIN
	op1(5) <= '1';
	WAIT FOR 30000 ps;
	op1(5) <= '0';
	WAIT FOR 240000 ps;
	op1(5) <= '1';
	WAIT FOR 30000 ps;
	op1(5) <= '0';
WAIT;
END PROCESS t_prcs_op1_5;
-- op1[4]
t_prcs_op1_4: PROCESS
BEGIN
	op1(4) <= '1';
	WAIT FOR 30000 ps;
	op1(4) <= '0';
	WAIT FOR 90000 ps;
	op1(4) <= '1';
	WAIT FOR 60000 ps;
	op1(4) <= '0';
	WAIT FOR 60000 ps;
	op1(4) <= '1';
	WAIT FOR 30000 ps;
	op1(4) <= '0';
	WAIT FOR 60000 ps;
	op1(4) <= '1';
	WAIT FOR 10000 ps;
	op1(4) <= '0';
	WAIT FOR 350000 ps;
	op1(4) <= '1';
	WAIT FOR 30000 ps;
	op1(4) <= '0';
WAIT;
END PROCESS t_prcs_op1_4;
-- op1[3]
t_prcs_op1_3: PROCESS
BEGIN
	op1(3) <= '0';
	WAIT FOR 60000 ps;
	op1(3) <= '1';
	WAIT FOR 30000 ps;
	op1(3) <= '0';
	WAIT FOR 180000 ps;
	op1(3) <= '1';
	WAIT FOR 60000 ps;
	op1(3) <= '0';
	WAIT FOR 10000 ps;
	op1(3) <= '1';
	WAIT FOR 20000 ps;
	op1(3) <= '0';
	WAIT FOR 120000 ps;
	op1(3) <= '1';
	WAIT FOR 180000 ps;
	op1(3) <= '0';
	WAIT FOR 30000 ps;
	op1(3) <= '1';
	WAIT FOR 60000 ps;
	op1(3) <= '0';
	WAIT FOR 30000 ps;
	op1(3) <= '1';
	WAIT FOR 30000 ps;
	op1(3) <= '0';
	WAIT FOR 30000 ps;
	op1(3) <= '1';
	WAIT FOR 30000 ps;
	op1(3) <= '0';
	WAIT FOR 30000 ps;
	op1(3) <= '1';
	WAIT FOR 30000 ps;
	op1(3) <= '0';
WAIT;
END PROCESS t_prcs_op1_3;
-- op1[2]
t_prcs_op1_2: PROCESS
BEGIN
	op1(2) <= '0';
	WAIT FOR 90000 ps;
	op1(2) <= '1';
	WAIT FOR 120000 ps;
	op1(2) <= '0';
	WAIT FOR 30000 ps;
	op1(2) <= '1';
	WAIT FOR 90000 ps;
	op1(2) <= '0';
	WAIT FOR 360000 ps;
	op1(2) <= '1';
	WAIT FOR 30000 ps;
	op1(2) <= '0';
	WAIT FOR 30000 ps;
	op1(2) <= '1';
	WAIT FOR 30000 ps;
	op1(2) <= '0';
	WAIT FOR 30000 ps;
	op1(2) <= '1';
	WAIT FOR 30000 ps;
	op1(2) <= '0';
	WAIT FOR 30000 ps;
	op1(2) <= '1';
	WAIT FOR 30000 ps;
	op1(2) <= '0';
	WAIT FOR 30000 ps;
	op1(2) <= '1';
	WAIT FOR 30000 ps;
	op1(2) <= '0';
WAIT;
END PROCESS t_prcs_op1_2;
-- op1[1]
t_prcs_op1_1: PROCESS
BEGIN
	op1(1) <= '0';
	WAIT FOR 30000 ps;
	op1(1) <= '1';
	WAIT FOR 60000 ps;
	op1(1) <= '0';
	WAIT FOR 90000 ps;
	op1(1) <= '1';
	WAIT FOR 30000 ps;
	op1(1) <= '0';
	WAIT FOR 60000 ps;
	op1(1) <= '1';
	WAIT FOR 60000 ps;
	op1(1) <= '0';
	WAIT FOR 330000 ps;
	op1(1) <= '1';
	WAIT FOR 60000 ps;
	op1(1) <= '0';
	WAIT FOR 30000 ps;
	op1(1) <= '1';
	WAIT FOR 30000 ps;
	op1(1) <= '0';
	WAIT FOR 30000 ps;
	op1(1) <= '1';
	WAIT FOR 30000 ps;
	op1(1) <= '0';
	WAIT FOR 30000 ps;
	op1(1) <= '1';
	WAIT FOR 30000 ps;
	op1(1) <= '0';
	WAIT FOR 30000 ps;
	op1(1) <= '1';
	WAIT FOR 30000 ps;
	op1(1) <= '0';
WAIT;
END PROCESS t_prcs_op1_1;
-- op1[0]
t_prcs_op1_0: PROCESS
BEGIN
	op1(0) <= '0';
	WAIT FOR 30000 ps;
	op1(0) <= '1';
	WAIT FOR 30000 ps;
	op1(0) <= '0';
	WAIT FOR 30000 ps;
	op1(0) <= '1';
	WAIT FOR 120000 ps;
	op1(0) <= '0';
	WAIT FOR 30000 ps;
	op1(0) <= '1';
	WAIT FOR 90000 ps;
	op1(0) <= '0';
	WAIT FOR 330000 ps;
	op1(0) <= '1';
	WAIT FOR 60000 ps;
	op1(0) <= '0';
	WAIT FOR 30000 ps;
	op1(0) <= '1';
	WAIT FOR 30000 ps;
	op1(0) <= '0';
	WAIT FOR 30000 ps;
	op1(0) <= '1';
	WAIT FOR 30000 ps;
	op1(0) <= '0';
	WAIT FOR 30000 ps;
	op1(0) <= '1';
	WAIT FOR 30000 ps;
	op1(0) <= '0';
	WAIT FOR 30000 ps;
	op1(0) <= '1';
	WAIT FOR 30000 ps;
	op1(0) <= '0';
WAIT;
END PROCESS t_prcs_op1_0;
-- op2[7]
t_prcs_op2_7: PROCESS
BEGIN
	op2(7) <= '0';
	WAIT FOR 120000 ps;
	op2(7) <= '1';
	WAIT FOR 30000 ps;
	op2(7) <= '0';
	WAIT FOR 90000 ps;
	op2(7) <= '1';
	WAIT FOR 60000 ps;
	op2(7) <= '0';
	WAIT FOR 60000 ps;
	op2(7) <= '1';
	WAIT FOR 120000 ps;
	op2(7) <= '0';
	WAIT FOR 150000 ps;
	op2(7) <= '1';
	WAIT FOR 30000 ps;
	op2(7) <= '0';
	WAIT FOR 90000 ps;
	op2(7) <= '1';
	WAIT FOR 30000 ps;
	op2(7) <= '0';
	WAIT FOR 30000 ps;
	op2(7) <= '1';
	WAIT FOR 30000 ps;
	op2(7) <= '0';
	WAIT FOR 30000 ps;
	op2(7) <= '1';
	WAIT FOR 30000 ps;
	op2(7) <= '0';
	WAIT FOR 30000 ps;
	op2(7) <= '1';
	WAIT FOR 30000 ps;
	op2(7) <= '0';
WAIT;
END PROCESS t_prcs_op2_7;
-- op2[6]
t_prcs_op2_6: PROCESS
BEGIN
	op2(6) <= '0';
	WAIT FOR 210000 ps;
	op2(6) <= '1';
	WAIT FOR 30000 ps;
	op2(6) <= '0';
	WAIT FOR 60000 ps;
	op2(6) <= '1';
	WAIT FOR 60000 ps;
	op2(6) <= '0';
	WAIT FOR 330000 ps;
	op2(6) <= '1';
	WAIT FOR 30000 ps;
	op2(6) <= '0';
WAIT;
END PROCESS t_prcs_op2_6;
-- op2[5]
t_prcs_op2_5: PROCESS
BEGIN
	op2(5) <= '0';
	WAIT FOR 240000 ps;
	op2(5) <= '1';
	WAIT FOR 60000 ps;
	op2(5) <= '0';
	WAIT FOR 60000 ps;
	op2(5) <= '1';
	WAIT FOR 120000 ps;
	op2(5) <= '0';
WAIT;
END PROCESS t_prcs_op2_5;
-- op2[4]
t_prcs_op2_4: PROCESS
BEGIN
	op2(4) <= '0';
	WAIT FOR 120000 ps;
	op2(4) <= '1';
	WAIT FOR 30000 ps;
	op2(4) <= '0';
	WAIT FOR 30000 ps;
	op2(4) <= '1';
	WAIT FOR 30000 ps;
	op2(4) <= '0';
	WAIT FOR 90000 ps;
	op2(4) <= '1';
	WAIT FOR 30000 ps;
	op2(4) <= '0';
	WAIT FOR 360000 ps;
	op2(4) <= '1';
	WAIT FOR 30000 ps;
	op2(4) <= '0';
WAIT;
END PROCESS t_prcs_op2_4;
-- op2[3]
t_prcs_op2_3: PROCESS
BEGIN
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
	WAIT FOR 60000 ps;
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
	WAIT FOR 60000 ps;
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
	WAIT FOR 30000 ps;
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
	WAIT FOR 90000 ps;
	op2(3) <= '1';
	WAIT FOR 120000 ps;
	op2(3) <= '0';
	WAIT FOR 270000 ps;
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
	WAIT FOR 30000 ps;
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
	WAIT FOR 30000 ps;
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
	WAIT FOR 30000 ps;
	op2(3) <= '1';
	WAIT FOR 30000 ps;
	op2(3) <= '0';
WAIT;
END PROCESS t_prcs_op2_3;
-- op2[2]
t_prcs_op2_2: PROCESS
BEGIN
	op2(2) <= '1';
	WAIT FOR 90000 ps;
	op2(2) <= '0';
	WAIT FOR 30000 ps;
	op2(2) <= '1';
	WAIT FOR 30000 ps;
	op2(2) <= '0';
	WAIT FOR 120000 ps;
	op2(2) <= '1';
	WAIT FOR 60000 ps;
	op2(2) <= '0';
	WAIT FOR 30000 ps;
	op2(2) <= '1';
	WAIT FOR 120000 ps;
	op2(2) <= '0';
	WAIT FOR 120000 ps;
	op2(2) <= '1';
	WAIT FOR 60000 ps;
	op2(2) <= '0';
	WAIT FOR 30000 ps;
	op2(2) <= '1';
	WAIT FOR 60000 ps;
	op2(2) <= '0';
	WAIT FOR 30000 ps;
	op2(2) <= '1';
	WAIT FOR 30000 ps;
	op2(2) <= '0';
	WAIT FOR 30000 ps;
	op2(2) <= '1';
	WAIT FOR 30000 ps;
	op2(2) <= '0';
	WAIT FOR 30000 ps;
	op2(2) <= '1';
	WAIT FOR 30000 ps;
	op2(2) <= '0';
WAIT;
END PROCESS t_prcs_op2_2;
-- op2[1]
t_prcs_op2_1: PROCESS
BEGIN
	op2(1) <= '1';
	WAIT FOR 60000 ps;
	op2(1) <= '0';
	WAIT FOR 60000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
	WAIT FOR 90000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
	WAIT FOR 60000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
	WAIT FOR 120000 ps;
	op2(1) <= '1';
	WAIT FOR 120000 ps;
	op2(1) <= '0';
	WAIT FOR 60000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
	WAIT FOR 30000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
	WAIT FOR 30000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
	WAIT FOR 30000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
	WAIT FOR 30000 ps;
	op2(1) <= '1';
	WAIT FOR 30000 ps;
	op2(1) <= '0';
WAIT;
END PROCESS t_prcs_op2_1;
-- op2[0]
t_prcs_op2_0: PROCESS
BEGIN
	op2(0) <= '1';
	WAIT FOR 180000 ps;
	op2(0) <= '0';
	WAIT FOR 30000 ps;
	op2(0) <= '1';
	WAIT FOR 30000 ps;
	op2(0) <= '0';
	WAIT FOR 30000 ps;
	op2(0) <= '1';
	WAIT FOR 60000 ps;
	op2(0) <= '0';
	WAIT FOR 30000 ps;
	op2(0) <= '1';
	WAIT FOR 240000 ps;
	op2(0) <= '0';
	WAIT FOR 60000 ps;
	op2(0) <= '1';
	WAIT FOR 90000 ps;
	op2(0) <= '0';
	WAIT FOR 30000 ps;
	op2(0) <= '1';
	WAIT FOR 30000 ps;
	op2(0) <= '0';
	WAIT FOR 30000 ps;
	op2(0) <= '1';
	WAIT FOR 30000 ps;
	op2(0) <= '0';
	WAIT FOR 30000 ps;
	op2(0) <= '1';
	WAIT FOR 30000 ps;
	op2(0) <= '0';
WAIT;
END PROCESS t_prcs_op2_0;
-- func[3]
t_prcs_func_3: PROCESS
BEGIN
	func(3) <= '0';
	WAIT FOR 480000 ps;
	func(3) <= '1';
	WAIT FOR 480000 ps;
	func(3) <= '0';
WAIT;
END PROCESS t_prcs_func_3;
-- func[2]
t_prcs_func_2: PROCESS
BEGIN
	FOR i IN 1 TO 2
	LOOP
		func(2) <= '0';
		WAIT FOR 240000 ps;
		func(2) <= '1';
		WAIT FOR 240000 ps;
	END LOOP;
	func(2) <= '0';
WAIT;
END PROCESS t_prcs_func_2;
-- func[1]
t_prcs_func_1: PROCESS
BEGIN
	FOR i IN 1 TO 4
	LOOP
		func(1) <= '0';
		WAIT FOR 120000 ps;
		func(1) <= '1';
		WAIT FOR 120000 ps;
	END LOOP;
	func(1) <= '0';
WAIT;
END PROCESS t_prcs_func_1;
-- func[0]
t_prcs_func_0: PROCESS
BEGIN
	FOR i IN 1 TO 8
	LOOP
		func(0) <= '0';
		WAIT FOR 60000 ps;
		func(0) <= '1';
		WAIT FOR 60000 ps;
	END LOOP;
	func(0) <= '0';
WAIT;
END PROCESS t_prcs_func_0;
END ALU_arch;
