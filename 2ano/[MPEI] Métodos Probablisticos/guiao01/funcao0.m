function probSimulacao = funcao0(p,num_lancamentos,num_caras,num_experiencias)
    lancamentos   = rand(num_lancamentos,num_experiencias) > p
    sucessos      = sum(lancamentos) == num_caras
    probSimulacao = sum(sucessos)/num_experiencias
end
