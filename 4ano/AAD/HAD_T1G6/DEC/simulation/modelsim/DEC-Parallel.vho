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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

-- DATE "11/16/2022 10:44:00"

-- 
-- Device: Altera EP4CGX15BF14C6 Package FBGA169
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_NCEO~	=>  Location: PIN_N5,	 I/O Standard: 2.5 V,	 Current Strength: 16mA
-- ~ALTERA_DATA0~	=>  Location: PIN_A5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_ASDO~	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_NCSO~	=>  Location: PIN_C5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DCLK~	=>  Location: PIN_A4,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_DATA0~~padout\ : std_logic;
SIGNAL \~ALTERA_ASDO~~padout\ : std_logic;
SIGNAL \~ALTERA_NCSO~~padout\ : std_logic;
SIGNAL \~ALTERA_DATA0~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_ASDO~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_NCSO~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	decoder IS
    PORT (
	y : IN std_logic_vector(7 DOWNTO 0);
	m : BUFFER std_logic_vector(3 DOWNTO 0);
	v : BUFFER std_logic
	);
END decoder;

-- Design Ports Information
-- m[0]	=>  Location: PIN_K11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m[1]	=>  Location: PIN_H10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m[2]	=>  Location: PIN_N13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m[3]	=>  Location: PIN_M13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- v	=>  Location: PIN_K12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[0]	=>  Location: PIN_J13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[1]	=>  Location: PIN_M11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[2]	=>  Location: PIN_K10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[3]	=>  Location: PIN_L12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[4]	=>  Location: PIN_L11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[5]	=>  Location: PIN_H12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[6]	=>  Location: PIN_K13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- y[7]	=>  Location: PIN_L13,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF decoder IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_y : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_m : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_v : std_logic;
SIGNAL \m[0]~output_o\ : std_logic;
SIGNAL \m[1]~output_o\ : std_logic;
SIGNAL \m[2]~output_o\ : std_logic;
SIGNAL \m[3]~output_o\ : std_logic;
SIGNAL \v~output_o\ : std_logic;
SIGNAL \y[5]~input_o\ : std_logic;
SIGNAL \y[7]~input_o\ : std_logic;
SIGNAL \y[4]~input_o\ : std_logic;
SIGNAL \y[6]~input_o\ : std_logic;
SIGNAL \val_m1|and2|Y~combout\ : std_logic;
SIGNAL \y[3]~input_o\ : std_logic;
SIGNAL \y[2]~input_o\ : std_logic;
SIGNAL \y[1]~input_o\ : std_logic;
SIGNAL \y[0]~input_o\ : std_logic;
SIGNAL \val_m1|and1|Y~combout\ : std_logic;
SIGNAL \val_m1|or1|Y~combout\ : std_logic;
SIGNAL \val_m2|and2|Y~combout\ : std_logic;
SIGNAL \val_m2|and1|Y~combout\ : std_logic;
SIGNAL \val_m2|or1|Y~combout\ : std_logic;
SIGNAL \val_m3|and2|Y~combout\ : std_logic;
SIGNAL \val_m3|and1|Y~combout\ : std_logic;
SIGNAL \val_m3|or1|Y~combout\ : std_logic;
SIGNAL \cal_m4|xor2|Y~combout\ : std_logic;
SIGNAL \cal_m4|or2|Y~0_combout\ : std_logic;
SIGNAL \val_m1|or2|Y~0_combout\ : std_logic;
SIGNAL \val_m3|or2|Y~0_combout\ : std_logic;
SIGNAL \val_m3|or3|Y~0_combout\ : std_logic;
SIGNAL \val_m2|or3|Y~0_combout\ : std_logic;
SIGNAL \val_m2|or2|Y~0_combout\ : std_logic;
SIGNAL \val_m2|xor1|Y~combout\ : std_logic;
SIGNAL \and2|Y~0_combout\ : std_logic;
SIGNAL \val_m1|or3|Y~0_combout\ : std_logic;
SIGNAL \and2|Y~1_combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_y <= y;
m <= ww_m;
v <= ww_v;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X33_Y11_N2
\m[0]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \val_m1|or1|Y~combout\,
	devoe => ww_devoe,
	o => \m[0]~output_o\);

-- Location: IOOBUF_X33_Y14_N2
\m[1]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \val_m2|or1|Y~combout\,
	devoe => ww_devoe,
	o => \m[1]~output_o\);

