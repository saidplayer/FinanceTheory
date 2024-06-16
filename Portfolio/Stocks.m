% initializing
clear
clc
load Data2;
Assets =["AMD","NFLX","AAPL","GOOG"];
length = size(data,2);
% plot(0,0);
hold;


% preprecossing
P = data;
period = 1;
multiplier = 252;
P = P(:,1:period:length);
length = size(P,2);
D = (P(:,2:length) - P(:,1:length-1)) ./ P(:,1:length-1);
n = size(D,1);
covar = zeros(n,n);
correl = zeros(n,n);
m = mean(D,2);


% covariances
for i = 1:n
    for j = 1:n
        covar(i,j) = sum((D(i,:) - m(i)) .* (D(j,:) - m(j))) / (size(D,2)-1);
    end
end
covar = covar * multiplier;

% correlations
for i = 1:n
    for j = 1:n
        if i == j
            correl(i,j) = 1;
            plot(covar(i,i),m(i),'bo','LineWidth',2);
            text(covar(i,i),m(i),Assets(i));
        else
            correl(i,j) = covar(i,j) / sqrt(covar(i,i) * covar(j,j));
        end
    end
end


% looking for an optimized a portfolio
num = 1000;
Portfolio = zeros(num,6);
weights = zeros(4,1);
for i = 1:num
    r = rand(1,4);
%     r = [0.31085,0.33717,0.29553,0.05646];
%     r = [1 1 1 1]/4;
    weights = r ./ sum(r);
    profit = sum(weights .* m') * multiplier;
    var = 0;
    for j = 1:n
        for k = 1:n
            var = var + weights(j) * weights(k) * covar(j,k);
        end
    end
    Portfolio(i,:) = [weights, profit, var];
    plot(var,profit,'g.');
end
[M, I] = max(Portfolio(:,5)./sqrt(Portfolio(:,6)));
plot(Portfolio(I,6),Portfolio(I,5),'rx', "LineWidth",2);
hold;
clc;
disp("Highest Modified Sharpe Ratio is " + M);
disp("with annual return of " + Portfolio(I,n+1) + " and std dev of " + sqrt(Portfolio(I,n+2)));
disp("with weights of  " + Portfolio(I,1) + "  " + Portfolio(I,2) + "  " + Portfolio(I,3) + "  " + Portfolio(I,4));


















