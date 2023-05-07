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

-- DATE "05/25/2020 22:13:21"

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

ENTITY 	ControlUnit IS
    PORT (
	clk : IN std_logic;
	rst : IN std_logic;
	opcode : IN std_logic_vector(2 DOWNTO 0);
	func : IN std_logic_vector(3 DOWNTO 0);
	EnPc : OUT std_logic;
	RI : OUT std_logic;
	RegWr : OUT std_logic;
	RegDst : OUT std_logic;
	ALUSrc : OUT std_logic;
	ALUOp : OUT std_logic_vector(3 DOWNTO 0);
	MemWr : OUT std_logic;
	MemtoReg : OUT std_logic
	);
END ControlUnit;

ARCHITECTURE structure OF ControlUnit IS
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
SIGNAL ww_rst : std_logic;
SIGNAL ww_opcode : std_logic_vector(2 DOWNTO 0);
SIGNAL ww_func : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_EnPc : std_logic;
SIGNAL ww_RI : std_logic;
SIGNAL ww_RegWr : std_logic;
SIGNAL ww_RegDst : std_logic;
SIGNAL ww_ALUSrc : std_logic;
SIGNAL ww_ALUOp : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_MemWr : std_logic;
SIGNAL ww_MemtoReg : std_logic;
SIGNAL \EnPc~output_o\ : std_logic;
SIGNAL \RI~output_o\ : std_logic;
SIGNAL \RegWr~output_o\ : std_logic;
SIGNAL \RegDst~output_o\ : std_logic;
SIGNAL \ALUSrc~output_o\ : std_logic;
SIGNAL \ALUOp[0]~output_o\ : std_logic;
SIGNAL \ALUOp[1]~output_o\ : std_logic;
SIGNAL \ALUOp[2]~output_o\ : std_logic;
SIGNAL \ALUOp[3]~output_o\ : std_logic;
SIGNAL \MemWr~output_o\ : std_logic;
SIGNAL \MemtoReg~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \next_state.DECODE~q\ : std_logic;
SIGNAL \rst~input_o\ : std_logic;
SIGNAL \state~22_combout\ : std_logic;
SIGNAL \state.DECODE~q\ : std_logic;
SIGNAL \opcode[2]~input_o\ : std_logic;
SIGNAL \opcode[1]~input_o\ : std_logic;
SIGNAL \opcode[0]~input_o\ : std_logic;
SIGNAL \next_state~9_combout\ : std_logic;
SIGNAL \next_state.EXECUTE~q\ : std_logic;
SIGNAL \state~17_combout\ : std_logic;
SIGNAL \state.EXECUTE~q\ : std_logic;
SIGNAL \next_state~10_combout\ : std_logic;
SIGNAL \next_state.REG_UPDATE~q\ : std_logic;
SIGNAL \state~18_combout\ : std_logic;
SIGNAL \state.REG_UPDATE~q\ : std_logic;
SIGNAL \next_state~11_combout\ : std_logic;
SIGNAL \next_state.WRITE_MEM~q\ : std_logic;
SIGNAL \state~19_combout\ : std_logic;
SIGNAL \state.WRITE_MEM~q\ : std_logic;
SIGNAL \next_state.RESET~q\ : std_logic;
SIGNAL \state~21_combout\ : std_logic;
SIGNAL \state.RESET~q\ : std_logic;
SIGNAL \Selector11~0_combout\ : std_logic;
SIGNAL \Selector11~1_combout\ : std_logic;
SIGNAL \Selector11~2_combout\ : std_logic;
SIGNAL \next_state.FETCH0~q\ : std_logic;
SIGNAL \state~20_combout\ : std_logic;
SIGNAL \state.FETCH0~q\ : std_logic;
SIGNAL \next_state.FETCH1~q\ : std_logic;
SIGNAL \state~16_combout\ : std_logic;
SIGNAL \state.FETCH1~q\ : std_logic;
SIGNAL \Selector0~0_combout\ : std_logic;
SIGNAL \Selector0~1_combout\ : std_logic;
SIGNAL \EnPc~reg0_q\ : std_logic;
SIGNAL \Selector1~0_combout\ : std_logic;
SIGNAL \RI~reg0_q\ : std_logic;
SIGNAL \Selector2~0_combout\ : std_logic;
SIGNAL \RegWr~reg0_q\ : std_logic;
SIGNAL \Selector3~0_combout\ : std_logic;
SIGNAL \Selector9~0_combout\ : std_logic;
SIGNAL \Selector3~1_combout\ : std_logic;
SIGNAL \RegDst~reg0_q\ : std_logic;
SIGNAL \Selector4~0_combout\ : std_logic;
SIGNAL \ALUSrc~0_combout\ : std_logic;
SIGNAL \Selector4~1_combout\ : std_logic;
SIGNAL \ALUSrc~reg0_q\ : std_logic;
SIGNAL \func[0]~input_o\ : std_logic;
SIGNAL \Selector8~0_combout\ : std_logic;
SIGNAL \Selector8~1_combout\ : std_logic;
SIGNAL \Selector5~0_combout\ : std_logic;
SIGNAL \Selector8~2_combout\ : std_logic;
SIGNAL \ALUOp[0]~reg0_q\ : std_logic;
SIGNAL \func[1]~input_o\ : std_logic;
SIGNAL \Selector7~0_combout\ : std_logic;
SIGNAL \Selector7~1_combout\ : std_logic;
SIGNAL \ALUOp[1]~reg0_q\ : std_logic;
SIGNAL \func[2]~input_o\ : std_logic;
SIGNAL \Selector6~0_combout\ : std_logic;
SIGNAL \Selector6~1_combout\ : std_logic;
SIGNAL \ALUOp[2]~reg0_q\ : std_logic;
SIGNAL \func[3]~input_o\ : std_logic;
SIGNAL \Selector5~1_combout\ : std_logic;
SIGNAL \Selector5~2_combout\ : std_logic;
SIGNAL \ALUOp[3]~reg0_q\ : std_logic;
SIGNAL \Selector9~1_combout\ : std_logic;
SIGNAL \MemWr~reg0_q\ : std_logic;
SIGNAL \Selector10~0_combout\ : std_logic;
SIGNAL \Selector10~1_combout\ : std_logic;
SIGNAL \MemtoReg~reg0_q\ : std_logic;
SIGNAL \ALT_INV_clk~input_o\ : std_logic;

