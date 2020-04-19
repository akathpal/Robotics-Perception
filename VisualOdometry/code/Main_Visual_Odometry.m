%% Initialization

clc;clear;close all;
load MatchedSURFPoints;
load K;
load location_mat;
cameraParams = cameraParameters('IntrinsicMatrix', K');

R_t = eye(3);
t_t = [0;0;0];
location = [0,0];

R_mat = eye(3);
t_mat = [0;0;0];
%location_mat = [0,0];


N = 800;
%l = 300;


tic

for i=19:size(MatchedSURFPoints,1)
    figure(1);
    
    matchedPoints1 = MatchedSURFPoints{i,1}{1,1};
    matchedPoints2 = MatchedSURFPoints{i,1}{1,2};
   
%     if (i>60 && i<100) || (i>2300 && i<2600)
%     continue;
%     end
    %% Fundamental Matrix
    %[F,inlier_points1,inlier_points2] = get_fundamental_8point_RANSAC(matchedPoints1,matchedPoints2,N,l); 
    [F,inlier_points1,inlier_points2] = get_fundamental_8point_RANSAC1(matchedPoints1,matchedPoints2,N); 
    E=K'*F*K;
    [u,d,v]=svd(E);
    E=u*diag([1,1,0])*v';
    E = E/norm(E);

    [Hset,Rset,Cset] = getting_poses(E);
    
    [Xset,Xset_new] = linear_triangulation(K,Cset,Rset,inlier_points1.Location,inlier_points2.Location);
    [R, t] = disambiguate_points(Cset,Rset,Xset,Xset_new);

    t_t = t_t + R_t * t;
    R_t = R_t * R;
    location = [location;[t_t(1),t_t(3)]];
%% MATLAB Implementation

%     [F_matlab,inlierIdx] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,...
%         'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
%     [relativeOrientation,relativeLocation] = relativeCameraPose(F_matlab,cameraParams,...
%         matchedPoints1.Location(inlierIdx,:),matchedPoints2.Location(inlierIdx,:));
%     R1 = relativeOrientation;
%     t1 = relativeLocation';
%     t_mat = t_mat + R_mat * t1;
%     R_mat = R_mat * R1;
%     location_mat = [location_mat;[t_mat(1),t_mat(3)]];
     
    
    %% Plotting Data
%     disp(i);
%     figure(1);
%     axis([-100 1100 -300 1000]);
%     pause(0.01);
%     title('Camera Trajectory');
%     plot(-location(:,1), location(:,2),'b-','LineWidth',4);
%     hold on;
%     plot(-location_mat(:,1), location_mat(:,2),'k-','LineWidth',4);
%     legend('camera','camera-Matlab','Location','northeast');
    
%     cd ..;
%     cd output;
%     cd n20;
%     file = sprintf('image_%d.jpg',i);
%     saveas(figure(1),file);
%     cd ..;
%     cd ..;
%     cd code;
end

drift = get_trajectory_drift(location,location_mat);
title_name = sprintf('Camera-Trajectory-with-N-%d-and-drift-%d.jpg',N,drift);
figure(3);
title(title_name);
plot(-location(:,1), location(:,2),'b-','LineWidth',4);
hold on;
plot(-location_mat(:,1), location_mat(:,2),'k-','LineWidth',4);
hold off
legend('camera','camera-Matlab','Location','northwest');
%cd ..;
%cd output;
saveas(figure(3),title_name);
display(drift);

toc




