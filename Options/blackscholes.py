import datetime, numpy as np

def norm_cdf(x):
    s = 0
    x0 = 100
    n = 1000
    for i in range(1,n+1):
        y = -x0 + (x + x0) / n * i
        s = s + np.exp(-(y**2)/2) * (x + x0) / n
    return s/np.sqrt(2*np.pi)

S = 172.57
K = 130
vol = 0.4634
r = 0.0475
dt = ((datetime.date(2023,9,15)-datetime.date(2023,5,12)).days+1)/365
d1 = (np.log(S/K) + ((r + (vol**2) / 2) * dt)) / (vol * np.sqrt(dt))
d2 = d1 - vol * np.sqrt(dt)

cdf_d1 = norm_cdf(d1)
cdf_d2 = norm_cdf(d2)

call_price = S * cdf_d1 - K * np.exp(-r * dt) * cdf_d2
print(call_price)