clc;
clear;
close all;

mean1 = 0;  
mean2 = 5;
mean3 = 10;
sigma1 = 3;
sigma2 = 2;
sigma3 = 1.5;



%Plotting pdf from mean/var we picked
data = -10:.1:20;
norm1 = normpdf(data,mean1,sigma1);
plot(data,norm1,'r','LineWidth',2)
hold on;

norm2 = normpdf(data,mean2,sigma2);
plot(data,norm2,'g','LineWidth',2);

norm3 = normpdf(data,mean3,sigma3);
plot(data,norm3,'b','LineWidth',2);

title('Intial Gaussians')
ylim([0 1])

i=1;
%for i=1:1
    
%% Generating 10 Random Samples from the mean and sigma
sample1 = mvnrnd(mean1,sigma1,1000);
sample2 = mvnrnd(mean2,sigma2,1000);
sample3 = mvnrnd(mean3,sigma3,1000);

%% Matlab Implementation
% D = [sample1 ;sample2 ;sample3];
% GMModel = fitgmdist(D,3);
% mean_new(i,:) = GMModel.mu;
% sigma_new(i,:) = [GMModel.Sigma(1) GMModel.Sigma(2) GMModel.Sigma(3)];

%% My implementation
X = [sample1 ;sample2 ;sample3];
[mu,sigma] = em_implementation(X,3,1);
mean_new(i,:) = mu;
sigma_new(i,:) = [sigma(1) sigma(2) sigma(3)];

gmm1 = normpdf(data,mean_new(i,1),sigma_new(i,1));
gmm2 = normpdf(data,mean_new(i,2),sigma_new(i,2));
gmm3 = normpdf(data,mean_new(i,3),sigma_new(i,3));
figure
plot(data,gmm1,'LineWidth',2)
hold on
plot(data,gmm2,'LineWidth',2)
plot(data,gmm3,'LineWidth',2)
title('Gaussians found using GMM')
ylim([0 1])
%pause(1);
%end

%% Matlab Implementation
% GMM_gauss4 = fitgmdist(D,4);
% mean_gauss4 = GMM_gauss4.mu;
% sigma_gauss4 = [GMM_gauss4.Sigma(1) GMM_gauss4.Sigma(2) GMM_gauss4.Sigma(3) GMM_gauss4.Sigma(4)];

%% My Implementation
[mu,sigma] = em_implementation(X,4,1);
mean_gauss4 = mu;
sigma_gauss4 = [sigma(1) sigma(2) sigma(3) sigma(4)];

G1_pdf = gaussian_1D(data,mean_gauss4(1),sigma_gauss4(1));
G2_pdf = gaussian_1D(data,mean_gauss4(2),sigma_gauss4(2));
G3_pdf = gaussian_1D(data,mean_gauss4(3),sigma_gauss4(3));
G4_pdf = gaussian_1D(data,mean_gauss4(4),sigma_gauss4(4));

figure
plot(data,G1_pdf,'LineWidth',2)
hold on
plot(data,G2_pdf,'LineWidth',2)
plot(data,G3_pdf,'LineWidth',2)
plot(data,G4_pdf,'LineWIdth',2)
title('Fitting 4 Gaussians to sample data from 3')
ylim([0 1])