-- Location: IOOBUF_X33_Y10_N9
\m[2]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \val_m3|or1|Y~combout\,
	devoe => ww_devoe,
	o => \m[2]~output_o\);

-- Location: IOOBUF_X33_Y10_N2
\m[3]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \cal_m4|or2|Y~0_combout\,
	devoe => ww_devoe,
	o => \m[3]~output_o\);

-- Location: IOOBUF_X33_Y11_N9
\v~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \and2|Y~1_combout\,
	devoe => ww_devoe,
	o => \v~output_o\);

-- Location: IOIBUF_X33_Y14_N8
\y[5]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(5),
	o => \y[5]~input_o\);

-- Location: IOIBUF_X33_Y12_N8
\y[7]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(7),
	o => \y[7]~input_o\);

-- Location: IOIBUF_X31_Y0_N1
\y[4]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(4),
	o => \y[4]~input_o\);

-- Location: IOIBUF_X33_Y15_N1
\y[6]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(6),
	o => \y[6]~input_o\);

-- Location: LCCOMB_X32_Y10_N18
\val_m1|and2|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m1|and2|Y~combout\ = (\y[5]~input_o\ & (!\y[4]~input_o\ & (\y[7]~input_o\ $ (\y[6]~input_o\)))) # (!\y[5]~input_o\ & (\y[4]~input_o\ & (\y[7]~input_o\ $ (\y[6]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001001001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[5]~input_o\,
	datab => \y[7]~input_o\,
	datac => \y[4]~input_o\,
	datad => \y[6]~input_o\,
	combout => \val_m1|and2|Y~combout\);

-- Location: IOIBUF_X33_Y12_N1
\y[3]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(3),
	o => \y[3]~input_o\);

-- Location: IOIBUF_X31_Y0_N8
\y[2]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(2),
	o => \y[2]~input_o\);

-- Location: IOIBUF_X29_Y0_N8
\y[1]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(1),
	o => \y[1]~input_o\);

-- Location: IOIBUF_X33_Y15_N8
\y[0]~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_y(0),
	o => \y[0]~input_o\);

-- Location: LCCOMB_X32_Y10_N0
\val_m1|and1|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m1|and1|Y~combout\ = (\y[3]~input_o\ & (!\y[2]~input_o\ & (\y[1]~input_o\ $ (\y[0]~input_o\)))) # (!\y[3]~input_o\ & (\y[2]~input_o\ & (\y[1]~input_o\ $ (\y[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000011001100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[3]~input_o\,
	datab => \y[2]~input_o\,
	datac => \y[1]~input_o\,
	datad => \y[0]~input_o\,
	combout => \val_m1|and1|Y~combout\);

-- Location: LCCOMB_X32_Y11_N24
\val_m1|or1|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m1|or1|Y~combout\ = (\val_m1|and2|Y~combout\) # (\val_m1|and1|Y~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \val_m1|and2|Y~combout\,
	datad => \val_m1|and1|Y~combout\,
	combout => \val_m1|or1|Y~combout\);

-- Location: LCCOMB_X32_Y10_N6
\val_m2|and2|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m2|and2|Y~combout\ = (\y[5]~input_o\ & (!\y[7]~input_o\ & (\y[4]~input_o\ $ (\y[6]~input_o\)))) # (!\y[5]~input_o\ & (\y[7]~input_o\ & (\y[4]~input_o\ $ (\y[6]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000011001100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[5]~input_o\,
	datab => \y[7]~input_o\,
	datac => \y[4]~input_o\,
	datad => \y[6]~input_o\,
	combout => \val_m2|and2|Y~combout\);

-- Location: LCCOMB_X32_Y10_N4
\val_m2|and1|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m2|and1|Y~combout\ = (\y[3]~input_o\ & (!\y[1]~input_o\ & (\y[2]~input_o\ $ (\y[0]~input_o\)))) # (!\y[3]~input_o\ & (\y[1]~input_o\ & (\y[2]~input_o\ $ (\y[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001001001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[3]~input_o\,
	datab => \y[2]~input_o\,
	datac => \y[1]~input_o\,
	datad => \y[0]~input_o\,
	combout => \val_m2|and1|Y~combout\);

