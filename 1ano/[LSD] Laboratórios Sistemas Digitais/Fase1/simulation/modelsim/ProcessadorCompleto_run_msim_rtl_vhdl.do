transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/pMux2_1.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/PC.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/SignExtend.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/IMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/DMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/Registers.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/ALU.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase3/Datapath.vhd}

