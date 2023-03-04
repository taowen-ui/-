function Tree = SENCTree(Data, CurtIndex, CurtHeight, Paras,alltraindatalabel)
global flag1 id pathline pathline3
flag1=0;

Tree.Height = CurtHeight;  %当前树高度
NumInst = length(CurtIndex);%当前剩余类实例个数

if CurtHeight >= Paras.HeightLimit || NumInst <= 10  %如果树高达到限高 或 剩余实例太少，即达到叶子结点LeafNode
    if  NumInst > 1
        Tree.NodeStatus = 0; %结点状态，代表叶结点？
        Tree.SplitAttribute = [];
        Tree.SplitPoint = [];
        Tree.LeftChild = [];
        Tree.RightChild = [];
        Tree.Size = NumInst;
        Tree.CurtIndex=CurtIndex;
        Tree.la=alltraindatalabel(CurtIndex,:);
        
        Tree.id=id; 
        id=id+1;
        Tree.center = mean(Data(CurtIndex,:),1);  %列均值
        Tree.dist=max(pdist2(Data(CurtIndex,:),Tree.center));
        if NumInst~=1
            c = 2 * (log(Tree.Size - 1) + 0.5772156649) - 2 * (Tree.Size - 1) / Tree.Size;
        else
            c=0;
        end
        
        Tree.high = CurtHeight + c; %树高，但是c是什么意思
        pathline=[pathline;Tree.high NumInst];%路径，两列，第一列代表树当前高，第二列代表实例个数
        pathline3(CurtIndex)=repmat(Tree.high,1,NumInst);%记录，每个下标代表类实例下标，值代表所在树高度
    else
        Tree.NodeStatus = 0;
        Tree.SplitAttribute = [];
        Tree.SplitPoint = [];
        Tree.LeftChild = [];
        Tree.RightChild = [];
        Tree.Size = NumInst;
        Tree.CurtIndex=CurtIndex;
        Tree.la=alltraindatalabel(CurtIndex,:);
        if  NumInst == 1
            Tree.center=Data(CurtIndex,:);
        end
        Tree.id=id;
        id=id+1;
        flag1=1;
        Tree.high = CurtHeight;
    end
    
    return;
else
    Tree.NodeStatus = 1; %结点状态，代表非叶结点？
    % randomly select a split attribute
    
    [temp, rindex] = max(rand(1, Paras.NumDim));  %随机一个下标索引，对应一个维度
    Tree.SplitAttribute = Paras.IndexDim(rindex); %划分维度
    CurtData = Data(CurtIndex, Tree.SplitAttribute);%提取划分维度数据，提取成1维的
    CurtDatalabel=alltraindatalabel(CurtIndex,:);   %提取的数据对应的label标签
    Tree.SplitPoint = min(CurtData) + (max(CurtData) - min(CurtData)) * rand(1);%随机计算划分点
    % instance index for left child and right children
       
    LeftCurtIndex = CurtIndex(CurtData < Tree.SplitPoint);
    RightCurtIndex = setdiff(CurtIndex, LeftCurtIndex);
    Tree.LeftCurtIndex=LeftCurtIndex;                           %左树实例下标
    Tree.LeftCurtIndexla=alltraindatalabel(LeftCurtIndex,:);    %左树实例对应标签
    Tree.RightCurtIndex=RightCurtIndex;                         %右树实例下标
    Tree.RightCurtIndexla=alltraindatalabel(RightCurtIndex,:);  %右树实例对应标签
    Tree.Size = NumInst;                                        %当前左右树实例总个数
    % bulit right and left child trees
    
    Tree.LeftChild = SENCTree(Data, LeftCurtIndex, CurtHeight + 1, Paras,alltraindatalabel);
    if flag1==1
        Tree.center= mean(Data(RightCurtIndex,:),1);
        Tree.dist=max(pdist2(Data(RightCurtIndex,:),Tree.center));  %这个dist是什么意思？
        Tree.la=alltraindatalabel(RightCurtIndex,:);
        flag1=0;
        
    end
    Tree.RightChild = SENCTree(Data, RightCurtIndex, CurtHeight + 1, Paras,alltraindatalabel);
    if flag1==1
        
        Tree.center = mean(Data(LeftCurtIndex,:));
        Tree.dist=max(pdist2(Data(LeftCurtIndex,:),Tree.center));
        Tree.la=alltraindatalabel(LeftCurtIndex,:);
        flag1=0;
        
    end
    
    iTree.size = [];
    
end
end