BEGIN

ww_clk <= clk;
ww_rst <= rst;
ww_opcode <= opcode;
ww_func <= func;
EnPc <= ww_EnPc;
RI <= ww_RI;
RegWr <= ww_RegWr;
RegDst <= ww_RegDst;
ALUSrc <= ww_ALUSrc;
ALUOp <= ww_ALUOp;
MemWr <= ww_MemWr;
MemtoReg <= ww_MemtoReg;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_clk~input_o\ <= NOT \clk~input_o\;

\EnPc~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \EnPc~reg0_q\,
	devoe => ww_devoe,
	o => \EnPc~output_o\);

\RI~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \RI~reg0_q\,
	devoe => ww_devoe,
	o => \RI~output_o\);

\RegWr~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \RegWr~reg0_q\,
	devoe => ww_devoe,
	o => \RegWr~output_o\);

\RegDst~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \RegDst~reg0_q\,
	devoe => ww_devoe,
	o => \RegDst~output_o\);

\ALUSrc~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALUSrc~reg0_q\,
	devoe => ww_devoe,
	o => \ALUSrc~output_o\);

\ALUOp[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALUOp[0]~reg0_q\,
	devoe => ww_devoe,
	o => \ALUOp[0]~output_o\);

\ALUOp[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALUOp[1]~reg0_q\,
	devoe => ww_devoe,
	o => \ALUOp[1]~output_o\);

\ALUOp[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALUOp[2]~reg0_q\,
	devoe => ww_devoe,
	o => \ALUOp[2]~output_o\);

\ALUOp[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALUOp[3]~reg0_q\,
	devoe => ww_devoe,
	o => \ALUOp[3]~output_o\);

