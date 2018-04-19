function [y0,Y_train,y2,y3]=data_test3()
%%%%%%%%%%%%%%%%%参量的产生(泊松分布)%%%%%%%%%%%%%%%%%%%%%
n=1000;%样本个数
t01=exprnd(0.13,1,n);%生成参数lambda为0.13的指数分布随机数
t02=exprnd(0.08,1,n);
t03=exprnd(0.11,1,n);
t04=exprnd(0.2,1,n);
t0=[t01;t02;t03;t04]; %4*n
% plot
for i=1:4
    figure(1)
    subplot(4,1,i);
    plot(t0(i,:))
end
%%%%%%%%%%%%%%%%%%% 非线性组合 %%%%%%%%%%%%%%%%%%%%
y01=sin(t01)+0.01*tan(t02).*sqrt(t04)+0.01*randn(1,n);  %1*n
y02=0.6*t04.*t01+exp(t01)+0.01*log2(t03)+0.02*randn(1,n);
y03=0.5*log(t01).*t02+sin(t03)+0.01*randn(1,n);
y04=0.0001*exp(t01.*t02)+0.3*sin(t03)+0.03*randn(1,n);
y05=0.5*t01+t03.*sqrt(t04)+0.01*randn(1,n);
y06=0.6*sin(t03)+0.21*cot(t01).*t02+0.01*randn(1,n);
y07=0.36*t04.*t01+cos(t03)+0.02*randn(1,n);
y08=0.01*log10(t03)+0.5*tan(t04).*t02+0.01*randn(1,n);
y09=0.6*tan(t04)+0.1*log2(t03)+0.01*t01.*t02+0.05*randn(1,n);
y010=0.5*sqrt(t01.*t03).*sin(t04)+0.1*log(t02)+0.01*randn(1,n);
%正常数据的产生
y0=[y01;y02;y03;y04;y05;y06;y07;y08;y09;y010];  %10*n
%plot
for i=1:10
    figure(2)
    subplot(5,2,i);
     plot(y0(i,:))
end 
%%%%%%%%%% 故障数据的产生  %%%%%%%%%%%
% Y=zeros(size(y0,1),n,3);
% for i=1:3
t11=exprnd(0.13,1,n);%生成参数lambda为0.13的指数分布随机数
t12=exprnd(0.08,1,n);
t13=exprnd(0.11,1,n);
t14=exprnd(0.2,1,n);
%加故障1
tem1=linspace(0.12,10,n);
tao1=2.9;
C1=5;
f1=C1*(1-exp(-tem1/tao1));
t11(3*n/10:n)=t01(3*n/10:n)+f1(1:7*n/10+1);%从第300个样本点加入故障
%加故障2
tem2=linspace(0.06,12,n);
tao2=4;
C2=8.9;
f2=C2*(1-exp(-tem2/tao2));
t12(400:n)=t02(400:n)+f2(1:601);%从第400个样本点加入故障

t1=[t11;t12;t13;t14]; %4*n
for i=1:4
    figure(3)
    subplot(4,1,i);
    plot(t1(i,:))
end

y11=sin(t11)+0.01*tan(t12).*sqrt(t14)+0.01*randn(1,n);%1*n
y12=0.6*t14.*t11+exp(t11)+0.01*log2(t13)+0.02*randn(1,n);
y13=0.5*log(t11).*t12+sin(t13)+0.01*randn(1,n);
y14=0.0001*exp(t11.*t12)+0.3*sin(t13)+0.02*t14+0.03*randn(1,n);
y15=0.5*t11+t13.*sqrt(t14)+0.01*randn(1,n);
y16=0.6*sin(t13)+0.21*cot(t11).*t12+0.01*randn(1,n);
y17=0.36*t14.*t11+cos(t13)+0.02*randn(1,n);
y18=0.01*log10(t13)+0.5*tan(t14).*t12+0.01*randn(1,n);
y19=0.6*tan(t14)+0.1*log2(t13)+0.01*t11.*t12+0.05*randn(1,n);
y110=0.5*sqrt(t11.*t13).*sin(t14)+0.1*log(t12)+0.01*randn(1,n);

y1=[y11;y12;y13;y14;y15;y16;y17;y18;y19;y110];  %10*n
for i=1:10
    figure(4)
    subplot(5,2,i);
     plot(y1(i,:))
end 
%%%%%%%%%%%%%  测试数据  %%%

