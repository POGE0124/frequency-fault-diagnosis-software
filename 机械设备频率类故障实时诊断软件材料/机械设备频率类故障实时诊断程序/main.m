% function main()
%% 清除所有内存、窗口和命令行内容
clc
clear all
close all
%% 程序总执行时间: T   计时开始
tic
%% 输入数据参数设置
inputdata_options.classes_num=3;%故障种类，若更改则Add_Original_Data函数中的标签也需要改
inputdata_options.sample_total=10000;%样本点总数,可任意更改，但是必须是sample_num的整数倍
inputdata_options.sample_num=14;%变量个数，可任意更改
inputdata_options.n_columns=1000;%数据维度，可任意更改

%% 加载原始数据
fprintf('正在加载数据......');
[Input_Data]=Add_Original_Data(inputdata_options);
%% 设置AE模型参数
hidden.num1=13;%第一隐层神经元个数
hidden.num2=22;%第二隐层神经元个数
hidden.num3=40;%第三隐层神经元个数
hidden.net_trainParam_epochs=500;%迭代次数
hidden.learn_rare=0.01;%AE学习率（0-1之间，越大越容易过拟合，越小收敛速度越慢）
%% 选择是离线建模还是在线预测
n=input('请选择1（离线建模）或者2（在线预测）：');
switch n
    case 1
%% 调用DNN子程序
dnn(Input_Data,inputdata_options,hidden);

%% 概率值作为分类依据的总测试精度
load probabilitypred
pred1_2= pred_test_original;
pred2_2= pred_test_slope;
pred3_2= pred_test_curvature;
%概率值归一化
original=exp(probability_original);
probability_original_1=zeros(size(original,1),size(original,2));
for i=1:size(original,2)
        for j=1:size(original,1)
        probability_original_1(j,i)=original(j,i)/sum(original(:,i));
        end
end
slope=exp(probability_slope);
probability_slope_1=zeros(size(slope,1),size(slope,2));
for i=1:size(slope,2)
        for j=1:size(slope,1)
        probability_slope_1(j,i)=slope(j,i)/sum(slope(:,i));
        end
end
curvature=exp(probability_curvature);
probability_curvature_1=zeros(size(curvature,1),size(curvature,2));
for i=1:size(curvature,2)
        for j=1:size(curvature,1)
        probability_curvature_1(j,i)=curvature(j,i)/sum(curvature(:,i));
        end
end
% n=input('请选择1（未归一化）或者2（归一化）：');
n=1;
switch n
    case 1
%        probability_original=probability_original;
%        probability_slope=probability_slope;
%        probability_curvature=probability_curvature;
    case 2
       probability_original=probability_original_1;
       probability_slope=probability_slope_1;
       probability_curvature=probability_curvature_1;
    otherwise
        disp('输入错误！');
end

%找出概率最大的值作为分类结果
[predp1,xulie1]=max(probability_original);
[predp2,xulie2]=max(probability_slope);
[predp3,xulie3]=max(probability_curvature_1);

predpp=[predp1;predp2;predp3];
predppp=max(predpp);
fenlei=zeros(1,length(testLabels));
for i=1:length(testLabels)
if predppp(i)==predp1(i)
    fenlei(i)=xulie1(i);
elseif predppp(i)==predp2(i)
    fenlei(i)=xulie2(i);
elseif predppp(i)==predp3(i)
    fenlei(i)=xulie3(i);
