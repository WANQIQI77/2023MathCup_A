import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# 指定Excel文件路径
excel_file = 'mirror.xlsx'
# 读取Excel文件
df = pd.read_excel(excel_file)

# 假设Excel文件中有列名为'X'、'Y'和'Z'，分别对应X、Y和Z坐标
x_values = df['x']
y_values = df['y']
z_values = df['z']

# 现在，x_values、y_values和z_values分别包含了从Excel中读取的X、Y和Z坐标数据

# 创建一个三维坐标系
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# 绘制散点图
ax.scatter(x_values, y_values, z_values, s=5)
ax.scatter(0, 0, 80, color='red', marker='o', s=10)

# z_ticks = [0, 80]  # 自定义Z轴刻度位置
# z_tick_labels = ['0', '80']  # 自定义Z轴刻度标签
# ax.set_zticks(z_ticks)
# ax.set_zticklabels(z_tick_labels)

# 设置坐标轴标签
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

# 显示图形
plt.show()

plt.scatter(x_values, y_values, s=5)
plt.scatter(0, 0)
# 添加标题和坐标轴标签
plt.xlabel('X')
plt.ylabel('Y')

# 显示图形
plt.show()
