transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/ControlUnit.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/pMux2_1.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/PC.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/SignExtend.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/IMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/DMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/Registers.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/ALU.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/Datapath.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Final3 FINAL/ProcessadorCompleto.vhd}

