function [F_final,inlier_points1,inlier_points2] = get_fundamental_8point_RANSAC1(matchedpoints1, matchedpoints2,N)
F_final = zeros(3,3);
sz = int32(size(matchedpoints1,1));
index = 1;
for n=1:N 
    %Select 8 Points at random
    ind = randi(sz,1,8);
    %ind = randperm(sz,8);
    x{n} = matchedpoints1(ind);
    y{n} = matchedpoints2(ind);
    F{n} = get_fundamental_matrix(x{n}.Location, y{n}.Location);
    for i = 1:8
       x2 = [y{n}.Location(i,:)';1];
       x1 = [x{n}.Location(i,:)';1];
       epip_line = F{n} * x1;
       temp_err(i) = abs(x2' * F{n} * x1) / (sqrt(epip_line(1)^2 + epip_line(2)^2));
       
    end
    err(n) = sum(temp_err)/8;
    if err(n)<0.7
       inlier_index(index) = n;
       index = index+1;
   end
end

[~, min_index] = min(err);
F_final = F{min_index};
x_r = x{min_index}.Location;
x_l = y{min_index}.Location;
inlier_index = unique(inlier_index);
inlier_points1 = x{inlier_index(1)};
inlier_points2 = y{inlier_index(1)};
for index = 2:length(inlier_index)
    inlier_points1 = vertcat(inlier_points1,x{inlier_index(index)});
    inlier_points2 = vertcat(inlier_points2,y{inlier_index(index)});
end
