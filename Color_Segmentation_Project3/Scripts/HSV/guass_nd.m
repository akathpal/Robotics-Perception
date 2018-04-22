clc;clear;close all;

N = input('Enter no of gaussians: ');
D = input('Enter no of dimensions: ');
Mean = zeros(N,D);
Sigma = zeros(N,D);

Mean = randi(20,N,D);
Sigma = randi(20,N,D);

%% Generating samples
temp = [];
data = [];
for n = 1:N
    for m = 1:D
        samples = mvnrnd(Mean(n,m),Sigma(n,m),100);
        temp = [data,samples];
    end
    data = [data ; temp];
    temp = [];
     
end


% %% plotting N gaussians
% for b = 1:N
%     x = Data2(1+100*(b-1):100*b,1)';
%     pd = normpdf(x,Mean(b,:),Sigma(b));
%     plot(x,pd)
%     hold on
% end
% hold off;

%% Fitting N gaussians
GMM = fitgmdist(data,N);
mean_out = GMM.mu;
sigma_out = GMM.Sigma;%there are N  DxD matrices representing covariance matrices for each gaussian

G1_pdf = mvnpdf(data,mean_out(1,:),sigma_out(:,:,1));

% surf(Data(:,1),G1_pdf);
% x= Data2(:,1);
% y = Data2(:,2);
% z = Data2(:,3);
% F = scatteredInterpolant(x,y,z);
% qx = linspace(min(x),max(x),100); % define your grid here
% qy = linspace(min(y),max(y),100);
% [qx,qy] = meshgrid(qx,qy);
% qz = F(qx,qy);
% h = surfc(qx,qy,qz,'LineStyle','none');
