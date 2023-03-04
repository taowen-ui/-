function [Mass, ElapseTime] = SENCEstimation(TestData, Forest,cldi,anomalylambdan)
global id
id=1;

NumInst = size(TestData, 1);    %实例数量，一般为1？

Mass = zeros(Forest.NumTree,5); %矩阵，行为树棵数，列具体含义见Testingpro
et = cputime;
for k = 1:Forest.NumTree
    trave=zeros(2,size(TestData,2));
    ano=anomalylambdan(k);
   
   Mass(k,:) = SENCMass(TestData, 1:NumInst, Forest.Trees{k, 1}, zeros(NumInst, 5),cldi,trave,ano);
end
ElapseTime = cputime - et;
