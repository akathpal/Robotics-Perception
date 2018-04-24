clc;
clear;
close all;

%% Picking Random Mean and Sigma
mean1 = 0;  
mean2 = 5;
mean3 = 10;
sigma1 = 3;
sigma2 = 2;
sigma3 = 1.5;

data = -10:.1:20;
norm1 = gaussian_1D(data,mean1,sigma1);
figure,
plot(data,norm1,'r','LineWidth',2)
hold on;

norm2 = gaussian_1D(data,mean2,sigma2);
plot(data,norm2,'g','LineWidth',2);

norm3 = gaussian_1D(data,mean3,sigma3);
plot(data,norm3,'b','LineWidth',2);

title('Intial Gaussians')
ylim([0 2])

    
%% Generating 10 Random Samples from the mean and sigma
sample1 = mvnrnd(mean1,sigma1,10);
sample2 = mvnrnd(mean2,sigma2,10);
sample3 = mvnrnd(mean3,sigma3,10);
D = [sample1 ;sample2 ;sample3];

%% Matlab Implementation
GMModel = fitgmdist(D,3);
mean_new = GMModel.mu;
sigma_new = [GMModel.Sigma(1) GMModel.Sigma(2) GMModel.Sigma(3)];
gmm1 = gaussian_1D(data,mean_new(1),sigma_new(1));
gmm2 = gaussian_1D(data,mean_new(2),sigma_new(2));
gmm3 = gaussian_1D(data,mean_new(3),sigma_new(3));
figure,
plot(data,gmm1,'LineWidth',2)
hold on
plot(data,gmm2,'LineWidth',2)
plot(data,gmm3,'LineWidth',2)
title('3 Gaussians computed using GMM-MATLAB')
ylim([0 2])

%% My implementation
[mean_new,sigma_new] = em_implementation(D,3,1,1e-2);
gmm1 = gaussian_1D(data,mean_new(1),sigma_new(1));
gmm2 = gaussian_1D(data,mean_new(2),sigma_new(2));
gmm3 = gaussian_1D(data,mean_new(3),sigma_new(3));
figure,
plot(data,gmm1,'LineWidth',2)
hold on
plot(data,gmm2,'LineWidth',2)
plot(data,gmm3,'LineWidth',2)
title('3 Gaussians computed using my-GMM')
ylim([0 2])

%% Matlab Implementation
GMM_gauss4 = fitgmdist(D,4);
mean_gauss4 = GMM_gauss4.mu;
sigma_gauss4 = [GMM_gauss4.Sigma(1) GMM_gauss4.Sigma(2) GMM_gauss4.Sigma(3) GMM_gauss4.Sigma(4)];
G1_pdf = gaussian_1D(data,mean_gauss4(1),sigma_gauss4(1));
G2_pdf = gaussian_1D(data,mean_gauss4(2),sigma_gauss4(2));
G3_pdf = gaussian_1D(data,mean_gauss4(3),sigma_gauss4(3));
G4_pdf = gaussian_1D(data,mean_gauss4(4),sigma_gauss4(4));
figure,
title('4 Gaussians computed using MATLAB-GMM')
plot(data,G1_pdf,'LineWidth',2)
hold on
plot(data,G2_pdf,'LineWidth',2)
plot(data,G3_pdf,'LineWidth',2)
plot(data,G4_pdf,'LineWIdth',2)
ylim([0 2])

%% My implementation
[mean_gauss4,sigma_gauss4] = em_implementation(D,4,1,1e-2);
G1_pdf = gaussian_1D(data,mean_gauss4(1),sigma_gauss4(1));
G2_pdf = gaussian_1D(data,mean_gauss4(2),sigma_gauss4(2));
G3_pdf = gaussian_1D(data,mean_gauss4(3),sigma_gauss4(3));
G4_pdf = gaussian_1D(data,mean_gauss4(4),sigma_gauss4(4));
figure,
title('4 Gaussians computed using my-GMM')
plot(data,G1_pdf,'LineWidth',2)
hold on
plot(data,G2_pdf,'LineWidth',2)
plot(data,G3_pdf,'LineWidth',2)
plot(data,G4_pdf,'LineWIdth',2)
ylim([0 2])

