%%
%Ԥ����
tep = zeros(9462,90);%���򻯾���
tep2 = zeros(9462,1);%���ֵ
tep3 = zeros(1,90);%��Ϣ��
tep4 = zeros(1,90);%Ȩ��
tep5 = zeros(9462,90);%��һ�ι�һ������
tep6 = zeros(9462,90);%�ڶ��ι�һ������
tep7 = zeros(9462,1);%���ֵ-��Сֵ
tep8 = zeros(9462,1);%��Сֵ
for i = 1:9462
    tep2(i) = max(sick(i,:));
end
for i = 1:9462
    for j = 1:90
        tep(i,j) = sick(i,j)/tep2(i);
    end
end
%��Ϣ��
for j = 1:90
    for i = 1:9462
        tep3(j) = tep3(j) + tep(i,j)*log(tep(i,j))/log(9462);
    end
end
%Ȩ��
sum = 0;
for j = 1:90
    sum = sum + 1- tep3(j);
end
for j = 1:90
    tep4(j) = (1-tep3(j))/sum;
end
%��һ�ι�һ������
for j = 1:90
    for i = 1:9462
        tep5(i,j) = tep(i,j)*tep4(j);
    end
end
%�ڶ��ι�һ������
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
%���ϵ������
%tep6
count = zeros(10,1);
%����H(g(i))
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
%����H����
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
%����MI()��r����
 r = zeros(9462,9462);
 for i = 1:9462
     for j = 1:9462
        % if j~=i
      %       MI(i,j)=H(i)+H(j)-HH(i,j);
             r(i,j)=MI(i,j)/max([H(i) H(j)]);
       %  end
     end
 end
