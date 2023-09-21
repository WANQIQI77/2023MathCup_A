import pandas as pd
import numpy as np
import math

'''
截断损失
'''
results = []
# 读取Excel文件
excel_file = '第三问截断损失初始表.xlsx'  # 将 'your_excel_file.xlsx' 替换为你的Excel文件路径
df = pd.read_excel(excel_file)
# 计算每列的平均值
column_averages = df.mean()
column_averages_length = len(column_averages)
# print('每列均值')
# print(column_averages)
# 每五个数计算平均值
trunc_results = []
for i in range(0, len(column_averages), 5):
    chunk = column_averages[i:i + 5]
    average = np.mean(chunk)
    result = 1 - average
    trunc_results.append(result)
print(type(trunc_results))
# print(trunc_results)
trunc_results = [1 - x for x in trunc_results]

results.append(trunc_results)
print('1')
print(results)
'''
遮挡损失
'''
# 读取Excel文件
excel_file = '第三问遮挡损失初始表.xlsx'  # 将 'your_excel_file.xlsx' 替换为你的Excel文件路径
df = pd.read_excel(excel_file)

# 计算每列的平均值
column_averages = df.mean()
column_averages_length = len(column_averages)
# print(column_averages_length)
# print(column_averages)

# 每五个数计算平均值
sb_results = []
for i in range(0, len(column_averages), 5):
    chunk = column_averages[i:i + 5]
    average = np.mean(chunk)
    result = 1 - average
    sb_results.append(result)
# print(sb_results)
results.append(sb_results)
print('2')
print(results)
'''
余弦损失
'''
# 读取Excel文件
excel_file = '第三问定日镜反射角.xlsx'  # 将 'your_excel_file.xlsx' 替换为你的Excel文件路径
df = pd.read_excel(excel_file)

# 计算每列的平均值
column_averages = df.mean()
column_averages_length = len(column_averages)

# 每五个数计算平均值
cos_results = []
for i in range(0, len(column_averages), 5):
    chunk = column_averages[i:i + 5]
    average = np.mean(chunk)
    result = math.cos(average)
    cos_results.append(result)
print(type(cos_results))

results.append(cos_results)
print(results)

# 读取Excel文件
excel_file = 'eta_at.xlsx'  # 将 'your_excel_file.xlsx' 替换为你的Excel文件路径
df = pd.read_excel(excel_file)

# 选择名为"eta"的列
eta_at = df['eta_at']
# 计算平均值
eta_at_mean = eta_at.mean()
# 打印或进行其他操作
print(eta_at_mean)

array1 = np.array(sb_results)
array2 = np.array(cos_results)
array3 = np.array(trunc_results)
eta_array = eta_at_mean * 0.92 * array1 * array2 * array3
print("平均光学效率")
print(eta_array)
eta_array = eta_array.tolist()
results.append(eta_array)

print(results)

excel_file = 'DNI.xlsx'  # 将 'your_excel_file.xlsx' 替换为你的Excel文件路径
df_DNI = pd.read_excel(excel_file)
DNI_list = df_DNI['DNI']
DNI = np.array(DNI_list)[:12]
total_area = 109819
print("总面积平方米")
print(total_area)
print("平均光学效率")
print(eta_array)
print("DNI")
print(DNI)
print("结果")
ans = DNI * eta_array
results.append(ans)
print(ans)

column_names = ['eta_trunc', 'eta_sb', 'eta_cos', 'ave', '单位面积输出功率']
df_result = pd.DataFrame(results).T
df_result.columns = column_names
output_excel_file = 'result3.xlsx'
df_result.to_excel(output_excel_file, index=False)
print(f'Data has been written to {output_excel_file}')

ans_year = DNI * eta_array * total_area * 1e-3
print(ans_year)
print("年平均输出热功率")
print(np.mean(ans_year))
