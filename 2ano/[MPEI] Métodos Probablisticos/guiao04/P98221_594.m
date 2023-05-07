% CODE: 594

% NOME: 
% NO. MEC.: 

% EXERCÍCIO 1
% Considere um processo aleatório que gera dois números: o primeiro número
% de 1 a 4 (com todos os valores igualmente prováveis) e o segundo número
% de 4 a 8 (com todos os valores também igualmente prováveis).
% Seja X a variável aleatória que representa o segundo número menos o
% primeiro número.
% (a) (3.0 valores) Estime por simulação (usando 10000 simulações) a função
%     massa de probabilidade da variável aleatória X e apresente-a num
%     gráfico do tipo stem.
N = 10000;
v1 = randi([1 4], 1, N);
v2 = randi([4 8], 1, N);
x = v2-v1;
ocorrencias = zeros(1,8);
for i = 1:N
    ocorrencias(x(i)+1) = ocorrencias(x(i)+1) + 1;
end
fx = ocorrencias/N;

X = unique(x);
stem(X,fx),xlabel('x'),ylabel('px(x)')
% (b) (2.0 valores) Com base na função massa de probabilidade estimada,
%     estime o valor esperado, a variância e o desvio padrão da variável
%     aleatória X.
media        = sum(fx.*X);
variancia    = sum(fx.*(X.^2))- media^2;
desvioPadrao = sqrt(variancia);
fprintf("media: %f\nvariancia: %f\ndesvioPadrao: %f\n", media,variancia,desvioPadrao);

% (c) (2.0 valores) Determine o valor teórico da probabilidade de X ser
%     maior que 3, sabendo que o primeiro número é 2.

% X1 = [1, 2, 3, 4]
% X1 = 2, X2 = [4, 5, 6, 7, 8]
% X = [2, 3 ,4 ,5 ,6]
% p(X > 3 | vl = 2) = 3/5


% EXERCÍCIO 2
% Considere um sistema com 4 estados (1, 2, 3 e 4) modelado por uma cadeia
% de Markov com a matriz de transição de estados T seguinte.

T= [0.2 0.4 0.1 0
    0.4 0.3 0.1 0.1
    0.3 0.3 0.8 0.1
    0.1 0   0   0.8];

% (a) (3.0 valores) Qual a probabilidade de o sistema, começando no
%     estado 2, estar no estado 4 após 5 transições?
T5 = T^5;
pb = T5(4,2);
fprintf("EX2 a) %d\n",pb);
% (b) (2.0 valores) Qual a probabilidade de o sistema, começando no
%     estado 2, manter-se no estado 2 nas 5 primeiras transições?
probl = 1;
Ttemp = T;
for i = 1:5
    probl = probl * Ttemp(2,2);
    Ttemp = Ttemp * T;
end
fprintf("EX2 b) %d\n",probl);

% EXERCÍCIO 3
% Considere um conjunto de 4 páginas web (A, B, C e D) com os hyperlinks
% seguintes entre eles:
% A -> B , A -> C , B -> C , C -> D
%
% (3.0 valores) Determine o pagerank de cada página web ao fim de 10
% iterações assumindo beta = 0.8 e resolvendo primeiro problemas que
% possam existir de 'spider traps' e/ou 'dead-ends'.

    H =  [	 0    0    0    0
           1/2    0    0    0
           1/2    1    0    0
             0    0    1    0];
    
Hsolved = [  0      0   0    1/4
           1/2      0   0    1/4
           1/2      1   0    1/4
             0      0   1    1/4];
         
b = .8;
N = length(Hsolved);
rank = ones(N,1)*1/N;
A = b*Hsolved + (1-b)*(1/N);
A10 = A^10*rank;

fprintf("EX3 Os ranks das páginas são: A - %f, B - %f, C - %f, D - %f\n\n", A10(1), A10(2), A10(3), A10(4));





% EXERCÍCIO 4
% Considere as 2 funções no fim deste script que implementam duas das
% funcionalidades necessárias à implementação de um filtro de Bloom.
% Considere também os dois conjuntos de chaves seguintes:

CH1= {'Amelia','Emma','Damian','Joe','Madison','Megan','Susan','Thomas'};
CH2= {'George','Jack','Oscar','Sarah'};

% (a) (3.0 valores) Desenvolva a função que falta para, com as funções
%     fornecidas, ter todas as funcionalidades necessárias à implementação
%     de um filtro de Bloom.

% (b) (2.0 valores) Desenvolva um script que (i) crie um filtro de Bloom
%     de comprimento 100 baseado em 6 funções de dispersão com as
%     chaves de CH1, (ii) teste a pertença das chaves de CH1 no filtro de
%     Bloom criado e (iii) verifique se as chaves de CH2 pertencem ao
%     filtro de Bloom.



n = 100;
k = 6;
BF = Init(n);
r = true;

for i = 1:length(CH1)
    BF = AddElement(BF, CH1{i},k);
    fprintf("%s foi adicionado\n", CH1{i});
end

for i = 1:length(CH1)
    r = IsMember(BF, CH1{i}, k);
    fprintf("%s é elemento: %d \n", CH1{i}, r);
end

for i = 1:length(CH2)
   r = IsMember(BF, CH2{i}, k);
    fprintf("%s é elemento: %d \n", CH2{i}, r);
end

function r = IsMember(BF, chave, k)
    r = true;
    h= 127;
    chave= double(chave);
    nBF= length(BF);
    for i= 1:length(chave)
        h= mod(31*h+chave(i),2^32-1);
    end
    for i= k:-1:1
        h= mod(31*h+i,2^32-1);
        if (BF(mod(h,nBF)+1) == 0)
            r = false;
            break;
        end
    end
end

function BF= Init(n)
    BF= zeros(n,1);
end

function BF= AddElement(BF,chave,k)
    h= 127;
    chave= double(chave);
    nBF= length(BF);
    for i= 1:length(chave)
        h= mod(31*h+chave(i),2^32-1);
    end
    for i= k:-1:1
        h= mod(31*h+i,2^32-1);
        BF(mod(h,nBF)+1)= 1;
    end
end