T = [0 0.7 0 0.7 0
    0.2 0 0.2 0 0 
    0.1 0.3 0 0.3 0 
    0.3 0 0.3 0 0 
    0.4 0 0.5 0 0];

set_of_letters = 'amor';

palavras = {};
nums=[];

for i = 1:1e4
    vetor = crawl_por_size(T, randi([1,4]), 5, 4);
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

file = fopen('wordlist-preao-20201103.txt', 'r');
dicionario = textscan(file, '%s');
fclose(file);
dicionario = dicionario{1,1};

max = maxk(nums, 5);
[~,indices] = maxk(nums, 5);
maisComuns = [];
for i = 1:length(indices)
    maisComuns = [maisComuns palavras(indices(i))];
end
maisComuns

sucessos = 0;
for i = 1:length(palavras)
    if(ismember(palavras(i), dicionario))
        sucessos = sucessos+1;
    end
end
sucessos
probDicionario = sucessos/length(palavras) %palavras unicas, nao duplicadas