end
end
figure
plot(fenlei,'r*');
% 画出测试数据的实际类别
hold on
plot(testLabels,'b+');
title('概率融合结果');
h=legend('预测','实际','location','northwest');
set(h,'Box','off');
set(h,'Fontsize',12);
%概率值作为分类依据总测试精度
accProb = mean(testLabels(:) == fenlei(:));
%% 决策级分类融合策略
pred2=zeros(1,length(testLabels));
for i=1:length(testLabels)
    if pred1_2(i)==1&&pred2_2(i)==1&&pred3_2(i)==1
    pred2(i)=1;
    elseif pred1_2(i)==2&&pred2_2(i)==2&&pred3_2(i)==2
    pred2(i)=2;   
    elseif pred1_2(i)==3&&pred2_2(i)==3&&pred3_2(i)==3
    pred2(i)=3;   
    else
        if (pred1_2(i)==1&&pred2_2(i)==1)||(pred1_2(i)==1&&pred3_2(i)==1)||...
                (pred2_2(i)==1&&pred3_2(i)==1)
        pred2(i)=1;
        elseif  (pred1_2(i)==2&&pred2_2(i)==2)||(pred1_2(i)==2&&pred3_2(i)==2)||...
                (pred2_2(i)==2&&pred3_2(i)==2)
        pred2(i)=2;    
        elseif  (pred1_2(i)==3&&pred2_2(i)==3)||(pred1_2(i)==3&&pred3_2(i)==3)||...
                (pred2_2(i)==3&&pred3_2(i)==3)
        pred2(i)=3;  
        else
            if i>9
                s=zeros(1,10);
                sum1=0;
                sum2=0;
                sum3=0;
                for j=1:10
                     s(j)=pred2(i-j);
                     if s(j)==1
                         sum1=sum1+1;
                     elseif s(j)==2
                         sum2=sum2+1;
                     else
                         sum3=sum3+1;
                     end                     
                end
                A=[sum1,sum2,sum3];
                maxRes=max(A);
                if maxRes==1
                  pred2(i)=1; 
                elseif maxRes==2
                  pred2(i)=2; 
                else
                    pred2(i)=3; 
                end
            else
                pred2(i)=1;    
            end
        end
    end
end
figure
plot(pred2,'r*');
% 画出测试数据的实际类别
hold on
testLabels=Input_Data.testLabels;
plot(testLabels,'b+');
title('决策级融合结果')
h=legend('预测','实际','location','northwest');
set(h,'Box','off');
set(h,'Fontsize',12);
% 决策级融合总测试精度
acc = mean(testLabels(:) == pred2(:));
%% 程序执行总时间
T=toc;

%% 保存数据到xls表格中去
fprintf('正在保存数据......\n');
sgc_exist = exist('DNNresult.xls', 'file');
if sgc_exist==0
 c=2;
 save c c
else 
load c
c=c+1;
save c c 
end
d = {'数据纬度','变量数', '隐层1神经元数','隐层2神经元数','隐层3神经元数','AE学习率','迭代次数',...
    '训练原始分类率','测试原始分类率','训练斜率分类率',...
    '测试斜率分类率','训练曲率分类率','测试曲率分类率','以概率的总分类率','以决策的总分类率',...
    '总运行时间(分钟)'};
xlswrite('DNNresult.xls', d, 'result', 'A1');
load classesResult;
xlswrite('DNNresult.xls', inputdata_options.n_columns,'result', strcat('A',num2str(c)))
xlswrite('DNNresult.xls', inputdata_options.sample_num, 'result', strcat('B',num2str(c)))
xlswrite('DNNresult.xls', hidden.num1, 'result', strcat('C',num2str(c)))
xlswrite('DNNresult.xls', hidden.num2, 'result', strcat('D',num2str(c)))
xlswrite('DNNresult.xls', hidden.num3, 'result', strcat('E',num2str(c)))
xlswrite('DNNresult.xls', hidden.learn_rare, 'result', strcat('F',num2str(c)))
xlswrite('DNNresult.xls', hidden.net_trainParam_epochs, 'result', strcat('G',num2str(c)))
xlswrite('DNNresult.xls', acc_train_original * 100, 'result', strcat('H',num2str(c)))
xlswrite('DNNresult.xls',  acc_test_original * 100, 'result', strcat('I',num2str(c)))
xlswrite('DNNresult.xls', acc_train_slope * 100, 'result', strcat('J',num2str(c)))
xlswrite('DNNresult.xls', acc_test_slope * 100, 'result', strcat('K',num2str(c)))
xlswrite('DNNresult.xls', acc_train_curvature * 100, 'result', strcat('L',num2str(c)))
xlswrite('DNNresult.xls',  acc_test_curvature * 100, 'result', strcat('M',num2str(c)))
xlswrite('DNNresult.xls', accProb * 100, 'result', strcat('N',num2str(c)))
xlswrite('DNNresult.xls', acc * 100, 'result', strcat('O',num2str(c)))
xlswrite('DNNresult.xls', fix(T/3600)*60+fix(mod(T,3600)/60), 'result', strcat('P',num2str(c)));

