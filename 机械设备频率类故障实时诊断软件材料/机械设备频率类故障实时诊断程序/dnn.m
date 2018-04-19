%% DNN子程序
function dnn(Input_Data,inputdata_options,hidden)
%% 参数
fprintf('原始数据训练测试中......');
trainData=Input_Data.trainData_original;
trainLabels=Input_Data.trainLabels;
testData=Input_Data.testData_original;
testLabels=Input_Data.testLabels;
sample_num=inputdata_options.sample_num;
classes_num=inputdata_options.classes_num;
%% STEP 1  原始数据通过堆叠自动编码器进行特征抽取
[options]=Creat_AE_Mode(inputdata_options,hidden,trainData);
%% STEP 2 softmax模型训练过程%%%%%%%%%%%%%%%%%%
sae3Features=options.feature3;%第三层的特征
softlambda = 1e-2; %权值下降参数 每一次迭代更新参数时用到
softoptions.maxIter = 100;%最大迭代次数
softmaxModel = softmaxTrain(hidden.num3, classes_num, softlambda, ...
                            sae3Features, trainLabels, softoptions);
saeSoftmaxOptTheta = softmaxModel.optTheta(:);
%%  STEP 3 fine -tune微调参数  %%%%%%%%%%%%%%%%%%%%%%%
% 将自动编码器学习到的参数堆叠起来
stack = cell(3,1);%3x1的元胞数组
stack{1}.w=options.w1;
stack{2}.w=options.w2;
stack{3}.w=options.w3;
stack{1}.b=options.b1;
stack{2}.b=options.b2;
stack{3}.b=options.b3;
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [  saeSoftmaxOptTheta ; stackparams ];
lambda = 1e-3;         % 权值下降参数
options.Method = 'lbfgs'; %拟牛顿限制内存法
options.alpha=0.05;      %学习率
options.maxIter =hidden.net_trainParam_epochs;	%最大迭代次数
%% STEP 4  最小代价函数minFunc
[stackedAEOptTheta, ~] =  minFunc(@(p)stackedAECost(p,sample_num,hidden.num3,...
                         classes_num, netconfig,lambda,trainData,trainLabels),...
                        stackedAETheta,options);
%% STEP 5: 输出原始训练数据分类精度
[pred_train_original,~] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, trainData);
acc_train_original = mean(trainLabels(:) == pred_train_original(:));
fprintf('训练原始数据分类正确率: %0.2f%%\n', acc_train_original * 100);
%% STEP 6: 输出原始测试数据分类精度
[pred_test_original,probability_original] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, testData);
acc_test_original = mean(trainLabels(:) == pred_test_original(:));
fprintf('测试原始数据分类正确率: %0.2f%%\n', acc_test_original * 100);
%% 保存原始数据训练好的参数
save para11 stackedAEOptTheta
save para12 netconfig
%% 斜率数据%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('斜率数据训练测试中......');
%% STEP 1  原始数据通过堆叠自动编码器进行特征抽取
trainData=Input_Data.trainData_slope;
testData=Input_Data.testData_slope;
[options]=Creat_AE_Mode(inputdata_options,hidden,trainData);
%% STEP 2 softmax模型训练过程%%%%%%%%%%%%%%%%%%
sae3Features=options.feature3;%第三层的特征
softlambda = 1e-3; %权值下降参数 每一次迭代更新参数时用到
softoptions.maxIter = 100;%最大迭代次数
softmaxModel = softmaxTrain(hidden.num3, classes_num, softlambda, ...
                            sae3Features, trainLabels, softoptions);
saeSoftmaxOptTheta = softmaxModel.optTheta(:);
%%  STEP 3 fine -tune微调参数  %%%%%%%%%%%%%%%%%%%%%%%
% 将自动编码器学习到的参数堆叠起来
stack = cell(3,1);%3x1的元胞数组
stack{1}.w=options.w1;
stack{2}.w=options.w2;
stack{3}.w=options.w3;
stack{1}.b=options.b1;
stack{2}.b=options.b2;
stack{3}.b=options.b3;
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [  saeSoftmaxOptTheta ; stackparams ];
lambda = 1e-3;         % 权值下降参数
options.Method = 'lbfgs'; %拟牛顿限制内存法
options.alpha=0.05;      %学习率
options.maxIter =hidden.net_trainParam_epochs;	%最大迭代次数
%% STEP 4  最小代价函数minFunc
[stackedAEOptTheta, ~] =  minFunc(@(p)stackedAECost(p,sample_num,hidden.num3,...
                         classes_num, netconfig,lambda,trainData,trainLabels),...
                        stackedAETheta,options);