\MemWr~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \MemWr~reg0_q\,
	devoe => ww_devoe,
	o => \MemWr~output_o\);

\MemtoReg~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \MemtoReg~reg0_q\,
	devoe => ww_devoe,
	o => \MemtoReg~output_o\);

\clk~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

\next_state.DECODE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \state.FETCH1~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \next_state.DECODE~q\);

\rst~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_rst,
	o => \rst~input_o\);

\state~22\ : cycloneive_lcell_comb
-- Equation(s):
-- \state~22_combout\ = (\next_state.DECODE~q\ & !\rst~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \next_state.DECODE~q\,
	datad => \rst~input_o\,
	combout => \state~22_combout\);

\state.DECODE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \state~22_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.DECODE~q\);

\opcode[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_opcode(2),
	o => \opcode[2]~input_o\);

\opcode[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_opcode(1),
	o => \opcode[1]~input_o\);

\opcode[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_opcode(0),
	o => \opcode[0]~input_o\);

\next_state~9\ : cycloneive_lcell_comb
-- Equation(s):
-- \next_state~9_combout\ = (\state.DECODE~q\ & (\opcode[2]~input_o\ $ (((!\opcode[1]~input_o\ & \opcode[0]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000001010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.DECODE~q\,
	datab => \opcode[2]~input_o\,
	datac => \opcode[1]~input_o\,
	datad => \opcode[0]~input_o\,
	combout => \next_state~9_combout\);

\next_state.EXECUTE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \next_state~9_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \next_state.EXECUTE~q\);

\state~17\ : cycloneive_lcell_comb
-- Equation(s):
-- \state~17_combout\ = (\next_state.EXECUTE~q\ & !\rst~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \next_state.EXECUTE~q\,
	datad => \rst~input_o\,
	combout => \state~17_combout\);

\state.EXECUTE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \state~17_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.EXECUTE~q\);

\next_state~10\ : cycloneive_lcell_comb
-- Equation(s):
-- \next_state~10_combout\ = (\state.EXECUTE~q\ & ((\opcode[0]~input_o\ & (\opcode[2]~input_o\ $ (!\opcode[1]~input_o\))) # (!\opcode[0]~input_o\ & (\opcode[2]~input_o\ & !\opcode[1]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \opcode[0]~input_o\,
	datac => \opcode[2]~input_o\,
	datad => \opcode[1]~input_o\,
	combout => \next_state~10_combout\);

\next_state.REG_UPDATE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \next_state~10_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \next_state.REG_UPDATE~q\);

\state~18\ : cycloneive_lcell_comb
-- Equation(s):
-- \state~18_combout\ = (\next_state.REG_UPDATE~q\ & !\rst~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \next_state.REG_UPDATE~q\,
	datad => \rst~input_o\,
	combout => \state~18_combout\);

\state.REG_UPDATE\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \state~18_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.REG_UPDATE~q\);

\next_state~11\ : cycloneive_lcell_comb
-- Equation(s):
-- \next_state~11_combout\ = (\state.EXECUTE~q\ & (\opcode[1]~input_o\ & (\opcode[2]~input_o\ & !\opcode[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \opcode[1]~input_o\,
	datac => \opcode[2]~input_o\,
	datad => \opcode[0]~input_o\,
	combout => \next_state~11_combout\);

\next_state.WRITE_MEM\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \next_state~11_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \next_state.WRITE_MEM~q\);

\state~19\ : cycloneive_lcell_comb
-- Equation(s):
-- \state~19_combout\ = (\next_state.WRITE_MEM~q\ & !\rst~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \next_state.WRITE_MEM~q\,
	datad => \rst~input_o\,
	combout => \state~19_combout\);

\state.WRITE_MEM\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \state~19_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.WRITE_MEM~q\);

\next_state.RESET\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \next_state.RESET~q\);

\state~21\ : cycloneive_lcell_comb
-- Equation(s):
-- \state~21_combout\ = (!\rst~input_o\ & \next_state.RESET~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \rst~input_o\,
	datad => \next_state.RESET~q\,
	combout => \state~21_combout\);

\state.RESET\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \state~21_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.RESET~q\);

