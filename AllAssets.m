% initializing
clear
clc
load AllData;
P = data;
length = size(P,2);
hold;


% preprecossing
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
        covar(i,j) = sum((D(i,:) - m(i)) .* (D(j,:) - m(j))) / (length-1);
    end
end
covar = covar * multiplier;


% correlations
for i = 1:n
    for j = 1:n
        if i == j
            correl(i, j) = 1;
            plot(covar(i,i), m(i) * multiplier, 'bo', 'LineWidth',2);
            text(covar(i,i), m(i) * multiplier, Assets(i));
        else
            correl(i,j) = covar(i,j) / sqrt(covar(i,i) * covar(j,j));
        end
    end
end


% looking for an optimized a portfolio
num = 2500;
Portfolio = zeros(num,n+2);
weights = zeros(n,1);
for i = 1:num
    r = rand(1,n);
    %     r = [0.31085,0.33717,0.29553,0.05646];
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
[M, I] = max(Portfolio(:,n+1)./sqrt(Portfolio(:,n+2)));
plot(Portfolio(I,n+2),Portfolio(I,n+1),'rx', "LineWidth",2);
clc;
disp("Highest Modified Sharpe Ratio is " + M);
disp("with annual return of " + Portfolio(I,n+1) + " and std dev of " + sqrt(Portfolio(I,n+2)));
disp("and weights of  ");
disp(Portfolio(I,1:n));
disp(Assets);
hold;











