clc
clear
num_mirrors=1745;

%{
%变量x=[L，W，Z， x1，y1，x2，y2，x3, y3……，xi，yi]
x=[6,6,4];
excelField='附件.xlsx';
[data,header] = xlsread(excelField);
% 现在，变量数据包含了每一列的数据，headers包含了列的名称
% 例如，访问第一列的数据：
x_Column = data(:, 1);
% 访问第二列的数据：
y_Column = data(:, 2);

% 初始化合并后的数组
merged_values = zeros(1, length(x_Column) + length(y_Column));

% 使用循环将 x_values 和 y_values 合并
for i = 1:length(y_Column)
    merged_values(2*i - 1) = x_Column(i);
    merged_values(2*i) = y_Column(i);
end
z_Column=ones(num_mirrors,1)*4;
x=[x,merged_values]';
x_y=x(end-3490+1:end);
mirror_cordinate = reshape(x_y, 2, [])';
%}

%设置PSO参数
num_variables = 1745*2+3; 
array1=ones(1,num_mirrors*2)*(-350);
array2=ones(1,num_mirrors*2)*350;
lb = [2, 2, 2]; % 下限
ub = [6, 8, 8]; % 上限
lb=[lb,array1];
ub=[ub,array2];

% 调用PSO算法进行优化
[x_opt, f_opt] = PSO(@Q2_Fitness, num_variables, lb, ub,num_mirrors);

% 输出优化结果
disp('优化结果：')
disp(['最大功率 = ', num2str(-f_opt)]);
%disp('最优参数：');
%disp(x_opt);

% 提取最优解中的定日镜坐标和尺寸
x_y=x_opt(4:end);
mirror_coords = reshape(x_y, 2, num_mirrors)';
x_coords = mirror_coords(:, 1);
y_coords = mirror_coords(:, 2);


% 创建一个新的图形窗口
figure;

% 绘制定日镜坐标图
scatter(x_coords, y_coords, 7, 'filled'); % 使用scatter绘制散点图
hold on;
scatter(0, 0, 12, 'filled', 'MarkerFaceColor', 'r');
% 设置坐标轴标签和标题
xlabel('X坐标');
ylabel('Y坐标');
title('定日镜场坐标图');

% 设置坐标轴范围，根据实际情况进行调整
xlim([-350, 350]);
ylim([-350, 350]);

% 显示网格线
grid on;

% 添加其他绘图设置和注释，根据需要进行修改

% 显示图形
hold off;