dt=fix(clock);
fprintf('时间记录：%d年 %d月 %d日 %d时 %d分 %d秒\n',dt(1),dt(2),dt(3),dt(4),dt(5),dt(6)); 
fprintf('程序运行总时间: %dh，%dmin, %ds\n',fix(T/3600),fix(mod(T,3600)/60),...
    fix(mod(mod(T,3600),60)));
%% 在线预测
    case 2
        disp('在线预测！');
        %加载网络参数
        load para11
        load para12
        stackedAEOptTheta1=stackedAEOptTheta;
        netconfig1=netconfig;
        load para21
        load para22
        stackedAEOptTheta2=stackedAEOptTheta;
        netconfig2=netconfig;
        load para31
        load para32
        stackedAEOptTheta3=stackedAEOptTheta;
        netconfig3=netconfig;
        %预分配内存
        pred2=zeros(1,length(Input_Data.testLabels));
        %原始数据所属类别
        for i=1:length(Input_Data.testLabels)
        [pred_test_original,probability_original] = stackedAEPredict(stackedAEOptTheta1, ...
            inputdata_options.sample_num, hidden.num3, inputdata_options.classes_num,...
            netconfig1, Input_Data.testData_original(:,i));
        pred1_2=pred_test_original;
        %斜率数据所属类别
        [pred_test_slope,probability_slope] = stackedAEPredict(stackedAEOptTheta2, ...
            inputdata_options.sample_num, hidden.num3, inputdata_options.classes_num,...
            netconfig2, Input_Data.testData_slope(:,i));
        pred2_2=pred_test_slope;
        %曲率数据所属类别
        [pred_test_curvature,probability_curvature] = stackedAEPredict(stackedAEOptTheta3, ...
            inputdata_options.sample_num, hidden.num3, inputdata_options.classes_num,...
            netconfig3, Input_Data.testData_curvature(:,i));
        pred3_2=pred_test_curvature;
    %决策级分类融合策略
    if pred1_2==1&&pred2_2==1&&pred3_2==1
    pred2(i)=1;
    elseif pred1_2==2&&pred2_2==2&&pred3_2==2
    pred2(i)=2;   
    elseif pred1_2==3&&pred2_2==3&&pred3_2==3
    pred2(i)=3;   
    else
        if (pred1_2==1&&pred2_2==1)||(pred1_2==1&&pred3_2==1)||...
                (pred2_2==1&&pred3_2==1)
        pred2(i)=1;
        elseif  (pred1_2==2&&pred2_2==2)||(pred1_2==2&&pred3_2==2)||...
                (pred2_2==2&&pred3_2==2)
        pred2(i)=2;    
        elseif  (pred1_2==3&&pred2_2==3)||(pred1_2==3&&pred3_2==3)||...
                (pred2_2==3&&pred3_2==3)
        pred2(i)=3;  
        else
            if i>9
                s=zeros(1,10);
                sum1=0;
                sum2=0;
                sum3=0;
                for j=1:10
                     s(j)=pred2(i-j);
                     if s(j)==1
                         sum1=sum1+1;
                     elseif s(j)==2
                         sum2=sum2+1;
                     else
                         sum3=sum3+1;
                     end                     
                end
                A=[sum1,sum2,sum3];
                maxRes=max(A);
                if maxRes==1
                  pred2(i)=1; 
                elseif maxRes==2
                  pred2(i)=2; 
                else
                    pred2(i)=3; 
                end
            else
                pred2(i)=1;    
            end
        end
    end
    fprintf('第%d个数据的故障类别: %d\n', i,pred2(i));
    pause(1);  
        end
    otherwise
        disp('输入错误！');
