function xy_long = max_length(lines)
    max_len = 0;
    for k = 1:length(lines)
        len = norm(lines(k).point1 - lines(k).point2);
        xy = [lines(k).point1; lines(k).point2];
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
end