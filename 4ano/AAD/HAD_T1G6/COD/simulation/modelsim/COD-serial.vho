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

-- DATE "11/16/2022 10:11:10"

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


LIBRARY ALTERA;
LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	serial_encoder IS
    PORT (
	clk : IN std_logic;
	rstGr : IN std_logic;
	m : IN std_logic;
	Y : BUFFER std_logic_vector(7 DOWNTO 0)
	);
END serial_encoder;

-- Design Ports Information
-- Y[0]	=>  Location: PIN_N8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[1]	=>  Location: PIN_K9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[2]	=>  Location: PIN_N12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[3]	=>  Location: PIN_N10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[4]	=>  Location: PIN_M11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[5]	=>  Location: PIN_N11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[6]	=>  Location: PIN_M9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Y[7]	=>  Location: PIN_L9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- rstGr	=>  Location: PIN_K8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_J7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- m	=>  Location: PIN_G13,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF serial_encoder IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_rstGr : std_logic;
SIGNAL ww_m : std_logic;
SIGNAL ww_Y : std_logic_vector(7 DOWNTO 0);
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \Y[0]~output_o\ : std_logic;
SIGNAL \Y[1]~output_o\ : std_logic;
SIGNAL \Y[2]~output_o\ : std_logic;
SIGNAL \Y[3]~output_o\ : std_logic;
SIGNAL \Y[4]~output_o\ : std_logic;
SIGNAL \Y[5]~output_o\ : std_logic;
SIGNAL \Y[6]~output_o\ : std_logic;
SIGNAL \Y[7]~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \rstGr~input_o\ : std_logic;
SIGNAL \block_control_unit|Block_Counter|s_count~2_combout\ : std_logic;
SIGNAL \block_control_unit|Block_Counter|s_count~1_combout\ : std_logic;
SIGNAL \block_control_unit|Block_Counter|s_count~0_combout\ : std_logic;
SIGNAL \m~input_o\ : std_logic;
SIGNAL \block_ffD|Q~q\ : std_logic;
SIGNAL \block_control_unit|Block_ROM|Mux8~0_combout\ : std_logic;
SIGNAL \block_calc_y7|comb~0_combout\ : std_logic;
SIGNAL \block_calc_y0|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y0|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y0|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_calc_y1|mi_and_kx|Y~0_combout\ : std_logic;
SIGNAL \block_calc_y1|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y1|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y1|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_calc_y2|mi_and_kx|Y~0_combout\ : std_logic;
SIGNAL \block_calc_y2|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y2|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y2|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_calc_y3|mi_and_kx|Y~0_combout\ : std_logic;
SIGNAL \block_calc_y3|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y3|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y3|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_calc_y4|mi_and_kx|Y~0_combout\ : std_logic;
SIGNAL \block_calc_y4|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y4|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y4|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_calc_y5|mi_and_kx|Y~0_combout\ : std_logic;
SIGNAL \block_calc_y5|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y5|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y5|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_calc_y6|mi_and_kx|Y~0_combout\ : std_logic;
SIGNAL \block_calc_y6|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y6|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y6|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_calc_y7|mi_and_kx|Y~0_combout\ : std_logic;
SIGNAL \block_calc_y7|Block1_flipFlopD|Q~0_combout\ : std_logic;
SIGNAL \block_calc_y7|Block1_flipFlopD|Q~q\ : std_logic;
SIGNAL \block_calc_y7|BLOCK_AND|Y~combout\ : std_logic;
SIGNAL \block_control_unit|Block_Counter|s_count\ : std_logic_vector(2 DOWNTO 0);

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_clk <= clk;
ww_rstGr <= rstGr;
ww_m <= m;
Y <= ww_Y;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X20_Y0_N9
\Y[0]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y0|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[0]~output_o\);

-- Location: IOOBUF_X22_Y0_N2
\Y[1]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y1|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[1]~output_o\);

-- Location: IOOBUF_X29_Y0_N2
\Y[2]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y2|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[2]~output_o\);

-- Location: IOOBUF_X26_Y0_N9
\Y[3]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y3|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[3]~output_o\);

