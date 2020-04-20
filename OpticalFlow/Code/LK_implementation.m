%% -- Lucas-Kanade Implementation -- %%
%-- Homework Perception ENPM673 --%

clc;
clear;
close all;

%% Setting parameters
% Window size
window = 45;
%Downsize factor
factor = 0.5;

%% Set Test data location
test_data = @(i) fullfile(sprintf('../Dataset/Grove/frame%02d.png',i));
% test_data = @(i) fullfile(sprintf('../Dataset/Wooden/frame%02d.png',i));

%% Set output data location
output_data = @(i) fullfile(sprintf('../Output/Grove/frame_w%d_s%d_%02d.png',window,factor,i));
% output_data = @(i) fullfile(sprintf('../Output/Wooden/frame_w%d_s%d_%02d.png',window,factor,i));

for num = 1:7

frame1 = imread(test_data(num+6));
frame2 = imread(test_data(num+7));

frame1_double = im2double(frame1);
frame2_double = im2double(frame2);

% Downsizing image by a factor 
img1 = imresize(frame1_double, factor); 
img2 = imresize(frame2_double, factor); 

w = floor(window/2);
[f_dx,f_dy,f_dt] = partialDerivates(img1,img2); 
u = zeros(size(img1));
v = zeros(size(img2));

for i = w+1:size(f_dx,1)-w
   for j = w+1:size(f_dx,2)-w
      current_fx = f_dx(i-w:i+w, j-w:j+w);
      current_fy = f_dy(i-w:i+w, j-w:j+w);
      current_ft = f_dt(i-w:i+w, j-w:j+w);

      current_fx = current_fx(:);
      current_fy = current_fy(:);
      current_ft = -current_ft(:); 
      
      A = [current_fx current_fy];
      
      % A is not a square matrix, so using pseudo inverse to compute
      % velocity vectors
      vel = pinv(A)*current_ft; 

      u(i,j)=vel(1);
      v(i,j)=vel(2);
   end
end

% Selecting required number of u and v for proper visualization
r = 10;
u = u(1:r:end, 1:r:end);
v = v(1:r:end, 1:r:end);
% Get respective coordinates x and y in original image
[m, n] = size(frame1_double);
[X,Y] = meshgrid(1:n, 1:m);
X = X(1:r/factor:end, 1:r/factor:end);
Y = Y(1:r/factor:end, 1:r/factor:end);

figure(1);
imshow(frame2);
hold on;
%% Plotting quiver/ velocity plot
quiver(X,Y,u,v,1.5,'y')
saveas(gcf,output_data(num));
hold off;
end
