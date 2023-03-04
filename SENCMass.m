function mass = SENCMass(Data, CurtIndex, Tree, mass,cldi,trave,ano)
global flag
flag=0;

if Tree.NodeStatus == 0
    mass(CurtIndex,1) = double(Tree.high)<ano;    %判断是否在区域A中，这很容易
    if Tree.Size == 1
        mass(CurtIndex,3)=Tree.la;
        mass(CurtIndex,4)=Tree.id;
        flag=1;
    elseif  Tree.Size<1
        flag=1;
        mass(CurtIndex,4)=Tree.id;
    else
        tempdist=pdist2(Data(CurtIndex,:),Tree.center);      
        mass(CurtIndex,2)=(tempdist>Tree.dist*cldi);   %判断是否在区域B中，这个cldi似乎是超参数？
        mass(CurtIndex,4)=Tree.id;
        
        %%%%%%%%%%%%%%%%%%%%%%label%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%简单投票法选预测label
        ter=Tree.la;
        Scoretrainl =  tabulate(ter);
        Scoretrainl=Scoretrainl(Scoretrainl(:,2)==max(Scoretrainl(:,2)),1);
        if size(Scoretrainl,1)>1
            mass(CurtIndex,3)=Scoretrainl(1,1);
        else
            mass(CurtIndex,3)=Scoretrainl;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if  mass(CurtIndex,2)==1 && mass(CurtIndex,1)==1   %既不在区域K，也不在区域B中，则判定为新类
            mass(CurtIndex,5)=1;
        else
            mass(CurtIndex,5)=0;
        end
    end
    
    return;
else
    
    LeftCurtIndex = CurtIndex(Data(CurtIndex, Tree.SplitAttribute) < Tree.SplitPoint); %找出左子树包含的实例的index
    RightCurtIndex = setdiff(CurtIndex, LeftCurtIndex); %右子树实例index
    trave(1,Tree.SplitAttribute)=1; 
    trave(2,Tree.SplitAttribute)=Tree.SplitPoint;  %属性分界点
    if ~isempty(LeftCurtIndex)
        mass = SENCMass(Data, LeftCurtIndex, Tree.LeftChild, mass,cldi,trave,ano); %迭代
        if flag==1        
            tempdist=pdist2(Data(CurtIndex,:),Tree.center);  %同上
            mass(CurtIndex,2)=(tempdist>Tree.dist*cldi);
            
            if   mass(CurtIndex,1)<ano    && mass(CurtIndex,2)==1
                mass(CurtIndex,5)=1;
            else
                mass(CurtIndex,5)=0;
            end
            ter=Tree.RightCurtIndexla;
            Scoretrainl =  tabulate(ter);
            Scoretrainl=Scoretrainl(Scoretrainl(:,2)==max(Scoretrainl(:,2)),1);
            if size(Scoretrainl,1)>1
                mass(CurtIndex,3)=Scoretrainl(1,1);
            else
                mass(CurtIndex,3)=Scoretrainl;
            end
            flag=0;
        end
    end
    if ~isempty(RightCurtIndex)
        mass = SENCMass(Data, RightCurtIndex, Tree.RightChild, mass,cldi,trave,ano); %迭代
        if flag==1 
            tempdist=pdist2(Data(CurtIndex,:),Tree.center);  %同上
            mass(CurtIndex,2)=(tempdist>Tree.dist*cldi);
            
            if   mass(CurtIndex,1)<ano    &&  mass(CurtIndex,2)==1       
                mass(CurtIndex,5)=1;
            else
                mass(CurtIndex,5)=0;             
            end
            ter=Tree.LeftCurtIndexla;
            Scoretrainl =  tabulate(ter);
            Scoretrainl=Scoretrainl(Scoretrainl(:,2)==max(Scoretrainl(:,2)),1);
            if size(Scoretrainl,1)>1
                mass(CurtIndex,3)=Scoretrainl(1,1);
            else
                mass(CurtIndex,3)=Scoretrainl;
            end
            flag=0;
        end
    end
end

