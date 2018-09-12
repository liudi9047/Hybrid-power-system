clc;clear;
a0=load('pload.txt'); 
state=load('state.txt');
%a=a0'; b0=a(:,[1:3558]); dd0=a(:,[3558:end]); %��ȡ�ѷ���ʹ����������
m = size(a0, 1);

% Randomly select 720 data points to display
rand_indices = randperm(m);     % change the order -jin
rand_indices=rand_indices(1:720);
dd0=a0(rand_indices,:)';

z=a0;
z(rand_indices,:)=[];
b0=z';
state2=state(rand_indices,:);%����֤��ı��
state1=state;
state1(rand_indices,:)=[];   %ѵ����ı��
group=state1;

[b,ps]=mapstd(b0); %�ѷ������ݵı�׼��
dd=mapstd('apply',dd0,ps); %���������ݵı�׼��

% group0=load('state.txt'); %��֪������������
% group=group0(1:3558);
option = statset('MaxIter',3000);
s= svmtrain( b', group, 'Kernel_Function', 'rbf', 'quadprog_opts', option ); 

% s=svmtrain( b', group,'Method','SMO','Kernel_Function','quadratic' ); %ѵ��֧��������������
% sv_index=s.SupportVectorIndices;  %����֧�������ı��
beta=s.Alpha;  %���ط��ຯ����Ȩϵ��
bb=s.Bias;  %���ط��ຯ���ĳ�����
mean_and_std_trans=s.ScaleData; %��1�з��ص�����֪�������ֵ�������෴������2�з��ص��Ǳ�׼�������ĵ���
check=svmclassify(s,b');  %��֤��֪������
err_rate=1-sum(group==check)/length(group)%������֪������Ĵ�����
solution=svmclassify(s,dd'); %�Դ�����������з���
 err_rate2=1-sum(state2==solution)/length(state2)%��֤���ϵĴ�����
