newevaluation=[];

randindex = randperm(size(alltraindatalabel,1));
randindex = randindex(1:1500);
streamdata = alltraindata(randindex,:);
streamdatalabel = alltraindatalabel(randindex,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%trainning process%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NumTree = 100; % number of Tree
NumSub = 100; % subsample size for each class
CurtNumDim=size(alltraindata, 2);%这个应该指的是样例的向量维度
rseed = sum(100 * clock);
set(0,'RecursionLimit',5000) %设置递归最大深度5000
tic
Model = SENCForest(alltraindata, NumTree, NumSub, CurtNumDim, rseed,alltraindatalabel);
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%testing process%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Para.beta=1;%%pathline
Para.alpha=1;%%%distance
Para.buffersize=300;
[Result]=Testingpro(streamdata,streamdatalabel,Model,Para);% eachclassnum,window);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Evaluation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(Result,1)
    newevaluation(i)=sum(Result(1:i,1)==Result(1:i,2))/i;
end
