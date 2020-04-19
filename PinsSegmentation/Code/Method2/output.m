function output(r,g,b,y,wt,rc,gc,bc,yc,wtc)
fprintf('No. of red objects and their locations are : %d.\n', r);
for i=1:1:size(rc,1)
    display(rc(i));
end
fprintf('No. of green objects are : %d.\n', g);
for i=1:1:size(gc,1)
    display(gc(i));
end
fprintf('No. of blue objects are : %d.\n', b);
for i=1:1:size(bc,1)
    display(bc(i));
end
fprintf('No. of yellow objects are : %d.\n', y);
for i=1:1:size(yc,1)
    display(yc(i));
end
fprintf('No. of white and transparent objects are : %d.\n', wt);
for i=1:1:size(wtc,1)
    display(wtc(i));
end