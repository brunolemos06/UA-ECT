num_lancamentos = 2;
num_experiencias = 1e5;
p =0.5;
num = 1;

total = rand(num_lancamentos,num_experiencias) > p;
ver   = sum(total) >= num;
prob  = sum(ver)/num_experiencias;