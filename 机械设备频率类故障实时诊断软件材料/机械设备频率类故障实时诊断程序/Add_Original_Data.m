  function [Input_Data,testdata]=Add_Original_Data(inputdata_options) %
%% 添加相对路径，就算换电脑或者换文件所在目录都能直接打开程序并运行
s=what;  % 获得当前目录
s.path     % 当前路径
filep=fullfile(s.path,'data') ;% 需要加载的数据所在文件夹的路径
addpath(filep);     % 添加路径
%% 加载原始数据：任意选取classes_num种数据
load Normal_1
load IR007_0
load B021_3
%% 原始数据
sample_total=inputdata_options.sample_total;%训练数据总长
sample_num=inputdata_options.sample_num;%训练数据维度
n_columns=inputdata_options.n_columns;%数据维度
%% 取出原始数据
x1=(X098_DE_time(1:sample_total));%Normal_1数据1(1*sample_num)
x2=(X109_DE_time(1:sample_total));%IR007_0数据2(1*sample_num)
x3=(X229_DE_time(1:sample_total));%B007_0数据3(1*sample_num)
%% 为斜率&&曲率数据预分配内存
x1_slope=zeros(1,sample_total);
x1_curvature=zeros(1,sample_total);
x2_slope=zeros(1,sample_total);
x2_curvature=zeros(1,sample_total);
x3_slope=zeros(1,sample_total);
x3_curvature=zeros(1,sample_total);
%% 求斜率&&曲率
for i=1:sample_total-1
%% 斜率
x1_slope(i)=(x1(i+1)-x1(i));
x2_slope(i)=(x2(i+1)-x2(i));
x3_slope(i)=(x3(i+1)-x3(i));
%% 曲率
x1_curvature(i)=(x1_slope(i+1)-x1_slope(i));
x2_curvature(i)=(x2_slope(i+1)-x2_slope(i));
x3_curvature(i)=(x3_slope(i+1)-x3_slope(i));
end
%% 给斜率曲率的最后一个值通过简单赋值处理，以后可以拟合这个数据或者求取后将最后一位输入数据舍弃
x1_slope(sample_total)=x1_slope(sample_total-1);
x2_slope(sample_total)=x2_slope(sample_total-1);
x3_slope(sample_total)=x3_slope(sample_total-1);
x1_curvature(sample_total)=x1_curvature(sample_total-1);
x2_curvature(sample_total)=x2_curvature(sample_total-1);
x3_curvature(sample_total)=x3_curvature(sample_total-1);
%%  按时间划分
bb11=zeros(sample_num,n_columns);
bb12=zeros(sample_num,n_columns);
bb13=zeros(sample_num,n_columns);
aa11=zeros(sample_num,n_columns);
aa12=zeros(sample_num,n_columns);
aa13=zeros(sample_num,n_columns);
cc11=zeros(sample_num,n_columns);
cc12=zeros(sample_num,n_columns);
cc13=zeros(sample_num,n_columns);
b11=zeros(sample_num,n_columns);
b12=zeros(sample_num,n_columns);
b13=zeros(sample_num,n_columns);
a11=zeros(sample_num,n_columns);
a12=zeros(sample_num,n_columns);
a13=zeros(sample_num,n_columns);
c11=zeros(sample_num,n_columns);
c12=zeros(sample_num,n_columns);
c13=zeros(sample_num,n_columns);
for i=1:sample_num
    aa11(i,:)=x1(i:n_columns+i-1);
    aa12(i,:)=x2(i:n_columns+i-1);
    aa13(i,:)=x3(i:n_columns+i-1);
    bb11(i,:)=x1_slope(i:n_columns+i-1);
    bb12(i,:)=x2_slope(i:n_columns+i-1); 
    bb13(i,:)=x3_slope(i:n_columns+i-1); 
    cc11(i,:)=x1_curvature(i:n_columns+i-1);
    cc12(i,:)=x2_curvature(i:n_columns+i-1);
    cc13(i,:)=x3_curvature(i:n_columns+i-1);
    a11(i,:)=x1(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    a12(i,:)=x2(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    a13(i,:)=x3(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    b11(i,:)=x1_slope(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    b12(i,:)=x2_slope(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    b13(i,:)=x3_slope(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    c11(i,:)=x1_curvature(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    c12(i,:)=x2_curvature(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
    c13(i,:)=x3_curvature(n_columns+sample_num-1+i:n_columns+sample_num-1+n_columns+i-1);
end
Input_Data.trainData_original=[aa11,aa12,aa13];
Input_Data.trainData_slope=[bb11,bb12,bb13];
Input_Data.trainData_curvature=[cc11,cc12,cc13];
Input_Data.testData_original=[a11,a12,a13];
Input_Data.testData_slope=[b11,b12,b13];
Input_Data.testData_curvature=[c11,c12,c13];
%% 标签
Input_Data.trainLabels=[ones(1,n_columns),repmat(2,1,n_columns),repmat(3,1,n_columns)];
Input_Data.testLabels=[ones(1,n_columns),repmat(2,1,n_columns),repmat(3,1,n_columns)];
% long=1000;