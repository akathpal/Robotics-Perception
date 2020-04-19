function F = get_fundamental_matrix(x1, x2)

sz = size(x1,1);
x1_x = x1(:,1);
x2_x = x2(:,1);
x1_y = x1(:,2);
x2_y = x2(:,2);

%% Scaling for image points for first image
cent1_x = mean(x1(:,1));
cent1_y = mean(x1(:,2));
x1_x = x1_x - cent1_x * ones(sz,1);
x1_y = x1_y - cent1_y * ones(sz,1);
avg_dist = sqrt(sum(x1_x.^2  + x1_y.^2)) / sz;
scaling_1 = sqrt(2) / avg_dist;
x1(:,1) = scaling_1 * x1_x;
x1(:,2) = scaling_1 * x1_y;


Scaled_1 = [scaling_1,         0,(-scaling_1*cent1_x);
                    0, scaling_1,(-scaling_1*cent1_y);
                    0,         0,                    1];  
%% Scaling for image points for first image
cent2_x = mean(x2_x);
cent2_y = mean(x2_y);
x2_x = x2_x - cent2_x * ones(sz,1);
x2_y = x2_y - cent2_y * ones(sz,1);
avg_dist = sqrt(sum(x2_x.^2  + x2_y.^2)) / sz;
scaling_2 = sqrt(2) / avg_dist;
x2(:,1) = scaling_2 * x2_x;
x2(:,2) = scaling_2 * x2_y;
Scaled_2 = [scaling_2 0 -scaling_2*cent2_x;
       0 scaling_2 -scaling_2*cent2_y;
       0 0 1];


W = [x1(:,1).* x2(:,1) x1(:,1).* x2(:,2) x1(:,1) x1(:,2).* x2(:,1) x1(:,2) .* x2(:,2) x1(:,2) x2(:,1) x2(:,2) ones(size(x1,1),1)];
[~,~,v] = svd(W);
F = v(:,end);
F =reshape(F,3,3);
F_norm = F / norm(F);
[uf,sf,vf] = svd(F_norm);

F_final = uf*diag([sf(1) sf(5) 0])*(vf');

%% Denormalizing
F = Scaled_2' * F_final * Scaled_1;
end

