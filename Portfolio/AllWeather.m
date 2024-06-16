% initializing
clear
clc
load AllData; FiveAssets = data(1:5,:)';
Assets =["TLT", "SPY", "IEF", "Gold", "DBC"];
P = FiveAssets';
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
        covar(i,j) = sum((D(i,:) - m(i)) .* (D(j,:) - m(j))) / (size(D,2)-1);
    end
end
covar = covar * multiplier;


% correlations
for i = 1:n
    for j = 1:n
        if i == j
            correl(i,j) = 1;
            plot(covar(i,i),m(i)*multiplier,'bo','LineWidth',2);
            text(covar(i,i),m(i)*multiplier,Assets(i));
        else
            correl(i,j) = covar(i,j) / sqrt(covar(i,i) * covar(j,j));
        end
    end
end


% looking for an optimized a portfolio
num = 1000;
Portfolio = zeros(num,n+2);
weights = zeros(n,1);
for i = 1:num
    r = rand(1,n);
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
hold;
clc;
disp("Highest Modified Sharpe Ratio found is " + M);
disp("with annual return of " + Portfolio(I,n+1) + " and std dev of " + sqrt(Portfolio(I,n+2)));
disp("and weights of  ");
disp(Assets);
disp(Portfolio(I,1:n));

r = [0.4,0.3,0.15,0.075,0.075];
weights = r ./ sum(r);
profit = sum(weights .* m') * multiplier;
var = 0;
for j = 1:n
    for k = 1:n
        var = var + weights(j) * weights(k) * covar(j,k);
    end
end
hold;
plot(var,profit,'bx', "LineWidth",2);
hold;
disp(" ")
disp ("---- while ----")
disp(" ")
disp("All Weather return is " + profit + " and std dev of " + sqrt(var));
disp("with the weights of  ")
disp(weights);












