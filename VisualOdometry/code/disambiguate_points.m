function [R, t] = disambiguate_points(Cset,Rset,Xset,Xset2)

    C = [0 0 0 0];
   
    for i = 1: 4
        C(i) = sum(Xset2(3,:,i)>0) + sum(Xset(3,:,i)>0);
    end

    if C(1) == 0 && C(2) == 0 && C(3)==0 && C(4)==0
        R = eye(3);
        t = [0;0;0];   
    else
       
        [~, index] = max(C);
        R= Rset{index};
        t = Cset{index};
        if t(3) < 0
            t = -t;
        end
    end
    
    
%     R(1,2) = 0;
%     R(2,1) = 0;
%     R(2,3) = 0;
%     R(3,2) = 0;

    % Noise Reduction
    if abs(R(1,3)) < 0.001
        R(1,3) = 0;
    end
    if abs(R(3,1)) < 0.001
        R(3,1) = 0;
    end  
    
    if abs(t(1))<0.01 || R(1,1) > 0.99 
            t = [0;0;t(3)];
    end
    
end