-- Location: LCCOMB_X32_Y14_N24
\val_m2|or1|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m2|or1|Y~combout\ = (\val_m2|and2|Y~combout\) # (\val_m2|and1|Y~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \val_m2|and2|Y~combout\,
	datad => \val_m2|and1|Y~combout\,
	combout => \val_m2|or1|Y~combout\);

-- Location: LCCOMB_X32_Y10_N2
\val_m3|and2|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m3|and2|Y~combout\ = (\y[6]~input_o\ & (!\y[2]~input_o\ & (\y[7]~input_o\ $ (\y[3]~input_o\)))) # (!\y[6]~input_o\ & (\y[2]~input_o\ & (\y[7]~input_o\ $ (\y[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010000101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[6]~input_o\,
	datab => \y[7]~input_o\,
	datac => \y[3]~input_o\,
	datad => \y[2]~input_o\,
	combout => \val_m3|and2|Y~combout\);

-- Location: LCCOMB_X32_Y10_N24
\val_m3|and1|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m3|and1|Y~combout\ = (\y[4]~input_o\ & (!\y[0]~input_o\ & (\y[1]~input_o\ $ (\y[5]~input_o\)))) # (!\y[4]~input_o\ & (\y[0]~input_o\ & (\y[1]~input_o\ $ (\y[5]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000011001100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[4]~input_o\,
	datab => \y[0]~input_o\,
	datac => \y[1]~input_o\,
	datad => \y[5]~input_o\,
	combout => \val_m3|and1|Y~combout\);

-- Location: LCCOMB_X31_Y10_N24
\val_m3|or1|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m3|or1|Y~combout\ = (\val_m3|and2|Y~combout\) # (\val_m3|and1|Y~combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111110101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \val_m3|and2|Y~combout\,
	datad => \val_m3|and1|Y~combout\,
	combout => \val_m3|or1|Y~combout\);

-- Location: LCCOMB_X32_Y10_N28
\cal_m4|xor2|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \cal_m4|xor2|Y~combout\ = \y[2]~input_o\ $ (((\val_m2|and1|Y~combout\) # (\val_m2|and2|Y~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011001100111100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \y[2]~input_o\,
	datac => \val_m2|and1|Y~combout\,
	datad => \val_m2|and2|Y~combout\,
	combout => \cal_m4|xor2|Y~combout\);

-- Location: LCCOMB_X32_Y10_N22
\cal_m4|or2|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \cal_m4|or2|Y~0_combout\ = (\y[0]~input_o\ & ((\cal_m4|xor2|Y~combout\) # (\y[4]~input_o\ $ (\val_m3|or1|Y~combout\)))) # (!\y[0]~input_o\ & (\cal_m4|xor2|Y~combout\ & (\y[4]~input_o\ $ (\val_m3|or1|Y~combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000111011101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[0]~input_o\,
	datab => \cal_m4|xor2|Y~combout\,
	datac => \y[4]~input_o\,
	datad => \val_m3|or1|Y~combout\,
	combout => \cal_m4|or2|Y~0_combout\);

-- Location: LCCOMB_X32_Y10_N12
\val_m1|or2|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m1|or2|Y~0_combout\ = (\y[3]~input_o\ & (\y[2]~input_o\ & (\y[1]~input_o\ $ (!\y[0]~input_o\)))) # (!\y[3]~input_o\ & (!\y[2]~input_o\ & (\y[1]~input_o\ $ (!\y[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[3]~input_o\,
	datab => \y[2]~input_o\,
	datac => \y[1]~input_o\,
	datad => \y[0]~input_o\,
	combout => \val_m1|or2|Y~0_combout\);

-- Location: LCCOMB_X32_Y10_N30
\val_m3|or2|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m3|or2|Y~0_combout\ = (\y[4]~input_o\ & (\y[0]~input_o\ & (\y[1]~input_o\ $ (!\y[5]~input_o\)))) # (!\y[4]~input_o\ & (!\y[0]~input_o\ & (\y[1]~input_o\ $ (!\y[5]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[4]~input_o\,
	datab => \y[0]~input_o\,
	datac => \y[1]~input_o\,
	datad => \y[5]~input_o\,
	combout => \val_m3|or2|Y~0_combout\);

