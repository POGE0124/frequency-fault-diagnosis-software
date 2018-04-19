d = {'Time', 'Temp','huu','poo'};
load c
% c = abs(c);
% s=char(c)
a=strcat('A',num2str(c))
s = xlswrite('tempdata.xls', d, 'Temperatures', a)
%  xlswrite('tempdata.xls', b, 'Temperatures', 'A3')
c=c+1;
save c c 