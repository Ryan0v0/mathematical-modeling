import numpy as np
import queue
import copy
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
font = FontProperties(fname='/Library/Fonts/Songti.ttc')

# 输入参数
total_time = int(input("输入模拟时间 (小时): "))
IAT_rate = int(input("输入顾客到达速率 (/小时): "))
ST_rate = int(input("输入服务器服务速率 (/小时): "))
queue_limit=int(input("输入队列最大长度 (人): "))
rho = IAT_rate / ST_rate

# 初始化参数
qu = queue.Queue()
curr_process = None
IAT = []
ST = []
AT = []
wait_time = []
server_busy = False
list_wait = []
list_delay = []
list_queue_wait = []
list_server_busy = []

# 泊松分布取随机数 总共需要服务的人数
num_processes = int(np.random.poisson(IAT_rate) * total_time)
num_processes_served = 0

# 计算顾客到达时间间隔IAT (Inter-Arrival-Times)
for i in range(num_processes):
    temp = np.random.exponential(1 / IAT_rate) * 60 * 60
    if i == 0:
        IAT.append(0)
    else:
        IAT.append(int(temp - temp % 1))

# 计算服务器服务时长ST (Service-Times)
while not len(ST) == num_processes:
    temp = np.random.exponential(1 / ST_rate) * 60 * 60
    if not int(temp - temp % 1) < 1:
        ST.append(int(temp - temp % 1))

# 保存ST值
ST_copy = copy.deepcopy(ST)

# 计算顾客到达时间AT (Arrival-Times) 并将等待时间(Waiting-Times)初始化为0
for i in range(num_processes):
    if i == 0:
        AT.append(0)
    else:
        AT.append(AT[i - 1] + IAT[i])
    wait_time.append(0)

# 仿真模拟 M/M/1
# (i表示当前时间)
sum_queue_wait=0
sum_server_busy=0
for i in range(total_time * 60 * 60):
    print("当前第{}秒:\n".format(i))
    if server_busy:
        print("顾客{}正在接受服务\n".format(curr_process))
        print("当前已服务人数:{}\n".format(num_processes_served))
        for item in list(qu.queue):
            wait_time[item] = wait_time[item] + 1
        ST[curr_process] = ST[curr_process] - 1
        if ST[curr_process] == 0:
            server_busy = False
            num_processes_served = num_processes_served + 1
            print("顾客{}已服务完毕\n".format(curr_process))

    for j in range(num_processes):
        if i == AT[j] and qu.qsize()<queue_limit:
            qu.put(j)
            print("顾客{}进入等待队列，当前等待人数：{}\n".format(j,qu.qsize()))

    if not server_busy and not qu.empty():
        curr_process = qu.get()
        print("顾客{}开始接受服务\n".format(curr_process))
        server_busy = True

    if not server_busy:
        print("当前服务器闲置\n")

    if qu.qsize()==queue_limit:
        print("当前等待队列已满\n")

    sum_queue_wait += qu.qsize()
    list_queue_wait.append(sum_queue_wait / (i+1))

    sum_server_busy += server_busy
    list_server_busy.append(sum_server_busy/ (i+1))

    sum_wait = 0
    sum_delay = 0

    for i in range(num_processes_served):
        sum_wait = sum_wait + wait_time[i]
        sum_delay = sum_delay + wait_time[i] + ST_copy[i]

    if num_processes_served == 0:
        list_wait.append(0)
        list_delay.append(0)
    else:
        list_wait.append(sum_wait / (num_processes_served * 60 * 60))
        list_delay.append(sum_delay / (num_processes_served * 60 * 60))


plt.plot([i + 1 for i in range(total_time * 60 * 60)], list_wait,label=u"平均等待时长(秒)")
plt.plot([i + 1 for i in range(total_time * 60 * 60)], list_delay,label=u"平均逗留时长(秒)")
#plt.legend(FontProperties=font)
plt.legend(prop=font)
plt.xlabel(u"模拟时间(秒)",FontProperties=font)
#plt.ylabel()
plt.show()

#plt.plot([i + 1 for i in range(total_time * 60 * 60)], list_delay)
#plt.ylabel(u"平均逗留时长",FontProperties=font)
#plt.show()

plt.plot([i + 1 for i in range(total_time * 60 * 60)], list_queue_wait)
plt.ylabel(u"队列中平均等待顾客数(秒)",FontProperties=font)
plt.xlabel(u"模拟时间(秒)",FontProperties=font)
plt.show()

plt.plot([i + 1 for i in range(total_time * 60 * 60)], list_server_busy)
plt.ylabel(u"服务器利用率(秒)",FontProperties=font)
plt.xlabel(u"模拟时间(秒)",FontProperties=font)
plt.show()
