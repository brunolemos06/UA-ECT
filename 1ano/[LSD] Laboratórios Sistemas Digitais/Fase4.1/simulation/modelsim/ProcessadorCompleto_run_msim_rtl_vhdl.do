transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/ControlUnit.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/pMux2_1.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/PC.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/SignExtend.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/IMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/DMemory.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/Registers.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/ALU.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/Datapath.vhd}
vcom -93 -work work {C:/Uni/Projeto_LSD/Fase4/ProcessadorCompleto.vhd}

