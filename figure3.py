import math

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# 指定Excel文件路径
excel_file = 'mirror.xlsx'
# 读取Excel文件
df = pd.read_excel(excel_file)
# 假设Excel文件中有列名为'X'、'Y'和'Z'，分别对应X、Y和Z坐标
x_values = df['x']
y_values = df['y']
excel_file2 = '光线反射角初始表.xlsx'
# 读取Excel文件
df2 = pd.read_excel(excel_file2)
z_values = df2.mean(axis=1)
z_values = z_values[:1745]
z_values=np.array(z_values)
z_values=np.cos(z_values)
# 现在，x_values、y_values和z_values分别包含了从Excel中读取的X、Y和Z坐标数据
fig = plt.figure()
scatter=plt.scatter(x_values, y_values, s=5, c=z_values, cmap='viridis')
colorbar = plt.colorbar(scatter, ax=plt.gca(), location='right')
plt.scatter(0, 0)
# 添加标题和坐标轴标签
plt.title('cosine efficiency')
plt.xlabel('X')
plt.ylabel('Y')
# 显示图形
plt.show()