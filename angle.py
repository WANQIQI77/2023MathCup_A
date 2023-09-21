from datetime import datetime
import math

'''求D 以春分作为第0天起算的天数'''
# 输入目标日期
target_date = "2023-03-21"
# 输入给定的多个日期
given_dates = ["2023-01-21", "2023-02-21", "2023-03-21", "2023-04-21", "2023-05-21", "2023-06-21", "2023-07-21",
               "2023-08-21", "2023-09-21", "2023-10-21", "2023-11-21", "2023-12-21"]
# 将目标日期转换为 datetime 对象
target_datetime = datetime.strptime(target_date, "%Y-%m-%d")
# 计算每个给定日期距离目标日期的天数
D_values = []
print("每个月D的值为")
for given_date in given_dates:
    given_datetime = datetime.strptime(given_date, "%Y-%m-%d")
    time_difference = given_datetime - target_datetime
    days_until_target = time_difference.days
    D_values.append(days_until_target)
print(D_values)
'''太阳赤纬角'''
# 计算每个D值对应的delta
all_sin_delta = []
all_cos_delta = []
for D in D_values:
    D_radians = math.radians(D)
    sin_delta = math.sin(2 * math.pi * D_radians / 365) * math.sin(2 * math.pi * 23.45 / 360)
    cos_delta = math.sqrt(1 - sin_delta ** 2)
    all_sin_delta.append(sin_delta)
    all_cos_delta.append(cos_delta)

# 打印每个D值对应的结果
print("每月对应的太阳赤纬角sin(delta)值为")
print(all_sin_delta)
print("每月对应的太阳赤纬角cos(delta)值为")
print(all_cos_delta)
'''求太阳时角omega'''
# 给定每天的时间点（小时和分钟）
time_points = ["9:00", "10:30", "12:00", "13:30", "15:00"]
print("太阳时角omega")
omega_values = []
# 计算每个时间点对应的太阳时角
for time in time_points:
    # 解析时间字符串为小时和分钟
    hours, minutes = map(int, time.split(':'))
    # 计算总分钟数
    total_minutes = hours * 60 + minutes
    # 计算当地时间对应的ST
    ST = total_minutes / 60
    # 计算太阳时角
    omega = (math.pi / 12) * (ST - 12)
    # 请注意，如果太阳时角超出了合理范围，需要进行调整，使其在 0 到 2𝜋 之间
    if omega < 0:
        omega += 2 * math.pi
    elif omega >= 2 * math.pi:
        omega -= 2 * math.pi
    omega_values.append(omega)
print(omega_values)
'''求太阳高度角'''
'''sin 𝛼 = cos 𝛿 cos 𝜑 cos 𝜔 + sin 𝛿 sin 𝜑'''
all_sin_alpha = [[i for i in range(5)] for _ in range(12)]
all_cos_alpha = [[i for i in range(5)] for _ in range(12)]
all_angle = [[i for i in range(5)] for _ in range(12)]
latitude = math.radians(39.4)
for month in range(12):
    for time in range(5):
        sin_alpha = all_cos_delta[month] * math.cos(latitude) * math.cos(omega_values[time]) + all_sin_delta[
            month] * math.sin(
            latitude)
        cos_alpha = math.sqrt(1 - sin_alpha ** 2)
        angle = math.acos(cos_alpha)
        all_sin_alpha[month][time] = sin_alpha
        all_cos_alpha[month][time] = cos_alpha
        all_angle[month][time] = angle
'''太阳方位角'''
all_cos_gama = [[i for i in range(5)] for _ in range(12)]
all_angle = [[i for i in range(5)] for _ in range(12)]
for month in range(12):
    for time in range(5):
        cos_gama = (all_sin_delta[month] - all_sin_alpha[month][time] * math.sin(latitude)) / (
                all_cos_alpha[month][time] * math.cos(latitude))
        if cos_gama < -1:
            cos_gama = -1
        if cos_gama > 1:
            cos_gama = 1
        all_cos_gama[month][time] = cos_gama
        angle = math.acos(cos_gama)
        # print(cos_gama)
        print(angle)