\Selector11~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector11~0_combout\ = (!\state.REG_UPDATE~q\ & (!\state.WRITE_MEM~q\ & \state.RESET~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0001000000010000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.REG_UPDATE~q\,
	datab => \state.WRITE_MEM~q\,
	datac => \state.RESET~q\,
	combout => \Selector11~0_combout\);

\Selector11~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector11~1_combout\ = \opcode[2]~input_o\ $ (((\opcode[0]~input_o\ & !\opcode[1]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1101001011010010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \opcode[0]~input_o\,
	datab => \opcode[1]~input_o\,
	datac => \opcode[2]~input_o\,
	combout => \Selector11~1_combout\);

\Selector11~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector11~2_combout\ = ((!\Selector11~1_combout\ & ((\state.EXECUTE~q\) # (\state.DECODE~q\)))) # (!\Selector11~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111101111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \state.DECODE~q\,
	datac => \Selector11~0_combout\,
	datad => \Selector11~1_combout\,
	combout => \Selector11~2_combout\);

\next_state.FETCH0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector11~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \next_state.FETCH0~q\);

\state~20\ : cycloneive_lcell_comb
-- Equation(s):
-- \state~20_combout\ = (\next_state.FETCH0~q\ & !\rst~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \next_state.FETCH0~q\,
	datad => \rst~input_o\,
	combout => \state~20_combout\);

\state.FETCH0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \state~20_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.FETCH0~q\);

\next_state.FETCH1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \state.FETCH0~q\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \next_state.FETCH1~q\);

\state~16\ : cycloneive_lcell_comb
-- Equation(s):
-- \state~16_combout\ = (\next_state.FETCH1~q\ & !\rst~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \next_state.FETCH1~q\,
	datad => \rst~input_o\,
	combout => \state~16_combout\);

\state.FETCH1\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \state~16_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.FETCH1~q\);

\Selector0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector0~0_combout\ = (\EnPc~reg0_q\ & ((\state.EXECUTE~q\) # ((\state.REG_UPDATE~q\) # (\state.WRITE_MEM~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \EnPc~reg0_q\,
	datab => \state.EXECUTE~q\,
	datac => \state.REG_UPDATE~q\,
	datad => \state.WRITE_MEM~q\,
	combout => \Selector0~0_combout\);

\Selector0~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector0~1_combout\ = (\state.FETCH1~q\) # (\Selector0~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.FETCH1~q\,
	datab => \Selector0~0_combout\,
	combout => \Selector0~1_combout\);

\EnPc~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector0~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \EnPc~reg0_q\);

\Selector1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector1~0_combout\ = (\state.FETCH0~q\) # ((\RI~reg0_q\ & (\state.RESET~q\ & !\state.FETCH1~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.FETCH0~q\,
	datab => \RI~reg0_q\,
	datac => \state.RESET~q\,
	datad => \state.FETCH1~q\,
	combout => \Selector1~0_combout\);

\RI~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector1~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \RI~reg0_q\);

\Selector2~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector2~0_combout\ = (\state.REG_UPDATE~q\) # ((\RegWr~reg0_q\ & (\state.RESET~q\ & !\state.FETCH0~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.REG_UPDATE~q\,
	datab => \RegWr~reg0_q\,
	datac => \state.RESET~q\,
	datad => \state.FETCH0~q\,
	combout => \Selector2~0_combout\);

\RegWr~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector2~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \RegWr~reg0_q\);