-- Location: IOOBUF_X29_Y0_N9
\Y[4]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y4|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[4]~output_o\);

-- Location: IOOBUF_X26_Y0_N2
\Y[5]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y5|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[5]~output_o\);

-- Location: IOOBUF_X24_Y0_N2
\Y[6]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y6|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[6]~output_o\);

-- Location: IOOBUF_X24_Y0_N9
\Y[7]~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \block_calc_y7|BLOCK_AND|Y~combout\,
	devoe => ww_devoe,
	o => \Y[7]~output_o\);

-- Location: IOIBUF_X16_Y0_N15
\clk~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G17
\clk~inputclkctrl\ : cycloneiv_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: IOIBUF_X22_Y0_N8
\rstGr~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rstGr,
	o => \rstGr~input_o\);

-- Location: LCCOMB_X26_Y4_N6
\block_control_unit|Block_Counter|s_count~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_control_unit|Block_Counter|s_count~2_combout\ = (!\rstGr~input_o\ & (\block_control_unit|Block_Counter|s_count\(1) $ (\block_control_unit|Block_Counter|s_count\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000010101010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \rstGr~input_o\,
	datac => \block_control_unit|Block_Counter|s_count\(1),
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_control_unit|Block_Counter|s_count~2_combout\);

-- Location: FF_X26_Y4_N7
\block_control_unit|Block_Counter|s_count[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_control_unit|Block_Counter|s_count~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_control_unit|Block_Counter|s_count\(1));

-- Location: LCCOMB_X26_Y4_N16
\block_control_unit|Block_Counter|s_count~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_control_unit|Block_Counter|s_count~1_combout\ = (!\rstGr~input_o\ & (!\block_control_unit|Block_Counter|s_count\(0) & ((\block_control_unit|Block_Counter|s_count\(1)) # (!\block_control_unit|Block_Counter|s_count\(2)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000000011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(1),
	datab => \rstGr~input_o\,
	datac => \block_control_unit|Block_Counter|s_count\(0),
	datad => \block_control_unit|Block_Counter|s_count\(2),
	combout => \block_control_unit|Block_Counter|s_count~1_combout\);

-- Location: FF_X26_Y4_N17
\block_control_unit|Block_Counter|s_count[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_control_unit|Block_Counter|s_count~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_control_unit|Block_Counter|s_count\(0));

-- Location: LCCOMB_X26_Y4_N26
\block_control_unit|Block_Counter|s_count~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_control_unit|Block_Counter|s_count~0_combout\ = (!\rstGr~input_o\ & ((\block_control_unit|Block_Counter|s_count\(0) & (\block_control_unit|Block_Counter|s_count\(2) $ (\block_control_unit|Block_Counter|s_count\(1)))) # 
-- (!\block_control_unit|Block_Counter|s_count\(0) & (\block_control_unit|Block_Counter|s_count\(2) & \block_control_unit|Block_Counter|s_count\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001010001000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \rstGr~input_o\,
	datab => \block_control_unit|Block_Counter|s_count\(0),
	datac => \block_control_unit|Block_Counter|s_count\(2),
	datad => \block_control_unit|Block_Counter|s_count\(1),
	combout => \block_control_unit|Block_Counter|s_count~0_combout\);

-- Location: FF_X26_Y4_N27
\block_control_unit|Block_Counter|s_count[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_control_unit|Block_Counter|s_count~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_control_unit|Block_Counter|s_count\(2));

-- Location: IOIBUF_X33_Y16_N22
\m~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_m,
	o => \m~input_o\);

-- Location: FF_X26_Y4_N21
\block_ffD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	asdata => \m~input_o\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_ffD|Q~q\);

-- Location: LCCOMB_X26_Y4_N14
\block_control_unit|Block_ROM|Mux8~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_control_unit|Block_ROM|Mux8~0_combout\ = \block_control_unit|Block_Counter|s_count\(2) $ (((\block_control_unit|Block_Counter|s_count\(0)) # (\block_control_unit|Block_Counter|s_count\(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101100110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(2),
	datab => \block_control_unit|Block_Counter|s_count\(0),
	datad => \block_control_unit|Block_Counter|s_count\(1),
	combout => \block_control_unit|Block_ROM|Mux8~0_combout\);

-- Location: LCCOMB_X26_Y4_N28
\block_calc_y7|comb~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y7|comb~0_combout\ = (!\rstGr~input_o\ & ((\block_control_unit|Block_Counter|s_count\(0)) # (\block_control_unit|Block_Counter|s_count\(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010101000100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \rstGr~input_o\,
	datab => \block_control_unit|Block_Counter|s_count\(0),
	datad => \block_control_unit|Block_Counter|s_count\(1),
	combout => \block_calc_y7|comb~0_combout\);

-- Location: LCCOMB_X26_Y4_N24
\block_calc_y0|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y0|Block1_flipFlopD|Q~0_combout\ = (\block_control_unit|Block_ROM|Mux8~0_combout\ & (\block_ffD|Q~q\ $ ((\block_calc_y0|Block1_flipFlopD|Q~q\)))) # (!\block_control_unit|Block_ROM|Mux8~0_combout\ & (((\block_calc_y0|Block1_flipFlopD|Q~q\ & 
-- \block_calc_y7|comb~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111100001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_ffD|Q~q\,
	datab => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datac => \block_calc_y0|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y7|comb~0_combout\,
	combout => \block_calc_y0|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X26_Y4_N25
\block_calc_y0|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y0|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y0|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X27_Y4_N8
\block_calc_y0|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y0|BLOCK_AND|Y~combout\ = (\block_calc_y0|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(1) & !\block_control_unit|Block_Counter|s_count\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(2),
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_calc_y0|Block1_flipFlopD|Q~q\,
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_calc_y0|BLOCK_AND|Y~combout\);

-- Location: LCCOMB_X27_Y4_N6
\block_calc_y1|mi_and_kx|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y1|mi_and_kx|Y~0_combout\ = (\block_ffD|Q~q\ & ((\block_control_unit|Block_Counter|s_count\(1) & ((!\block_control_unit|Block_Counter|s_count\(2)))) # (!\block_control_unit|Block_Counter|s_count\(1) & 
-- (!\block_control_unit|Block_Counter|s_count\(0) & \block_control_unit|Block_Counter|s_count\(2)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(0),
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(2),
	datad => \block_ffD|Q~q\,
	combout => \block_calc_y1|mi_and_kx|Y~0_combout\);

-- Location: LCCOMB_X27_Y4_N22
\block_calc_y1|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y1|Block1_flipFlopD|Q~0_combout\ = (\block_control_unit|Block_ROM|Mux8~0_combout\ & ((\block_calc_y1|Block1_flipFlopD|Q~q\ $ (\block_calc_y1|mi_and_kx|Y~0_combout\)))) # (!\block_control_unit|Block_ROM|Mux8~0_combout\ & 
-- (\block_calc_y7|comb~0_combout\ & (\block_calc_y1|Block1_flipFlopD|Q~q\ $ (\block_calc_y1|mi_and_kx|Y~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datab => \block_calc_y7|comb~0_combout\,
	datac => \block_calc_y1|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y1|mi_and_kx|Y~0_combout\,
	combout => \block_calc_y1|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X27_Y4_N23
\block_calc_y1|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y1|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y1|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X27_Y4_N12
\block_calc_y1|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y1|BLOCK_AND|Y~combout\ = (\block_calc_y1|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(1) & !\block_control_unit|Block_Counter|s_count\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(2),
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_calc_y1|Block1_flipFlopD|Q~q\,
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_calc_y1|BLOCK_AND|Y~combout\);

-- Location: LCCOMB_X26_Y4_N30
\block_calc_y2|mi_and_kx|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y2|mi_and_kx|Y~0_combout\ = (\block_ffD|Q~q\ & ((\block_control_unit|Block_Counter|s_count\(0) & ((!\block_control_unit|Block_Counter|s_count\(2)))) # (!\block_control_unit|Block_Counter|s_count\(0) & 
-- (!\block_control_unit|Block_Counter|s_count\(1) & \block_control_unit|Block_Counter|s_count\(2)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_ffD|Q~q\,
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(0),
	datad => \block_control_unit|Block_Counter|s_count\(2),
	combout => \block_calc_y2|mi_and_kx|Y~0_combout\);

-- Location: LCCOMB_X26_Y4_N8
\block_calc_y2|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y2|Block1_flipFlopD|Q~0_combout\ = (\block_control_unit|Block_ROM|Mux8~0_combout\ & (\block_calc_y2|mi_and_kx|Y~0_combout\ $ ((\block_calc_y2|Block1_flipFlopD|Q~q\)))) # (!\block_control_unit|Block_ROM|Mux8~0_combout\ & 
-- (\block_calc_y7|comb~0_combout\ & (\block_calc_y2|mi_and_kx|Y~0_combout\ $ (\block_calc_y2|Block1_flipFlopD|Q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y2|mi_and_kx|Y~0_combout\,
	datab => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datac => \block_calc_y2|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y7|comb~0_combout\,
	combout => \block_calc_y2|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X26_Y4_N9
\block_calc_y2|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y2|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y2|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X27_Y4_N18
\block_calc_y2|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y2|BLOCK_AND|Y~combout\ = (\block_calc_y2|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(0) & !\block_control_unit|Block_Counter|s_count\(1))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(0),
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(2),
	datad => \block_calc_y2|Block1_flipFlopD|Q~q\,
	combout => \block_calc_y2|BLOCK_AND|Y~combout\);

-- Location: LCCOMB_X26_Y4_N20
\block_calc_y3|mi_and_kx|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y3|mi_and_kx|Y~0_combout\ = (\block_ffD|Q~q\ & ((\block_control_unit|Block_Counter|s_count\(2) & (!\block_control_unit|Block_Counter|s_count\(0) & !\block_control_unit|Block_Counter|s_count\(1))) # 
-- (!\block_control_unit|Block_Counter|s_count\(2) & (\block_control_unit|Block_Counter|s_count\(0) & \block_control_unit|Block_Counter|s_count\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0100000000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(2),
	datab => \block_control_unit|Block_Counter|s_count\(0),
	datac => \block_ffD|Q~q\,
	datad => \block_control_unit|Block_Counter|s_count\(1),
	combout => \block_calc_y3|mi_and_kx|Y~0_combout\);

-- Location: LCCOMB_X26_Y4_N10
\block_calc_y3|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y3|Block1_flipFlopD|Q~0_combout\ = (\block_calc_y7|comb~0_combout\ & ((\block_calc_y3|Block1_flipFlopD|Q~q\ $ (\block_calc_y3|mi_and_kx|Y~0_combout\)))) # (!\block_calc_y7|comb~0_combout\ & (\block_control_unit|Block_ROM|Mux8~0_combout\ & 
-- (\block_calc_y3|Block1_flipFlopD|Q~q\ $ (\block_calc_y3|mi_and_kx|Y~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y7|comb~0_combout\,
	datab => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datac => \block_calc_y3|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y3|mi_and_kx|Y~0_combout\,
	combout => \block_calc_y3|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X26_Y4_N11
\block_calc_y3|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y3|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y3|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X27_Y4_N20
\block_calc_y3|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y3|BLOCK_AND|Y~combout\ = (\block_calc_y3|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(1) & !\block_control_unit|Block_Counter|s_count\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y3|Block1_flipFlopD|Q~q\,
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(2),
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_calc_y3|BLOCK_AND|Y~combout\);

-- Location: LCCOMB_X27_Y4_N16
\block_calc_y4|mi_and_kx|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y4|mi_and_kx|Y~0_combout\ = (\block_ffD|Q~q\ & ((\block_control_unit|Block_Counter|s_count\(2) & (!\block_control_unit|Block_Counter|s_count\(1) & !\block_control_unit|Block_Counter|s_count\(0))) # 
-- (!\block_control_unit|Block_Counter|s_count\(2) & (\block_control_unit|Block_Counter|s_count\(1) $ (\block_control_unit|Block_Counter|s_count\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001011000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(2),
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(0),
	datad => \block_ffD|Q~q\,
	combout => \block_calc_y4|mi_and_kx|Y~0_combout\);

-- Location: LCCOMB_X27_Y4_N30
\block_calc_y4|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y4|Block1_flipFlopD|Q~0_combout\ = (\block_control_unit|Block_ROM|Mux8~0_combout\ & ((\block_calc_y4|Block1_flipFlopD|Q~q\ $ (\block_calc_y4|mi_and_kx|Y~0_combout\)))) # (!\block_control_unit|Block_ROM|Mux8~0_combout\ & 
-- (\block_calc_y7|comb~0_combout\ & (\block_calc_y4|Block1_flipFlopD|Q~q\ $ (\block_calc_y4|mi_and_kx|Y~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datab => \block_calc_y7|comb~0_combout\,
	datac => \block_calc_y4|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y4|mi_and_kx|Y~0_combout\,
	combout => \block_calc_y4|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X27_Y4_N31
\block_calc_y4|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y4|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y4|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X27_Y4_N4
\block_calc_y4|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y4|BLOCK_AND|Y~combout\ = (\block_calc_y4|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(1) & !\block_control_unit|Block_Counter|s_count\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y4|Block1_flipFlopD|Q~q\,
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(2),
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_calc_y4|BLOCK_AND|Y~combout\);

-- Location: LCCOMB_X27_Y4_N10
\block_calc_y5|mi_and_kx|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y5|mi_and_kx|Y~0_combout\ = (!\block_control_unit|Block_Counter|s_count\(0) & (\block_ffD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (\block_control_unit|Block_Counter|s_count\(1)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000011000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(2),
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(0),
	datad => \block_ffD|Q~q\,
	combout => \block_calc_y5|mi_and_kx|Y~0_combout\);

-- Location: LCCOMB_X27_Y4_N26
\block_calc_y5|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y5|Block1_flipFlopD|Q~0_combout\ = (\block_control_unit|Block_ROM|Mux8~0_combout\ & ((\block_calc_y5|Block1_flipFlopD|Q~q\ $ (\block_calc_y5|mi_and_kx|Y~0_combout\)))) # (!\block_control_unit|Block_ROM|Mux8~0_combout\ & 
-- (\block_calc_y7|comb~0_combout\ & (\block_calc_y5|Block1_flipFlopD|Q~q\ $ (\block_calc_y5|mi_and_kx|Y~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datab => \block_calc_y7|comb~0_combout\,
	datac => \block_calc_y5|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y5|mi_and_kx|Y~0_combout\,
	combout => \block_calc_y5|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X27_Y4_N27
\block_calc_y5|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y5|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y5|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X27_Y4_N28
\block_calc_y5|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y5|BLOCK_AND|Y~combout\ = (\block_calc_y5|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(1) & !\block_control_unit|Block_Counter|s_count\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y5|Block1_flipFlopD|Q~q\,
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(2),
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_calc_y5|BLOCK_AND|Y~combout\);

-- Location: LCCOMB_X26_Y4_N0
\block_calc_y6|mi_and_kx|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y6|mi_and_kx|Y~0_combout\ = (\block_ffD|Q~q\ & (!\block_control_unit|Block_Counter|s_count\(1) & (\block_control_unit|Block_Counter|s_count\(2) $ (\block_control_unit|Block_Counter|s_count\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000001000100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_ffD|Q~q\,
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_control_unit|Block_Counter|s_count\(2),
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_calc_y6|mi_and_kx|Y~0_combout\);

-- Location: LCCOMB_X26_Y4_N12
\block_calc_y6|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y6|Block1_flipFlopD|Q~0_combout\ = (\block_calc_y7|comb~0_combout\ & ((\block_calc_y6|Block1_flipFlopD|Q~q\ $ (\block_calc_y6|mi_and_kx|Y~0_combout\)))) # (!\block_calc_y7|comb~0_combout\ & (\block_control_unit|Block_ROM|Mux8~0_combout\ & 
-- (\block_calc_y6|Block1_flipFlopD|Q~q\ $ (\block_calc_y6|mi_and_kx|Y~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111011100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y7|comb~0_combout\,
	datab => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datac => \block_calc_y6|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y6|mi_and_kx|Y~0_combout\,
	combout => \block_calc_y6|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X26_Y4_N13
\block_calc_y6|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y6|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y6|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X26_Y4_N18
\block_calc_y6|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y6|BLOCK_AND|Y~combout\ = (\block_calc_y6|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(1) & !\block_control_unit|Block_Counter|s_count\(0))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100010000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y6|Block1_flipFlopD|Q~q\,
	datab => \block_control_unit|Block_Counter|s_count\(2),
	datac => \block_control_unit|Block_Counter|s_count\(1),
	datad => \block_control_unit|Block_Counter|s_count\(0),
	combout => \block_calc_y6|BLOCK_AND|Y~combout\);

-- Location: LCCOMB_X26_Y4_N22
\block_calc_y7|mi_and_kx|Y~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y7|mi_and_kx|Y~0_combout\ = (\block_ffD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) & (!\block_control_unit|Block_Counter|s_count\(0) & !\block_control_unit|Block_Counter|s_count\(1))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_ffD|Q~q\,
	datab => \block_control_unit|Block_Counter|s_count\(2),
	datac => \block_control_unit|Block_Counter|s_count\(0),
	datad => \block_control_unit|Block_Counter|s_count\(1),
	combout => \block_calc_y7|mi_and_kx|Y~0_combout\);

-- Location: LCCOMB_X26_Y4_N4
\block_calc_y7|Block1_flipFlopD|Q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y7|Block1_flipFlopD|Q~0_combout\ = (\block_control_unit|Block_ROM|Mux8~0_combout\ & (\block_calc_y7|mi_and_kx|Y~0_combout\ $ ((\block_calc_y7|Block1_flipFlopD|Q~q\)))) # (!\block_control_unit|Block_ROM|Mux8~0_combout\ & 
-- (\block_calc_y7|comb~0_combout\ & (\block_calc_y7|mi_and_kx|Y~0_combout\ $ (\block_calc_y7|Block1_flipFlopD|Q~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101001001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_calc_y7|mi_and_kx|Y~0_combout\,
	datab => \block_control_unit|Block_ROM|Mux8~0_combout\,
	datac => \block_calc_y7|Block1_flipFlopD|Q~q\,
	datad => \block_calc_y7|comb~0_combout\,
	combout => \block_calc_y7|Block1_flipFlopD|Q~0_combout\);

-- Location: FF_X26_Y4_N5
\block_calc_y7|Block1_flipFlopD|Q\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \block_calc_y7|Block1_flipFlopD|Q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \block_calc_y7|Block1_flipFlopD|Q~q\);

-- Location: LCCOMB_X26_Y4_N2
\block_calc_y7|BLOCK_AND|Y\ : cycloneiv_lcell_comb
-- Equation(s):
-- \block_calc_y7|BLOCK_AND|Y~combout\ = (\block_calc_y7|Block1_flipFlopD|Q~q\ & (\block_control_unit|Block_Counter|s_count\(2) $ (((!\block_control_unit|Block_Counter|s_count\(0) & !\block_control_unit|Block_Counter|s_count\(1))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \block_control_unit|Block_Counter|s_count\(0),
	datab => \block_control_unit|Block_Counter|s_count\(1),
	datac => \block_calc_y7|Block1_flipFlopD|Q~q\,
	datad => \block_control_unit|Block_Counter|s_count\(2),
	combout => \block_calc_y7|BLOCK_AND|Y~combout\);

ww_Y(0) <= \Y[0]~output_o\;

ww_Y(1) <= \Y[1]~output_o\;

ww_Y(2) <= \Y[2]~output_o\;

ww_Y(3) <= \Y[3]~output_o\;

ww_Y(4) <= \Y[4]~output_o\;

ww_Y(5) <= \Y[5]~output_o\;

ww_Y(6) <= \Y[6]~output_o\;

ww_Y(7) <= \Y[7]~output_o\;
END structure;