%% STEP 5: 输出原始训练数据分类精度
[pred_train_slope,~] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, trainData);
acc_train_slope = mean(trainLabels(:) == pred_train_slope(:));
fprintf('训练斜率数据分类正确率: %0.2f%%\n', acc_train_slope * 100);
%% STEP 6: 输出斜率测试数据分类精度
[pred_test_slope,probability_slope] = stackedAEPredict(stackedAEOptTheta, sample_num,...
    hidden.num3,classes_num, netconfig, testData);
acc_test_slope = mean(testLabels(:) == pred_test_slope(:));
fprintf('测试斜率数据分类正确率: %0.2f%%\n', acc_test_slope * 100);
%% 保存斜率数据训练好的参数
save para21 stackedAEOptTheta
save para22 netconfig
%% 曲率数据%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('曲率数据训练测试中......');
%% STEP 1  原始数据通过堆叠自动编码器进行特征抽取
trainData=Input_Data.trainData_curvature;
testData=Input_Data.testData_curvature;
[options]=Creat_AE_Mode(inputdata_options,hidden,trainData);
%% STEP 2 softmax模型训练过程%%%%%%%%%%%%%%%%%%
sae3Features=options.feature3;%第三层的特征
softlambda = 1e-3; %权值下降参数 每一次迭代更新参数时用到
softoptions.maxIter = 100;%最大迭代次数
softmaxModel = softmaxTrain(hidden.num3, classes_num, softlambda, ...
                            sae3Features, trainLabels, softoptions);
saeSoftmaxOptTheta = softmaxModel.optTheta(:);
%%  STEP 3 fine -tune微调参数  %%%%%%%%%%%%%%%%%%%%%%%
% 将自动编码器学习到的参数堆叠起来
stack = cell(3,1);%3x1的元胞数组
stack{1}.w=options.w1;
stack{2}.w=options.w2;
stack{3}.w=options.w3;
stack{1}.b=options.b1;
stack{2}.b=options.b2;
stack{3}.b=options.b3;
[stackparams, netconfig] = stack2params(stack);
stackedAETheta = [  saeSoftmaxOptTheta ; stackparams ];
lambda = 1e-3;         % 权值下降参数
options.Method = 'lbfgs'; %拟牛顿限制内存法
options.alpha=0.05;      %学习率
options.maxIter =hidden.net_trainParam_epochs;	%最大迭代次数
%% STEP 4  最小代价函数minFunc
[stackedAEOptTheta, ~] =  minFunc(@(p)stackedAECost(p,sample_num,hidden.num3,...
                         classes_num, netconfig,lambda,trainData,trainLabels),...
                        stackedAETheta,options);
%% STEP 5: 输出原始训练数据分类精度
[pred_train_curvature,~] = stackedAEPredict(stackedAEOptTheta, sample_num, hidden.num3, ...
                          classes_num, netconfig, trainData);
acc_train_curvature = mean(trainLabels(:) == pred_train_curvature(:));
fprintf('训练曲率数据分类正确率: %0.2f%%\n', acc_train_curvature * 100);
%% STEP 6: 输出测试曲率数据分类精度
[pred_test_curvature,probability_curvature] = stackedAEPredict(stackedAEOptTheta, sample_num,...
    hidden.num3,classes_num, netconfig, testData);
acc_test_curvature = mean(testLabels(:) == pred_test_curvature(:));
fprintf('测试曲率数据分类正确率: %0.2f%%\n', acc_test_curvature * 100);
%% 保存曲率数据训练好的参数
save para31 stackedAEOptTheta
save para32 netconfig
%% 保存数据
save ('classesResult.mat','acc_train_original','acc_test_original','acc_train_slope','acc_test_slope',...
    'acc_train_curvature','acc_test_curvature');
save ('probabilitypred.mat','probability_original','probability_slope','probability_curvature',...
    'pred_test_original','pred_test_slope','pred_test_curvature','testLabels');
