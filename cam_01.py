import numpy as np
import matplotlib.pyplot as plt

a = np.zeros((100, 136))
u, v = a.shape
for i in range(u):
    for j in range(v):
        if (i + j) % 10 < 2 or (i - j) % 10 < 2:
            a[i, j] = 1


def ner(i, j, a):
    k = a[i - 1:i + 2, j - 1:j + 2]
    k = k.reshape((-1,))
    k = sum(k) - a[i, j]
    return k


def chg(a):
    b = a * 1
    for i in range(1, u - 1):
        for j in range(1, v - 1):
            k = ner(i, j, a)
            if k > 3 or k < 2:
                b[i, j] = 0
            elif k == 3:
                b[i, j] = 1
            elif k == 2:
                b[i, j] = 1 - a[i, j]
    return b


for i in range(36):
    b = np.zeros((u, v, 3))
    for j in range(3):
        b[:, :, j] = a
    a = chg(a)
    plt.imsave(str(i) + '.png', b)
