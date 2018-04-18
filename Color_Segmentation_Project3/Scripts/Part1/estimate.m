function [mu,sigma]= estimate(Samples)
total=[0 0 0]';
for i =1:size(Samples,1)
    total=total+double(Samples(i,:)');
end
mu=total/size(Samples,1);
mu = mu';
total=0;
for i =1:size(Samples,1)
    total=total+((double(Samples(i,:)')-mu)*(double(Samples(i,:)')-mu)');
end
sigma=total/size(Samples,1);
end