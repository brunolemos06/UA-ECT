exp = 1e5;
n = 8;
p1 = 2; % 2/1000
p2 = 5; % 5/1000
pa = 10; % 10/1000

%probablidade do componente1 ter defeito
comp1    = randi([1,1000],n,exp) <= p1;
%probablidade do componente2 ter defeito
comp2    = randi([1,1000],n,exp) <= p2;
%probablidade da monatagem ter defeito
montagem = randi([1,1000],n,exp) <= pa;

total  = comp2 | comp1 | montagem;
soma   = sum(total) >= 1;
prob   = sum(soma) /exp


