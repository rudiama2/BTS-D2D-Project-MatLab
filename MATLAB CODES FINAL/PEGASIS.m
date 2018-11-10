clear all
close all
area =800;
s_number=15;
x=rand(1,s_number).*area;
y=rand(1,s_number).*area;

%------------------------------------------------

dis_from_sink=zeros(1,s_number);
for i=1:s_number
dis_from_sink(i)=sqrt(((x(i)-area)^2)+((y(i)-area)^2));
end
[~,index_start_chain]=max(dis_from_sink);
[~,index_leader_chain]=min(dis_from_sink);

used_group=[];
for ii=1:(s_number-1)
    if ii==1
        current_s=index_start_chain;
        chosen_s(ii)=current_s;
    end
    used_group=[used_group,current_s];
    for iii=1:s_number
        if  ismember(iii,used_group)==0
        dis_from_others(iii)=sqrt(((x(current_s)-x(iii))^2)+((y(current_s)-y(iii))^2));
        else
            dis_from_others(iii)=2*(area^2);
        end
    end
    [~,chosen_s(ii+1)]=min(dis_from_others);
    current_s=chosen_s(ii+1);

end
chain_of_s=chosen_s;
index_leader_in_chain=find(chain_of_s==index_leader_chain);
first_chain=chain_of_s(1:index_leader_in_chain);
second_chain=fliplr(chain_of_s(index_leader_in_chain:end));

xx=x;
yy=y;
xx(index_leader_chain)=[];
yy(index_leader_chain)=[];

figure
p2 = scatter(xx,yy);
% darkred=[178 34 4] ./ 255;
% set(p2,'Marker','o','LineWidth',1.5)

hold on
scatter(x(index_leader_chain),y(index_leader_chain),'sm')
hold on
scatter(area,area,'xr')
% hold on
% scatter(x(chain_of_s(1)),y(chain_of_s(1)),'<m');
hold on
p1 = plot(x(chain_of_s),y(chain_of_s));

% set(p1,'Color','b','Marker','o','LineWidth',1.4)


%----------------------------------





sss=2;