\Selector3~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector3~0_combout\ = (\state.DECODE~q\ & (\opcode[2]~input_o\ & (\opcode[1]~input_o\ $ (!\opcode[0]~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.DECODE~q\,
	datab => \opcode[2]~input_o\,
	datac => \opcode[1]~input_o\,
	datad => \opcode[0]~input_o\,
	combout => \Selector3~0_combout\);

\Selector9~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector9~0_combout\ = (\state.RESET~q\ & !\state.FETCH0~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.RESET~q\,
	datad => \state.FETCH0~q\,
	combout => \Selector9~0_combout\);

\Selector3~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector3~1_combout\ = (\Selector3~0_combout\) # ((\RegDst~reg0_q\ & ((\Selector9~0_combout\) # (\state.DECODE~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector3~0_combout\,
	datab => \RegDst~reg0_q\,
	datac => \Selector9~0_combout\,
	datad => \state.DECODE~q\,
	combout => \Selector3~1_combout\);

\RegDst~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector3~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \RegDst~reg0_q\);

\Selector4~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector4~0_combout\ = (\ALUSrc~reg0_q\ & ((\state.DECODE~q\) # ((\state.RESET~q\ & !\state.FETCH0~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000100010101000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \ALUSrc~reg0_q\,
	datab => \state.DECODE~q\,
	datac => \state.RESET~q\,
	datad => \state.FETCH0~q\,
	combout => \Selector4~0_combout\);

\ALUSrc~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \ALUSrc~0_combout\ = (\opcode[0]~input_o\ & !\opcode[1]~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \opcode[0]~input_o\,
	datad => \opcode[1]~input_o\,
	combout => \ALUSrc~0_combout\);

\Selector4~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector4~1_combout\ = (\Selector4~0_combout\) # ((\state.DECODE~q\ & (\opcode[2]~input_o\ & !\ALUSrc~0_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector4~0_combout\,
	datab => \state.DECODE~q\,
	datac => \opcode[2]~input_o\,
	datad => \ALUSrc~0_combout\,
	combout => \Selector4~1_combout\);

\ALUSrc~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector4~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ALUSrc~reg0_q\);

\func[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_func(0),
	o => \func[0]~input_o\);

