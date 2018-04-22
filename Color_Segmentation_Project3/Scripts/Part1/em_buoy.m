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
norm1 = gaussian_1D(data,mean1,sigma1);
plot(data,norm1,'r','LineWidth',2)
hold on;

norm2 = gaussian_1D(data,mean2,sigma2);
plot(data,norm2,'g','LineWidth',2);

norm3 = gaussian_1D(data,mean3,sigma3);
plot(data,norm3,'b','LineWidth',2);

title('Intial Gaussians')
ylim([0 1])

i=1;
    
%% Generating 10 Random Samples from the mean and sigma
sample1 = mvnrnd(mean1,sigma1,10);
sample2 = mvnrnd(mean2,sigma2,10);
sample3 = mvnrnd(mean3,sigma3,10);
%Try to recover the model parameters used in previous part, using the samples generated.
D = [sample1 ;sample2 ;sample3];%All sample data points in ONE column, for 1D
GMModel = fitgmdist(D,3);%Find a model, 3 components, D hs only 1 column so it is 1 dimensionsal, it will find 3 1D gassians
mean_new(i,:) = GMModel.mu;
sigma_new(i,:) = [GMModel.Sigma(1) GMModel.Sigma(2) GMModel.Sigma(3)];
gmm1 = gaussian_1D(data,mean_new(i,1),sigma_new(i,1));
gmm2 = gaussian_1D(data,mean_new(i,2),sigma_new(i,2));
gmm3 = gaussian_1D(data,mean_new(i,3),sigma_new(i,3));
figure
plot(data,gmm1,'LineWidth',2)
hold on
plot(data,gmm2,'LineWidth',2)
plot(data,gmm3,'LineWidth',2)
title('Gaussians found using GMM')
ylim([0 1])


GMM_gauss4 = fitgmdist(D,4);
mean_gauss4 = GMM_gauss4.mu;
sigma_gauss4 = [GMM_gauss4.Sigma(1) GMM_gauss4.Sigma(2) GMM_gauss4.Sigma(3) GMM_gauss4.Sigma(4)];

%% Plotting 4 fitted gaussians
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
ylim([0 1])