end
fprintf('运行完毕');
%% %%%%%%%%%%%%%%%%%%%%%%

%% 保存运行结果数据到txt中
% ordinal=1;%初始化程序运行次数
% load ordinal;
% load classesResult;
% fid=fopen('DNNresult.txt','at');   
% fixx=fopen('DNNresult.','at');  
% fprintf(fid,'第%d次运行结果：\n',ordinal); 
% dt=fix(clock);
% fprintf(fid,'时间记录：%d年 %d月 %d日 %d时 %d分 %d秒\n',dt(1),dt(2),dt(3),dt(4),dt(5),dt(6)); 
% fprintf(fid,'变量数: %d\n', inputdata_options.sample_num);
% fprintf(fid,'隐层神经元数: 一层:%d 二层：%d 三层：%d\n', hidden.num1,hidden.num2,,,,
%hidden.num3);
% fprintf(fid,'AE学习率: %d\n', hidden.learn_rare);
% fprintf(fid,'迭代次数: %d\n', hidden.net_trainParam_epochs);
% 
% fprintf(fid,'训练原始数据分类正确率: %0.3f%%\n', acc_train_original * 100);
% fprintf(fid,'测试原始数据分类正确率: %0.3f%%\n', acc_test_original * 100);
% fprintf(fid,'训练斜率数据分类正确率: %0.3f%%\n', acc_train_slope * 100);
% fprintf(fid,'测试斜率数据分类正确率: %0.3f%%\n', acc_test_slope * 100);
% fprintf(fid,'训练曲率数据分类正确率: %0.3f%%\n', acc_train_curvature * 100);
% fprintf(fid,'测试曲率数据分类正确率: %0.3f%%\n', acc_test_curvature * 100);
% fprintf(fid,'概率作为分类依据总的测试精确度: %0.3f%%\n', accProb * 100);
% fprintf(fid,'决策级融合总的测试精确率: %0.3f%%\n', acc * 100);
% fprintf(fid,'程序运行总时间: %dh，%dmin, %ds\n',fix(T/3600),fix(mod(T,3600)/60),...
%     fix(mod(mod(T,3600),60)));
% ordinal=ordinal+1;
% save ordinal ordinal

%Over




%%原始数据
% [predp1,xulie1]=max(probability_original);
% % 画出原始数据分类的概率值
% x=1:length(xulie1);
% figure
% scatter(x,probability_original(1,:),'k')
% hold on
% scatter(x,probability_original(2,:),'b')
% hold on
% scatter(x,probability_original(3,:),'r')
% title('原始数据分类概率值')
% xlabel('样本');
% ylabel('概率');
% h=legend('正常数据','故障1数据','故障2数据','location','northeast');
% set(h,'Box','off');
% set(h,'Fontsize',12);

% % 斜率数据
% [predp2,xulie2]=max(probability_slope);
% % 画出斜率数据分类的概率值
% x=1:length(xulie2);
% figure
% scatter(x,probability_slope(1,:),'k')
% hold on
% scatter(x,probability_slope(2,:),'b')
% hold on
% scatter(x,probability_slope(3,:),'r')
% title('斜率数据分类概率值')
% xlabel('样本');
% ylabel('概率');
% h=legend('正常数据','故障1数据','故障2数据','location','northeast');
% set(h,'Box','off');
% set(h,'Fontsize',12);
% 
% % 曲率数据
% [predp3,xulie3]=max(probability_curvature_1);
% % 画出曲率数据分类的概率值
% x=1:length(xulie2);
% figure
% scatter(x,probability_curvature(1,:),'k')
% hold on
% scatter(x,probability_curvature(2,:),'b')
% hold on
% scatter(x,probability_curvature(3,:),'r')
% title('曲率数据分类概率值');
% xlabel('样本');
% ylabel('概率');
% h=legend('正常数据','故障1数据','故障2数据','location','northeast');
% set(h,'Box','off');
% set(h,'Fontsize',12);
