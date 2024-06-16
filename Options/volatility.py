import numpy as np
from yfinance import download as get_data
import datetime as dt
import matplotlib.pyplot as plt
import time

start_date = dt.datetime.now() - dt.timedelta(days = 365*2)
end_date = dt.datetime.now()
data = get_data("SPY", start_date, end_date)
data = data["Adj Close"]

returns = data.pct_change()
mean_return = returns.mean()
std_dev = returns.std()
print(mean_return, " , ", std_dev*np.sqrt(252))

last_close = data[len(data)-1]
parice_paths=[]
for i in range(2000):
    parice_paths.append([last_close])
    y = np.random.normal(mean_return,std_dev,252)
    for j in range(252):
        parice_paths[i].append((1 + y[j]) * parice_paths[i][j])
    plt.plot(parice_paths[i])
    plt.pause(0.005)

print(last_close * ((1 + mean_return) ** 252), sum([line[-1] for line in parice_paths])/len(parice_paths))
plt.show()