-- Location: LCCOMB_X32_Y10_N8
\val_m3|or3|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m3|or3|Y~0_combout\ = (\y[6]~input_o\ & (\y[2]~input_o\ & (\y[7]~input_o\ $ (!\y[3]~input_o\)))) # (!\y[6]~input_o\ & (!\y[2]~input_o\ & (\y[7]~input_o\ $ (!\y[3]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001001000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[6]~input_o\,
	datab => \y[7]~input_o\,
	datac => \y[3]~input_o\,
	datad => \y[2]~input_o\,
	combout => \val_m3|or3|Y~0_combout\);

-- Location: LCCOMB_X32_Y10_N10
\val_m2|or3|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m2|or3|Y~0_combout\ = (\y[5]~input_o\ & (\y[7]~input_o\ & (\y[4]~input_o\ $ (!\y[6]~input_o\)))) # (!\y[5]~input_o\ & (!\y[7]~input_o\ & (\y[4]~input_o\ $ (!\y[6]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1001000000001001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[5]~input_o\,
	datab => \y[7]~input_o\,
	datac => \y[4]~input_o\,
	datad => \y[6]~input_o\,
	combout => \val_m2|or3|Y~0_combout\);

-- Location: LCCOMB_X32_Y10_N16
\val_m2|or2|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m2|or2|Y~0_combout\ = (\y[3]~input_o\ & (\y[1]~input_o\ & (\y[2]~input_o\ $ (!\y[0]~input_o\)))) # (!\y[3]~input_o\ & (!\y[1]~input_o\ & (\y[2]~input_o\ $ (!\y[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000010000100001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[3]~input_o\,
	datab => \y[2]~input_o\,
	datac => \y[1]~input_o\,
	datad => \y[0]~input_o\,
	combout => \val_m2|or2|Y~0_combout\);

-- Location: LCCOMB_X32_Y10_N20
\val_m2|xor1|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m2|xor1|Y~combout\ = (\val_m2|or3|Y~0_combout\ & (((!\val_m2|and1|Y~combout\ & !\val_m2|and2|Y~combout\)))) # (!\val_m2|or3|Y~0_combout\ & (\val_m2|or2|Y~0_combout\ $ (((\val_m2|and1|Y~combout\) # (\val_m2|and2|Y~combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000100011110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \val_m2|or3|Y~0_combout\,
	datab => \val_m2|or2|Y~0_combout\,
	datac => \val_m2|and1|Y~combout\,
	datad => \val_m2|and2|Y~combout\,
	combout => \val_m2|xor1|Y~combout\);

-- Location: LCCOMB_X32_Y10_N26
\and2|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \and2|Y~0_combout\ = (\val_m2|xor1|Y~combout\ & (\val_m3|or1|Y~combout\ $ (((\val_m3|or2|Y~0_combout\) # (\val_m3|or3|Y~0_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011011000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \val_m3|or2|Y~0_combout\,
	datab => \val_m3|or1|Y~combout\,
	datac => \val_m3|or3|Y~0_combout\,
	datad => \val_m2|xor1|Y~combout\,
	combout => \and2|Y~0_combout\);

-- Location: LCCOMB_X32_Y10_N14
\val_m1|or3|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \val_m1|or3|Y~0_combout\ = (\y[5]~input_o\ & (\y[4]~input_o\ & (\y[7]~input_o\ $ (!\y[6]~input_o\)))) # (!\y[5]~input_o\ & (!\y[4]~input_o\ & (\y[7]~input_o\ $ (!\y[6]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000010000100001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \y[5]~input_o\,
	datab => \y[7]~input_o\,
	datac => \y[4]~input_o\,
	datad => \y[6]~input_o\,
	combout => \val_m1|or3|Y~0_combout\);

-- Location: LCCOMB_X32_Y11_N2
\and2|Y~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \and2|Y~1_combout\ = (\and2|Y~0_combout\ & (\val_m1|or1|Y~combout\ $ (((\val_m1|or2|Y~0_combout\) # (\val_m1|or3|Y~0_combout\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010011001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \val_m1|or2|Y~0_combout\,
	datab => \and2|Y~0_combout\,
	datac => \val_m1|or3|Y~0_combout\,
	datad => \val_m1|or1|Y~combout\,
	combout => \and2|Y~1_combout\);

ww_m(0) <= \m[0]~output_o\;

ww_m(1) <= \m[1]~output_o\;

ww_m(2) <= \m[2]~output_o\;

ww_m(3) <= \m[3]~output_o\;

ww_v <= \v~output_o\;
END structure;


