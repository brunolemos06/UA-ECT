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
nums
probs = nums/length(palavras)
