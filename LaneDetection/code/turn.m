function [turn_direction,ml,cl,mr,cr] = turn(xy_left,xy_right)
    
    p1 = polyfit(xy_left(:,1),xy_left(:,2),1);
    p2 = polyfit(xy_right(:,1),xy_right(:,2),1);
    x_intersect = fzero(@(x) polyval(p1-p2,x),3);
    %y_intersect = polyval(p1,x_intersect);
    ml = p1(1);
    cl = p1(2);
    mr = p2(1);
    cr = p2(2);
    center = 640;
    turn = x_intersect - center; 
    if turn<-18
        turn_direction = 'left';
    elseif turn>18
        turn_direction = 'right';
    else
        turn_direction = 'straight';
    end
end