function Forest = SENCForest(Data, NumTree, NumSub, NumDim, rseed,label)    %声名函数SENCForest，返回输出Forest
global id pathline3 pathline   %将id pathline3 pathline声明为全局变量
id=1;
pathline3=[];
pathline=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Parametres%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Forest.NumTree = NumTree;
Forest.NumSub = NumSub;  %论文中的phi
Forest.NumDim = NumDim;
Forest.c = 2 * (log(NumSub - 1) + 0.5772156649) - 2 * (NumSub - 1) / NumSub; %？？？
Forest.rseed = rseed;
rand('state', rseed);
[NumInst, DimInst] = size(Data);   %训练集的行向量与列向量，初始4000行×2维
Forest.Trees = cell(NumTree, 1);
Forest.fruit=unique(label);%"水果种类"，把已知类提取出来，这里是[1;2]
Forest.HeightLimit =200;  %; ceil(log2(NumSub*size(label,1)));
Paras.HeightLimit = Forest.HeightLimit;
Paras.IndexDim = 1:DimInst;
Paras.NumDim = NumDim;
classindex={};%记录不同类的数据，classindex{1}表示第1类数据下标集合

et = cputime;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:size(Forest.fruit,1)      
    classindex{j}=find(label==Forest.fruit(j,1));
end
IndexSub=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:NumTree
    for j=1:size(Forest.fruit,1)
        tempin =classindex{j}; %某类实例的下标
        tempso=randperm(size(tempin,1)); %某类实例的下标(随机之后)
        if size(tempin,1)<NumSub         %这类的实例数量太少了
            fprintf('number of instances is too small.');
            break;
        else
            IndexSub=[IndexSub tempin(tempso(1:NumSub),1)'];  %
        end
    end
    
    pathline=[];
    pathline3=[];
    Forest.Trees{i} = SENCTree(Data, IndexSub, 0, Paras,label);% build an isolation tree
    Forest.Trees{i}.totalid=id-1;   %整个树的编号
    Forest.Trees{i}.pathline=pathline3;
    Forest.Trees{i}.pathline1=pathline;
    tempan= sort(Forest.Trees{i}.pathline1(:,1)');
    
    for j=1:size(tempan,2)                %这里就是Diff确定分界点
        
        varsf(j)=std(tempan(1:j));
        varsb(j)=std(tempan(j:end));
        
        
        vars_rate2(j)=abs(varsf(j)-varsb(j));
    end
    bb=find(vars_rate2==min(vars_rate2));
    Forest.anomaly(i)=tempan(bb(1));      %第i棵树的阈值(路径长度)，每棵树的阈值不尽相同
    IndexSub=[];
    id=1;
    varsf=[];
    varsb=[];
    vars_rate2=[];
    
end

Forest.ElapseTime = cputime - et;
end



