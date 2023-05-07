exp = 1e6;
n = 8;

%probablidade do componente1 ter defeito
comp1   = randi([1,1000],n,exp) < 3;
% Probablidade do componente2 ter defeito
comp2   = randi([1,1000],n,exp) < 6;
% Probablidade da monatagem ter defeito
montagem = randi([1,100],n,exp) < 2;

% Numero de vezes que ocorreu o evento A
total_1  = comp2 | comp1 | montagem;
soma_1   = sum(total_1) >=1;
numero_1 = sum(soma_1);

% Numero de brinquedos defeituosos apenas pela montagem
total_2  = 1-comp2 & 1-comp1 & montagem;
soma_2   = sum(total_2);
numero_2 = sum(soma_2);


% A = [num de vezes que é defeituoso apenas pela montagem]
% B = [num de vezes que ocorre A]
% valor médio = A / B
numero_medio = numero_2/numero_1


