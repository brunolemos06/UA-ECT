function [chavesArray] = gerador_chaves(N,imin,imax,chars,prob)
    chavesArray = {};
    if(nargin == 4)
        for i=1:N
            word = '';
            comprimento = randi([imin,imax]);
            for k=1:comprimento
                index = randi([1,length(chars)]);
                word = [word chars(index)];
            end
            chavesArray{i,1} = word;
        end
    elseif(nargin ==5)
       for i=1:N
           comprimento = randi([imin,imax]);
           chavesArray{i} = discrete_rnd(chars,prob,comprimento);        
       end
    end
    chavesArray
end
