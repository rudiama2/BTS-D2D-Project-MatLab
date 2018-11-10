function dist = distance_2_points(Pos_1,Pos_2)

% calculate distance of 2 points
% vector must be x;y times number of points

pom1 = size(Pos_1);
pom2 = size(Pos_2);
pom3 = max(pom1(2),pom2(2));

dist = zeros(1,pom3);

for i = 1:pom1(2)
    for j = 1:pom3
        dist(i,j) = sqrt((Pos_1(1,i)-Pos_2(1,j))^2 + (Pos_1(2,i)-Pos_2(2,j))^2);
    end
end

end