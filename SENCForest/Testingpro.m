function [result_new]=Testingpro(streamdata,streamdatalabel,model,Para)     %trainsize,window)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Parametres%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
newclasslabel=999;
buffer=[];
result_new=[];
idbuffer=[];
batchdatalabel=[];
batchdatalabel_true=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%testing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:size(streamdata,1)   %此循环就是做预测
%     fprintf('%d True label is %d\n',j,streamdatalabel(j));
    [Mass, mtimetest] = SENCEstimation(streamdata(j,:),model,Para.alpha, model.anomaly);
    %%mass(,1)--pathline; 判断测试实例在树上的长度，是否在区域K中
    %%mass(,2)--distance  判断测试实例是否在闭包区域B中     
    %%mass(,3)--label    预测的label
    %mass(,4)--id to go  需要更新时去的结点id？
    %mass(,5)--new class or not 是否为新类
    answermass=Mass(:,3);
    answermass(find(Mass(:,5)==1),:)=newclasslabel;
    Score =  tabulate( answermass);
    Score_1=Score(Score(:,2)==max(Score(:,2)),:);   %这里存放的就是预测标签
    
    if  Score_1(1)==newclasslabel                     %%resultv(j)>0.5
        buffer=[buffer;streamdata(j,:)];  %放入缓冲区
        idbuffer=[idbuffer Mass(:,4)];    %更新结点时需要去的地方
        % batchdata=[batchdata;onetestinstance];
        batchdatalabel=[batchdatalabel; newclasslabel]; %预测标签
        batchdatalabel_true=[batchdatalabel_true; streamdatalabel(j)];   %事实上的标签
%         fprintf('New class emerging %d\n', size(buffer,1));   %预测新类实例有多少个
        result_new=[result_new;[newclasslabel streamdatalabel(j)]];
    else
        result_new=[result_new;[Score_1(1) streamdatalabel(j)]];
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%retrain%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    if size(buffer,1)>= Para.buffersize          %缓冲区满了，就更新
        tic% && k==1%%   %%fix(trainsize*(0.5))
        model=updatemodel(buffer,model,batchdatalabel,idbuffer);
        toc
        buffer=[];
    end
      fprintf('%d 个实例已预测\n', j);
end



