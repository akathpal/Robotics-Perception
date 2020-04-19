function [Hset,Rset,Cset] = getting_poses(E)

W = [0 -1 0;1 0 0;0 0 1];
[U,~,V] = svd(E);
R1 = U*W*V';
C = U(:,3);
R2 = U*W'*V';
Hset{1} =[R1 C; 0 0 0 1];
Hset{2} =[R1 -C; 0 0 0 1];
Hset{3} =[R2 C; 0 0 0 1];
Hset{4} =[R2 -C; 0 0 0 1];
for i = 1:4
    if det(Hset{i}(1:3,1:3))<0
        Hset{i}(1:3,1:4) = -Hset{i}(1:3,1:4);
    end
    Rset{i} = Hset{i}(1:3,1:3);
    Cset{i} = Hset{i}(1:3,4);
end