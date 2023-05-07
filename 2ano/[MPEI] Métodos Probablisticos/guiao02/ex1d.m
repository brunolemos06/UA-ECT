num_lancamentos = 2;
num_experiencias = 1e5;
p =0.5;


total = rand(num_lancamentos,num_experiencias) > p;
ver   = sum(total) == 2 ;
prob_1seremos2_rapazes  = sum(ver)/num_experiencias;

total = rand(num_lancamentos,num_experiencias) > p;
ver   = sum(total) == 1;
prob_1filho_ser_rapaz  = sum(ver)/num_experiencias;



prob_1seremos2_rapazes/prob_1filho_ser_rapaz

