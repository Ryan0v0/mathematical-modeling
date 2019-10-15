%%
%预处理
tep = zeros(9462,90);%正则化矩阵
tep2 = zeros(9462,1);%最大值
tep3 = zeros(1,90);%信息熵
tep4 = zeros(1,90);%权重
tep5 = zeros(9462,90);%第一次归一化矩阵
tep6 = zeros(9462,90);%第二次归一化矩阵
tep7 = zeros(9462,1);%最大值-最小值
tep8 = zeros(9462,1);%最小值
for i = 1:9462
    tep2(i) = max(sick(i,:));
end
for i = 1:9462
    for j = 1:90
        tep(i,j) = sick(i,j)/tep2(i);
    end
end
%信息熵
for j = 1:90
    for i = 1:9462
        tep3(j) = tep3(j) + tep(i,j)*log(tep(i,j))/log(9462);
    end
end
%权重
sum = 0;
for j = 1:90
    sum = sum + 1- tep3(j);
end
for j = 1:90
    tep4(j) = (1-tep3(j))/sum;
end
%第一次归一化矩阵
for j = 1:90
    for i = 1:9462
        tep5(i,j) = tep(i,j)*tep4(j);
    end
end
%第二次归一化矩阵
for i = 1:9462
    tep7(i) = max(tep5(i,:))-min(tep5(i,:));
end
for i = 1:9462
    tep8(i) = min(tep5(i,:));
end

for j = 1:90
    for i = 1:9462
        tep6(i,j) = (tep5(i,j)- tep8(i))/tep7(i);
    end
end

%%
%相关系数计算
%tep6
count = zeros(10,1);
%计算H(g(i))
JiYin = tep6;
f = 0:0.1:1;
low = f(1:end-1);
low(1)=-0.01;
up = f(2:end);
%
H = [];
for i = 1:9462
    J = JiYin(i,:);
    N=[];
    for j = 1:size(low,2)
        v = find(J>low(j)&J<=up(j));
        n = size(v,2);
        if n~= 0
            N = [N n];
        end
    end
    p = N/size(J,2);
    h = 0;
    for mm = 1:size(p,2)
        h = h - p(mm)*log2(p(mm));
    end
    H = [H h];
end
H = H';
%计算H（）
HH = [];
MI = zeros(9462,9462);

for i = 1:9462
%    Hh=[];
    for j = 1:9462
        MI(i,j)=cov(JiYin(i,:))*cov(JiYin(j,:))/det(cov(JiYin(i,:),JiYin(j,:)));
%         Jh =[JiYin(i,:) JiYin(j,:)];
%         Nh = [];
%         for k = 1:size(low,2)
%             vh = find(Jh>low(k)&Jh<=up(k));
%             nh=size(vh,2);
%             if nh~=0
%                 Nh = [Nh nh];
%             end
%         end
%         ph = Nh/size(Jh,2);
%         hh = 0;
%         for mm = 1:size(ph,2)
%         hh = hh - ph(mm)*log2(ph(mm));
%         end
 %       Hh = [Hh,hh];
    end
  %  HH=[HH;Hh];
end
%计算MI()和r（）
 r = zeros(9462,9462);
 for i = 1:9462
     for j = 1:9462
        % if j~=i
      %       MI(i,j)=H(i)+H(j)-HH(i,j);
             r(i,j)=MI(i,j)/max([H(i) H(j)]);
       %  end
     end
 end
