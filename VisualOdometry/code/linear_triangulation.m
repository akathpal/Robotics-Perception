function [Xset,Xset_new] = linear_triangulation(K,Cset,Rset,x1,x2)
   
    n = size(x1,1);
    x= [x1 ones(n,1)]';
    y = [x2 ones(n,1)]';
    x1 = (inv(K)*x);
    x2 = (inv(K)*y);
    Xset = zeros(4,8,4);
    for j=1:4
        rot = Rset{j};
        t = Cset{j};
        p1 = eye(3,4);
        p2 = [rot t];
        H = [p2; 0 0 0 1];
        
        for i=1:size(x1,2)
            a = [ x1(1,i)*p1(3,:) - p1(1,:); ...
                  x1(2,i)*p1(3,:) - p1(2,:); ... 
                  x2(1,i)*p2(3,:) - p2(1,:); ...
                  x2(2,i)*p2(3,:) - p2(2,:) ];
            
            [~,~,v] = svd(a);
            X = v(:,end);
            Xset(:,i,j) =X./X(4);
            Xset_new(:,i,j) = H*Xset(:,i,j);
        end 
        
    end
end