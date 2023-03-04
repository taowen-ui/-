
% SENCForest.
% This is main program. art4 is simulated toydata by two dimension.
% 
% This package was developed by Mr. Mu. For any problem concerning the code, please feel free to contact Mr. Mu.
% 中文注释是我本人加入的

newevaluation=[];
Input_dataset=art4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Parametres%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
train_num=2;  %Known Classes
newclass_num=1;
num_per_class=2000;
alltraindata=[];
alltraindatalabel=[];
streamdata=[];
streamdatalabel=[];
ALLindex=[1 2 3];%randperm(size(Input_dataset(:,1),1)); %class index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Random Instaces%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i =1:size(Input_dataset(:,1),1)
    dataindex=randperm(size(Input_dataset{i,1},1));
    %testdataindex1=randperm(size(Input_dataset{i,1},2));
    datatemp=Input_dataset{i,1};
    datatemp=datatemp(dataindex',:);        %'代表转置
    datatemp=full(datatemp(dataindex,:));
    Input_dataset{i,1}=datatemp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Train Instaces%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:train_num
    datatemp=Input_dataset{ALLindex(i),1};
    traindata{i,1}=datatemp(1:num_per_class,:);
    traindata{i,2}=Input_dataset{ALLindex(i),2} ;
    alltraindata=[alltraindata;traindata{i,1}] ;
    alltraindatalabel=[alltraindatalabel;ones(size(traindata{i,1},1),1)*traindata{i,2}];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Test Instaces%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testdata1={};
for i=1:train_num+newclass_num
    datatemp=Input_dataset{ALLindex(i),1};
    testdata{i,1}=datatemp(num_per_class+1:num_per_class+500,:);
    if i<=train_num
        testdata{i,2}=Input_dataset{ALLindex(i),2};
    else
        testdata{i,2}=999; %new class
    end
    streamdata=[streamdata;testdata{i,1}];
    streamdatalabel=[streamdatalabel;ones(size(testdata{i,1},1),1)*testdata{i,2}];
end
randindex=randperm(size(streamdata,1));%打乱重排
streamdata=streamdata(randindex,:);
streamdatalabel=streamdatalabel(randindex,:);

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

