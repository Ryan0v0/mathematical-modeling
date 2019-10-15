r2_sick = zeros(9462,9462);
du_sick = zeros(9462,1);
for i = 1:9462
    for j = 1:9462
        if(r_sick(i,j)>0.4)
            r2_sick(i,j) = 1;
        end
    end
end
for i = 1:9462
    for j = 1:9462
        du_sick(i) = du_sick(i)+r2_sick(i,j);
    end
end
