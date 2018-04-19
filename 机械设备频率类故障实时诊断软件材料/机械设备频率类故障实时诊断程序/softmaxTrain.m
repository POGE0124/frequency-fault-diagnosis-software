%% softmaxTrain Train%%%%%%%%%%%%%%
%输入参数： inputSize: 输入向量大小（自动编码器第三隐层神经元个数）
% numClasses: 分类数（10）
% lambda: 权重下降参数1e-3; %权值下降参数 每一次迭代更新参数时用到
% inputData: 输入数据（第三层特征）
% labels: 输入训练数据 的 标签
% options (optional): options
% options.maxIter: 训练时的迭代次数
%输入参数：softmaxModel（结构体）
function [softmaxModel] = softmaxTrain(inputSize, numClasses, lambda, inputData, labels, options)
%% exist('im', 'var')是检测im中的变量是否存在，如果不存在返回0，存在返回1。
%~exist('im', 'var')是对结果取非运算
if ~exist('options', 'var')%如果不存在一个options的结构体则执行if里面的句子
    options = struct;%定义一个结构体options（由于之前定义了所以这个语句未执行）
end
%% 通过函数fieldnames来获取字段名称（结构体的所有属性）
%通过函数isfield来判断是否存在某一字段
%如果结构体options中存在maxIter属性，则为1，再~取反，则为0，那么if里面的句子不执行。
if ~isfield(options, 'maxIter')
    options.maxIter = 200;%实际未执行
end
%%  初始化参数%%%%%%%%%
theta = 0.005 * randn(numClasses * inputSize, 1);%随机初始化参数theta（1000x1）
%% 用最小化代价函数minFunc去训练参数
addpath minFunc/            %添加最小化函数所在的文件夹的路径
%拟牛顿限制内存法%比梯度下降法好的多
%给结构体添加属性可以直接写，但是删除要用Rmfield函数
options.Method = 'lbfgs'; 
%调用minFunc函数去调整参数Theta。函数返回的softmaxOptTheta：1000x1
[softmaxOptTheta] = minFunc( @(p) softmaxCost(p,numClasses, inputSize, lambda,inputData, labels),theta, options);
% 调整下Theta的结构为10x100
softmaxModel.optTheta = reshape(softmaxOptTheta, numClasses, inputSize);
softmaxModel.inputSize = inputSize;%100
softmaxModel.numClasses = numClasses;%10
end                          