t21=exprnd(0.13,1,n);%生成参数lambda为0.13的指数分布随机数
t22=exprnd(0.08,1,n);
t23=exprnd(0.11,1,n);
t24=exprnd(0.2,1,n);
%加故障1
tem1=linspace(0.12,10,n);
tao1=2.9;
C1=5;
f1=C1*(1-exp(-tem1/tao1));
t21(3*n/10:n)=t01(3*n/10:n)+f1(1:7*n/10+1);%从第300个样本点加入故障
%加故障2
tem2=linspace(0.06,12,n);
tao2=4;
C2=8.9;
f2=C2*(1-exp(-tem2/tao2));
t22(400:n)=t02(400:n)+f2(1:601);%从第400个样本点加入故障

t2=[t21;t22;t23;t24]; %4*n
for i=1:4
    figure(5)
    subplot(4,1,i);
    plot(t2(i,:))
end

y21=sin(t21)+0.01*tan(t22).*sqrt(t24)+0.01*randn(1,n);%1*n
y22=0.6*t24.*t21+exp(t21)+0.01*log2(t23)+0.02*randn(1,n);
y23=0.5*log(t21).*t22+sin(t23)+0.01*randn(1,n);
y24=0.0001*exp(t21.*t22)+0.3*sin(t23)+0.02*t24+0.03*randn(1,n);
y25=0.5*t21+t23.*sqrt(t24)+0.01*randn(1,n);
y26=0.6*sin(t23)+0.21*cot(t21).*t22+0.01*randn(1,n);
y27=0.36*t24.*t21+cos(t23)+0.02*randn(1,n);
y28=0.01*log10(t23)+0.5*tan(t24).*t22+0.01*randn(1,n);
y29=0.6*tan(t24)+0.1*log2(t23)+0.01*t21.*t22+0.05*randn(1,n);
y210=0.5*sqrt(t21.*t23).*sin(t24)+0.1*log(t22)+0.01*randn(1,n);

y2=[y21;y22;y23;y24;y25;y26;y27;y28;y29;y210];  %10*n
for i=1:10
    figure(6)
    subplot(5,2,i);
     plot(y2(i,:))
end 
%%%%%%%%%%%%%%    预测数据  %%%%%%%%%%%%%%%%%%%%%%
t31=exprnd(0.13,1,n);%生成参数lambda为0.13的指数分布随机数
t32=exprnd(0.08,1,n);
t33=exprnd(0.11,1,n);
t34=exprnd(0.2,1,n);
%加故障1
tem1=linspace(0.12,10,n);
tao1=2.9;
C1=5;
f1=C1*(1-exp(-tem1/tao1));
t31(3*n/10:n)=t01(3*n/10:n)+f1(1:7*n/10+1);%从第300个样本点加入故障
%加故障2
tem2=linspace(0.06,12,n);
tao2=4;
C2=8.9;
f2=C2*(1-exp(-tem2/tao2));
t32(400:n)=t02(400:n)+f2(1:601);%从第400个样本点加入故障

t3=[t31;t32;t33;t34]; %4*n
for i=1:4
    figure(7)
    subplot(4,1,i);
    plot(t3(i,:))
end

y31=sin(t31)+0.01*tan(t32).*sqrt(t34)+0.01*randn(1,n);%1*n
y32=0.6*t34.*t31+exp(t31)+0.01*log2(t33)+0.02*randn(1,n);
y33=0.5*log(t31).*t32+sin(t33)+0.01*randn(1,n);
y34=0.0001*exp(t31.*t32)+0.3*sin(t33)+0.02*t34+0.03*randn(1,n);
y35=0.5*t31+t33.*sqrt(t34)+0.01*randn(1,n);
y36=0.6*sin(t33)+0.21*cot(t31).*t32+0.01*randn(1,n);
y37=0.36*t34.*t31+cos(t33)+0.02*randn(1,n);
y38=0.01*log10(t33)+0.5*tan(t34).*t32+0.01*randn(1,n);
y39=0.6*tan(t34)+0.1*log2(t33)+0.01*t31.*t32+0.05*randn(1,n);
y310=0.5*sqrt(t31.*t33).*sin(t34)+0.1*log(t32)+0.01*randn(1,n);

y3=[y31;y32;y33;y34;y35;y36;y37;y38;y39;y310];  %10*n
for i=1:10
    figure(8)
    subplot(5,2,i);
     plot(y3(i,:))
end 

Y_train=[y0 y1];%训练数据  10*2n（包含正常数据和故障数据，故障数据在不同样本点发生异常）

  %   y2 测试数据  （故障数据）
% y3  %在线预测用数据
end