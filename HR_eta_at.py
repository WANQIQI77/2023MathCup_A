import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import math

# 指定Excel文件路径
excel_file = 'mirror.xlsx'
# 读取Excel文件
df = pd.read_excel(excel_file)

# 假设Excel文件中有列名为'X'、'Y'和'Z'，分别对应X、Y和Z坐标
x_values = df['x']
y_values = df['y']

HR = []
for i in range(1745):
    d = math.sqrt((x_values[i] ** 2) + (y_values[i] ** 2) + (80 - 4) ** 2)
    HR.append(d)

df = pd.DataFrame(HR, columns=['HR'])
excel_file = 'HR.xlsx'
df.to_excel(excel_file, index=False)
print(f'Data has been written to {excel_file}')

'''大气透射率'''
'''𝜂at = 0.99321 − 0.0001176𝑑HR + 1.97 × 10−8 × 𝑑HRexp2'''
all_eta_at = []
for i in range(1745):
    eta_at = 0.99321 - 0.0001176 * HR[i] + 1.97 * 1e-8 * (HR[i] ** 2)
    all_eta_at.append(eta_at)

df = pd.DataFrame(all_eta_at, columns=['eta_at'])
excel_file = 'eta_at.xlsx'
df.to_excel(excel_file, index=False)
print(f'Data has been written to {excel_file}')