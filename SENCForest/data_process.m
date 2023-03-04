 %数据的读入，应当是通用的


%%%%%%%%%%%%%%%%%%以下为traindata的建立%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data = readtable('kddcup_dataset.txt');   %读入数据，变成table类型
class = data.Var42;                   %找出总类
class_weneed = {'normal.','neptune.','smurf.','back.'}; %训练时知道的类,know_class
todelete = [];                        
for i = 1:size(class,1)
    if sum(strcmp(class(i),class_weneed)) == 0
        todelete = [todelete i];
    end
end

data(todelete,:) = []; %只包含我们需要的known class 的 train_data

train_data_label = data.Var42;                        %字符类型的标签
train_data = removevars(data,["Var2","Var3","Var4"]); %带字符类型的训练集

alltraindata = table2array(removevars(train_data,["Var42"]));  %训练集
alltraindatalabel = [];                                         %训练集的标签

tic
for i = 1:size(train_data_label,1)
    %alltraindatalabel = [alltraindatalabel ; find(strcmp(train_data_label{i,1},class_weneed),1)];
    if strcmp(train_data_label{i,1},'normal.')
        alltraindatalabel = [alltraindatalabel ; 1];
    elseif strcmp(train_data_label{i,1},'neptune.')
        alltraindatalabel = [alltraindatalabel ; 2];
    elseif strcmp(train_data_label{i,1},'smurf.')
        alltraindatalabel = [alltraindatalabel ; 3];
    elseif strcmp(train_data_label{i,1},'back.')
        alltraindatalabel = [alltraindatalabel ; 4];
    end
end
toc

%%%%%%%%%%%%%%%%以下为streamdata的建立%%%%%%%%%%%%%%%%%%%%%%%5
randindex = randperm(size(alltraindatalabel,1));
randindex = randindex(1:1500);
streamdata = alltraindata(randindex,:);
streamdatalabel = alltraindatalabel(randindex,:);
    

%%%%%%%%%%%%%%%最后应当save为.mat文件方便取用，就像示例的那样%%%%%%%%%%%