\Selector8~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector8~0_combout\ = (\state.EXECUTE~q\ & (\ALUSrc~0_combout\ & (\func[0]~input_o\ & !\opcode[2]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \ALUSrc~0_combout\,
	datac => \func[0]~input_o\,
	datad => \opcode[2]~input_o\,
	combout => \Selector8~0_combout\);

\Selector8~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector8~1_combout\ = (\state.EXECUTE~q\ & (\opcode[2]~input_o\ $ (((\opcode[1]~input_o\) # (!\opcode[0]~input_o\)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000100010100010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \opcode[0]~input_o\,
	datac => \opcode[1]~input_o\,
	datad => \opcode[2]~input_o\,
	combout => \Selector8~1_combout\);

\Selector5~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector5~0_combout\ = (\state.RESET~q\ & (!\state.EXECUTE~q\ & !\state.FETCH0~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.RESET~q\,
	datac => \state.EXECUTE~q\,
	datad => \state.FETCH0~q\,
	combout => \Selector5~0_combout\);

\Selector8~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector8~2_combout\ = (\Selector8~0_combout\) # ((\ALUOp[0]~reg0_q\ & ((\Selector8~1_combout\) # (\Selector5~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector8~0_combout\,
	datab => \ALUOp[0]~reg0_q\,
	datac => \Selector8~1_combout\,
	datad => \Selector5~0_combout\,
	combout => \Selector8~2_combout\);

\ALUOp[0]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector8~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ALUOp[0]~reg0_q\);

\func[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_func(1),
	o => \func[1]~input_o\);

\Selector7~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector7~0_combout\ = (\state.EXECUTE~q\ & (\ALUSrc~0_combout\ & (\func[1]~input_o\ & !\opcode[2]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \ALUSrc~0_combout\,
	datac => \func[1]~input_o\,
	datad => \opcode[2]~input_o\,
	combout => \Selector7~0_combout\);

\Selector7~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector7~1_combout\ = (\Selector7~0_combout\) # ((\ALUOp[1]~reg0_q\ & ((\Selector8~1_combout\) # (\Selector5~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector7~0_combout\,
	datab => \ALUOp[1]~reg0_q\,
	datac => \Selector8~1_combout\,
	datad => \Selector5~0_combout\,
	combout => \Selector7~1_combout\);

\ALUOp[1]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector7~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ALUOp[1]~reg0_q\);

\func[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_func(2),
	o => \func[2]~input_o\);

\Selector6~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector6~0_combout\ = (\state.EXECUTE~q\ & (\ALUSrc~0_combout\ & (\func[2]~input_o\ & !\opcode[2]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \ALUSrc~0_combout\,
	datac => \func[2]~input_o\,
	datad => \opcode[2]~input_o\,
	combout => \Selector6~0_combout\);

\Selector6~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector6~1_combout\ = (\Selector6~0_combout\) # ((\ALUOp[2]~reg0_q\ & ((\Selector8~1_combout\) # (\Selector5~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector6~0_combout\,
	datab => \ALUOp[2]~reg0_q\,
	datac => \Selector8~1_combout\,
	datad => \Selector5~0_combout\,
	combout => \Selector6~1_combout\);

\ALUOp[2]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector6~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ALUOp[2]~reg0_q\);

\func[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_func(3),
	o => \func[3]~input_o\);

\Selector5~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector5~1_combout\ = (\state.EXECUTE~q\ & (\ALUSrc~0_combout\ & (\func[3]~input_o\ & !\opcode[2]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000010000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.EXECUTE~q\,
	datab => \ALUSrc~0_combout\,
	datac => \func[3]~input_o\,
	datad => \opcode[2]~input_o\,
	combout => \Selector5~1_combout\);

\Selector5~2\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector5~2_combout\ = (\Selector5~1_combout\) # ((\ALUOp[3]~reg0_q\ & ((\Selector8~1_combout\) # (\Selector5~0_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector5~1_combout\,
	datab => \ALUOp[3]~reg0_q\,
	datac => \Selector8~1_combout\,
	datad => \Selector5~0_combout\,
	combout => \Selector5~2_combout\);

\ALUOp[3]~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector5~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ALUOp[3]~reg0_q\);

\Selector9~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector9~1_combout\ = (\state.WRITE_MEM~q\) # ((\MemWr~reg0_q\ & (\state.RESET~q\ & !\state.FETCH0~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.WRITE_MEM~q\,
	datab => \MemWr~reg0_q\,
	datac => \state.RESET~q\,
	datad => \state.FETCH0~q\,
	combout => \Selector9~1_combout\);

\MemWr~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector9~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \MemWr~reg0_q\);

\Selector10~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector10~0_combout\ = (\state.DECODE~q\ & (\opcode[1]~input_o\ & (\opcode[0]~input_o\ & \opcode[2]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \state.DECODE~q\,
	datab => \opcode[1]~input_o\,
	datac => \opcode[0]~input_o\,
	datad => \opcode[2]~input_o\,
	combout => \Selector10~0_combout\);

\Selector10~1\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector10~1_combout\ = (\Selector10~0_combout\) # ((\MemtoReg~reg0_q\ & ((\Selector9~0_combout\) # (\state.DECODE~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1110111011101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \Selector10~0_combout\,
	datab => \MemtoReg~reg0_q\,
	datac => \Selector9~0_combout\,
	datad => \state.DECODE~q\,
	combout => \Selector10~1_combout\);

\MemtoReg~reg0\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \ALT_INV_clk~input_o\,
	d => \Selector10~1_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \MemtoReg~reg0_q\);

ww_EnPc <= \EnPc~output_o\;

ww_RI <= \RI~output_o\;

ww_RegWr <= \RegWr~output_o\;

ww_RegDst <= \RegDst~output_o\;

ww_ALUSrc <= \ALUSrc~output_o\;

ww_ALUOp(0) <= \ALUOp[0]~output_o\;

ww_ALUOp(1) <= \ALUOp[1]~output_o\;

ww_ALUOp(2) <= \ALUOp[2]~output_o\;

ww_ALUOp(3) <= \ALUOp[3]~output_o\;

ww_MemWr <= \MemWr~output_o\;

ww_MemtoReg <= \MemtoReg~output_o\;
END structure;


