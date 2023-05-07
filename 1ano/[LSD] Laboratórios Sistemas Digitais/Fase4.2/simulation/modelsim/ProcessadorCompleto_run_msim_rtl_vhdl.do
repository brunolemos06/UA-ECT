transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/ControlUnit.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/pMux2_1.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/PC.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/SignExtend.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/IMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/DMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/Registers.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/ALU.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/Datapath.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4.2/ProcessadorCompleto.vhd}

