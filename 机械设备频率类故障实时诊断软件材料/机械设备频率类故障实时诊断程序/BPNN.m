function [rate ,rate_test]=BPNN(trainData,testData)
% clc
% clear all;
% close all; 
% bpResult=[];
% bpResult_test=[];
% for k=1:20       

% tic;           



% load trainData.mat;
% load testData.mat;

X=trainData;
[X,s1]=mapminmax(X,0,1);

t1=[1 0 0 0 0 0 0 0 0 0]';
t2=[0 1 0 0 0 0 0 0 0 0]';
t3=[0 0 1 0 0 0 0 0 0 0]';
t4=[0 0 0 1 0 0 0 0 0 0]';
t5=[0 0 0 0 1 0 0 0 0 0]';
t6=[0 0 0 0 0 1 0 0 0 0]';
t7=[0 0 0 0 0 0 1 0 0 0]';
t8=[0 0 0 0 0 0 0 1 0 0]';
t9=[0 0 0 0 0 0 0 0 1 0]';
t10=[0 0 0 0 0 0 0 0 0 1]';
T=[repmat(t1,1,100),repmat(t2,1,100),repmat(t3,1,100),repmat(t4,1,100),repmat(t5,1,100),repmat(t6,1,100),...
    repmat(t7,1,100),repmat(t8,1,100),repmat(t9,1,100),repmat(t10,1,100)];

net =newff(minmax(X),[100,10],{'logsig','logsig'},'traingdx');
% net.inputweights{1,1}.initFcn='rands';
% net.layers{1}.initFcn='rands';
net.trainParam.show=100;
net.trainParam.epochs = 3000; 
net.trainParam.goal=1e-5; %训练目标 
net.trainParam.lr=0.1;%学习率
net.trainParam.mc=0.05; %动量
net=init(net);%网络初始化
[net,tr] =train(net,X,T); %训练网络

 y=sim(net,X); %仿真输出;
 e=T-y; %误差
disp('均方误差：')
perf=mse(e)  %%均方误差
%  y1 = full(compet(y)) ;  %%%%%%%%%% %竞争输出
y(y>0.99)=1;
y(y<=0.99)=0;
y1=y;
 y2=vec2ind(y1);%向量值变索引值
% figure
% plot(y2,'r*')
% title('BP神经网络故障的检测情况')
pp_lab=[repmat(1,1,100),repmat(2,1,100),repmat(3,1,100),repmat(4,1,100),repmat(5,1,100),...
    repmat(6,1,100),repmat(7,1,100),repmat(8,1,100),repmat(9,1,100),repmat(10,1,100)];



  for i=1:1000      
result(i)=~sum(abs(y2(i)-pp_lab(i)));     %分类正确显示为1；

  end
rate=sum(result)/length(result);   %分类正确率
fprintf('基于BP神经网络training故障分类正确率： %f%%\n',rate*100);
testData=mapminmax('apply',testData,s1);
y_test=sim(net,testData);

err_test=T-y_test;
disp('均方误差:');
perf_test=mse(err_test)

y_test(y_test>0.99)=1;
y_test(y_test<=0.99)=0;
y1_test=y_test;
 y2_test=vec2ind(y1_test);%向量值变索引值
% figure
% plot(y2_test,'r*')
% title('BP神经网络TESTING故障的检测情况')
% pp_lab=[repmat(1,1,100),repmat(2,1,100),repmat(3,1,100),repmat(4,1,100),repmat(5,1,100),...
%     repmat(6,1,100),repmat(7,1,100),repmat(8,1,100),repmat(9,1,100),repmat(10,1,100)];



  for i=1:1000      
result_test(i)=~sum(abs(y2_test(i)-pp_lab(i)));     %分类正确显示为1；

  end
rate_test=sum(result_test)/length(result_test);   %分类正确率
fprintf('基于BP神经网络testing故障分类正确率： %f%%\n',rate_test*100);
end
% time=toc;         % 记录运行时间
% rate(k);

% bpResult=[bpResult,rate*100];
% save bpResult.mat;
% bpResult_test=[bpResult_test,rate_test*100];
% save bpResult_test.mat;
% end
%  figure
% plot(bpResult,'g-o');
% hold on
% plot(bpResult_test,'r-*');
% legend('train','test');
% title('bp train and test accuracy ')
% xlabel('试验次数');
% ylabel('准确率');
 

