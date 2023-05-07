function PrintMoviesbyID(uitem,Set,userID)
    clc();   
    list = Set{userID,1};
    fprintf(2,'Filmes Vistos pelo utilizador com ID->%d\n\n',userID);
    for i=1:length(list)
        num = list(i);
        fprintf('%s\n',uitem{num,1});
    end
    fprintf(2,'Press any key to continue ');
    pause();
    clc();
end