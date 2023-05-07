num_lancamentos = 2;
num_experiencias = 100000000;
p = 0.5;


total = rand(num_lancamentos,num_experiencias) > p;
B_doisrapazes   = sum(total) == 2;
A_pelomenos_1rapaz   = sum(total) >= 1;
AB = doisrapazes & pelomenos_1rapaz;
probAB = sum(AB)/num_experiencias;
probA  = sum(pelomenos_1rapaz)/num_experiencias;
totalprob = probAB/probA



