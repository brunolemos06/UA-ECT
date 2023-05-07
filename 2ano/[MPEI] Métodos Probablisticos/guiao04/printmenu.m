function [output] = printmenu()

while (true)
    fprintf(2,'-----Menu-----\n');
    fprintf("1 - Your Movies\n2 - Get Suggestions\n3 - Search Title\n4 - Exit\n");
    op = input('Select choice: ');
    if(op == 1 || op == 2 || op == 3 || op == 4)
        break;
    else
        fprintf(2,"Invalid Choice.\nSelect a valid value [1,2,3,4]\n");
    end
end

output = op;
end

