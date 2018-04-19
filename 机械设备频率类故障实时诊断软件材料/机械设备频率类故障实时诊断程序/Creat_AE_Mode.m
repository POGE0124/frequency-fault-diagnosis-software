function[options]=Creat_AE_Mode(inputdata_options,hidden,trainData)
%% 自动编码器简介
%自动编码器是一种无监督的学习算法，利用反向传播算法（bp算法），让输出值等于输入值
%随着隐层的增加，每层神经元个数的递减，自动编码器可以学习到数据的一些压缩表示。
%比如第一隐层用600维表示1200维的数据，到第三隐层仅用一百维就可以表示1200维的数据
%这样数据之间的相关性就必然增加了很多，所以说自动编码器就是学习输入数据相关性的一种表示方法。
%@衡量网络性能所用的函数。默认的performFcn是mse，而可选的也只有四种，
%1、mae Mean absolute error 2、mse Mean squared error
%3、msereg Mean squared error w/reg 4、还有sse
%@权值学习算法，可以有：1、带动量的梯度下降法（traingdm）,
%2、L-M优化算法（trainlm）,3、量化共轭梯度法（traingdm）
%除了上面三种还可以有：traindx,trainda等。
%@节点传递函数（神经元激活函数），可以有：1、双曲正切函数（tansig）
%2、单极性s型函数（logsig）3、线性函数（purelin）
%% 取出参数
learn_rare=hidden.learn_rare;
sample_total=inputdata_options.sample_total;
sample_num=inputdata_options.sample_num;
classes_num=inputdata_options.classes_num;
n_columns=inputdata_options.n_columns;
%%  STEP1 建立第一层自动编码器 %%%%%%%%%%%%%%%%%%%%%
net1=feedforwardnet(hidden.num1);
         net1.name = 'Autoencoder';
         net1.layers{1}.name = 'Encoder'; 
         net1.layers{2}.name = 'Decoder';
         net1.layers{1}.initFcn = 'initwb';
         net1.layers{2}.initFcn = 'initwb';
         net1.inputWeights{1,1}.initFcn = 'rands';
         net1.inputWeights{2,1}.initFcn = 'rands'; 
         net1.biases{1}.initFcn='initzero';
         net1.biases{2}.initFcn='initzero';
         net1.initFcn = 'initlay';  
         net1.performFcn='mse';
         net1.trainFcn='traingdm';
         net1.layers{1}.transferFcn='tansig';
         net1.layers{2}.transferFcn='tansig';
         net1.trainParam.epochs=hidden.net_trainParam_epochs; %训练次数
         net1.trainParam.mc=0.05; %动量
         net1.trainParam.lr=learn_rare;%学习率
net1=init(net1);   %初始化网络
[net1]=train(net1,trainData,trainData); %训练网络  
%% 提取第一隐层特征%%%%%%%%%%
%获取编码网络的权值和偏置
options.w1=net1.iw{1,1}; % 只要编码网络的权值即可，解码网络只是在训练的时候有用
options.b1=net1.b{1};      % 训练后的编码网络的偏置等于（hidden_num1*1）
a1=options.w1*trainData+options.b1*ones(1,n_columns*classes_num);
feature1=tansig(a1);  %用双曲正切激活函数得到第一隐层的特征
%%  STEP2建立第二层自编码器 %%%%%%%%%%%%%%
net2=feedforwardnet(hidden.num2);       
             net2.name = 'Autoencoder';
             net2.layers{1}.name = 'Encoder';
             net2.layers{2}.name = 'Decoder';
             net2.layers{1}.initFcn = 'initwb';
             net2.layers{2}.initFcn = 'initwb';
             net2.inputWeights{1,1}.initFcn = 'rands';
             net2.inputWeights{2,1}.initFcn = 'rands';
             net2.biases{1}.initFcn='initzero';
             net2.biases{2}.initFcn='initzero';
             net2.initFcn = 'initlay';
             net2.performFcn='mse';
             net2.trainFcn='traingdm';       
             net2.layers{1}.transferFcn='tansig';
             net2.layers{2}.transferFcn='tansig';
             net2.trainParam.epochs=hidden.net_trainParam_epochs;
             net2.trainParam.mc=0.05; 
             net2.trainParam.lr=learn_rare;
net2=init(net2);
net2=train(net2,feature1,feature1);
%% 提取第二隐层特征%%%%%%%%%%
options.w2=net2.iw{1,1};
options.b2=net2.b{1};  
a2=options.w2*feature1+options.b2*ones(1,n_columns*classes_num);
feature2=tansig(a2);
%% STEP 3建立第三个自编码器%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
net3=feedforwardnet(hidden.num3);%建立第三层自编码器，神经元个数hidden.num3
        net3.name = 'Autoencoder';
        net3.layers{1}.name = 'Encoder';
        net3.layers{2}.name = 'Decoder';
        net3.layers{1}.initFcn = 'initwb';
        net3.layers{2}.initFcn = 'initwb';
        net3.inputWeights{1,1}.initFcn = 'rands';
        net3.inputWeights{2,1}.initFcn = 'rands';
        net3.biases{1}.initFcn='initzero';    
        net3.biases{2}.initFcn='initzero' ;
        net3.initFcn = 'initlay';
        net3.performFcn='mse';
        net3.trainFcn='traingdm'; 
        net3.layers{1}.transferFcn='tansig';
        net3.layers{2}.transferFcn='tansig';
        net3.trainParam.epochs=hidden.net_trainParam_epochs;
        net3.trainParam.mc=0.05; 
        net3.trainParam.lr=learn_rare;
net3=init(net3);
net3=train(net3,feature2,feature2);
%% 提取第三隐层特征%%%%%%%%%%
options.w3=net3.iw{1,1};
options.b3=net3.b{1};
a3=options.w3*feature2+options.b3*ones(1,n_columns*classes_num);
options.feature3=tansig(a3);