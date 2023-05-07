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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition"

-- DATE "05/24/2020 22:54:46"

-- 
-- Device: Altera EP4CE115F29C7 Package FBGA780
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	PC IS
    PORT (
	reset : IN std_logic;
	clk : IN std_logic;
	En : IN std_logic;
	cntOut : OUT std_logic_vector(2 DOWNTO 0)
	);
END PC;

ARCHITECTURE structure OF PC IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_reset : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_En : std_logic;
SIGNAL ww_cntOut : std_logic_vector(2 DOWNTO 0);
SIGNAL \cntOut[0]~output_o\ : std_logic;
SIGNAL \cntOut[1]~output_o\ : std_logic;
SIGNAL \cntOut[2]~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \cntValue[1]~1_combout\ : std_logic;
SIGNAL \En~input_o\ : std_logic;
SIGNAL \cntValue[2]~2_combout\ : std_logic;
SIGNAL \cntValue[2]~3_combout\ : std_logic;
SIGNAL \process_0~0_combout\ : std_logic;
SIGNAL \cntValue[0]~0_combout\ : std_logic;
SIGNAL cntValue : std_logic_vector(2 DOWNTO 0);

BEGIN

ww_reset <= reset;
ww_clk <= clk;
ww_En <= En;
cntOut <= ww_cntOut;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\cntOut[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => cntValue(0),
	devoe => ww_devoe,
	o => \cntOut[0]~output_o\);

\cntOut[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => cntValue(1),
	devoe => ww_devoe,
	o => \cntOut[1]~output_o\);

\cntOut[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => cntValue(2),
	devoe => ww_devoe,
	o => \cntOut[2]~output_o\);

\clk~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

\reset~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

\cntValue[1]~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \cntValue[1]~1_combout\ = (!\reset~input_o\ & (cntValue(1) $ (((!\process_0~0_combout\ & cntValue(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010011010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => cntValue(1),
	datab => \process_0~0_combout\,
	datac => cntValue(0),
	datad => \reset~input_o\,
	combout => \cntValue[1]~1_combout\);

\cntValue[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \cntValue[1]~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => cntValue(1));

\En~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_En,
	o => \En~input_o\);

\cntValue[2]~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \cntValue[2]~2_combout\ = (cntValue(2)) # ((cntValue(0) & (cntValue(1) & \En~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110101010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => cntValue(2),
	datab => cntValue(0),
	datac => cntValue(1),
	datad => \En~input_o\,
	combout => \cntValue[2]~2_combout\);

\cntValue[2]~3\ : cycloneive_lcell_comb
-- Equation(s):
-- \cntValue[2]~3_combout\ = (\cntValue[2]~2_combout\ & !\reset~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \cntValue[2]~2_combout\,
	datad => \reset~input_o\,
	combout => \cntValue[2]~3_combout\);

\cntValue[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \cntValue[2]~3_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => cntValue(2));

\process_0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \process_0~0_combout\ = ((cntValue(0) & (cntValue(1) & cntValue(2)))) # (!\En~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => cntValue(0),
	datab => cntValue(1),
	datac => cntValue(2),
	datad => \En~input_o\,
	combout => \process_0~0_combout\);

\cntValue[0]~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \cntValue[0]~0_combout\ = (!\reset~input_o\ & (cntValue(0) $ (!\process_0~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101000000000101",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \reset~input_o\,
	datac => cntValue(0),
	datad => \process_0~0_combout\,
	combout => \cntValue[0]~0_combout\);

\cntValue[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \cntValue[0]~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => cntValue(0));

ww_cntOut(0) <= \cntOut[0]~output_o\;

ww_cntOut(1) <= \cntOut[1]~output_o\;

ww_cntOut(2) <= \cntOut[2]~output_o\;
END structure;


