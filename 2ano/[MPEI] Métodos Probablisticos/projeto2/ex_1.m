T = [0 0.5 0 0.5 0
    0.25 0 1/3 0 0
    0.25 0.5 0 0.5 0
    0.25 0 1/3 0 0
    0.25 0 1/3 0 0];
N = 1e5;
palavras = [];
num = [];
for i=1:N
    vetor = crawl_por_size(T,randi([1,4]),5,2);
    if(vetor(end) == 5)
        vetor(end) = [];
    end
    set_of_letters = 'amor';
    word = set_of_letters(vetor);
    a = ismember(palavras,word);
    if(sum(a)==1)
        pos = find(a==true);
        num(pos) = num(pos) + 1;
    else
        palavras{end+1} = word;
        num = [num 1];
    end
end
prob_MAX_5 = maxk(num,5)/N*100;
sum(prob_MAX_5);
[~,indices] = maxk(num,5);
words = [];
for i=1:length(indices)
    words = [words palavras(indices(i))];
end
words;
palavras
num



    