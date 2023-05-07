file = fopen('wordlist-preao-20201103.txt', 'r');
dicionario = textscan(file, '%s');
fclose(file);
dicionario = dicionario{1,1};

palavras = {};
set_of_letters= 'amor';

for i = 1:length(dicionario)
    word = dicionario{i,1};
    if(min(ismember(word,set_of_letters))==true)
        palavras{end+1} = word; %#ok<*SAGROW>
    end
end
length(palavras)
letras = ['a' 'm' 'o' 'r'];
nums = [0 0 0 0];
for i = 1:length(palavras)
    palavras{i};
   if(palavras{i}(1)=='a')
       nums(1) = nums(1)+1;
   elseif(palavras{i}(1)=='m')
       nums(2) = nums(2)+1;
   elseif(palavras{i}(1)=='o')
       nums(3) = nums(3)+1;
   elseif(palavras{i}(1)=='r')
       nums(4) = nums(4)+1;
   end
end
nums;
probs = nums/length(palavras);

T = [0 0.7 0 0.6 0
    0.2 0 0.2 0.1 0 
    0.1 0.3 0 0.3 0 
    0.3 0 0.3 0 0 
    0.4 0 0.5 0 0];

set_of_letters = 'amor';
palavras = {};
nums=[];
N = [4 6 8];
probsN = [];

for k = 1:length(N)                            
    for i = 1:1e4
        val = rand;
        if (rand < probs(1))
            vetor = crawl_por_size(T, 1, 5, N(k));
        elseif(rand < probs(1)+probs(2))
            vetor = crawl_por_size(T, 2, 5, N(k));
        elseif(rand < probs(1)+probs(2)+probs(3))
            vetor = crawl_por_size(T, 3, 5, N(k));
        else
            vetor = crawl_por_size(T, 4, 5, N(k));
        end
        if(vetor(end)==5)
            vetor(end) = [];
        end
        word = set_of_letters(vetor);
        a = ismember(palavras, word);
        if(sum(a)==1)
            pos = find(a==true);
            nums(pos) = nums(pos)+1;
        else
            palavras{end+1} = word; %#ok<*SAGROW>
            nums = [nums 1]; %#ok<*AGROW>
        end
    end

    sucessos = 0;
    for i = 1:length(palavras)
        if(ismember(palavras(i), dicionario))
            sucessos = sucessos+1;
        end
    end
    sucessos
    length(palavras)
    probDicionario = sucessos/length(palavras) %palavras unicas, nao duplicadas
    probsN = [probsN probDicionario];
end
stem(N, probsN)
xlabel('N')
ylabel('Probabilidade')