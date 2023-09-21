
function [x_opt, f_opt] = PSO(Q2_Fitness, num_variables, lb, ub,num_mirrors)


%提取问题一的值作为初始最优值
first=[6,6,4];
excelField='附件.xlsx';
[data,~] = xlsread(excelField);
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
first=[first,merged_values]';
x_y=first(end-3490+1:end);
mirror_cordinate = reshape(x_y, 2, [])';




    % 初始化粒子群
    num_particles = 1;%粒子数量
    max_iterations = 1;%迭代次数

    firsts=repmat(first,1,num_particles);
    %初始化粒子群位置和速度
    particles = (-1+2*rand(num_particles, num_variables) )* 5+firsts';
    particles = max(min(particles, ub), lb);
    velocities = zeros(num_particles, num_variables);

    personal_best_positions = zeros(num_mirrors,1);%个体最优位置
    personal_best_values = zeros(num_particles, 1);%个体最优速度
    total_powers= zeros(num_particles, 1);
    disp(personal_best_values)
    global_best_position = Inf;%全局最优位置
    global_best_value = Inf;%全局最优速度
    %读取太阳高度角和太阳方位角
    a_s = xlsread('太阳高度角的弧度值.xlsx');
    y_s = xlsread("太阳方位角的弧度值.xlsx");
    % 开始迭代优化
    for iter = 1:max_iterations %迭代次数
        % 计算每个粒子的目标函数值
        for i = 1:num_particles %粒子数量
          
                [personal_best_values(i),total_powers(i)] = Q2_Fitness(particles(i, :),num_mirrors,a_s,y_s); %计算目标函数
                disp('total_powers：')
                disp(total_powers)
                
                % 更新个体最优位置和全局最优位置
                if personal_best_values(i) < global_best_value
                    global_best_value = personal_best_values(i);
                    global_best_position = particles(i, :);
                end
        end
        
        % 更新粒子速度和位置
        inertia_weight = 0.5; % 惯性权重
        cognitive_weight = 1.0; % 个体认知权重
        social_weight = 1.0; % 社会认知权重
        rand_coeff1 = rand(num_particles, num_variables);
        rand_coeff2 = rand(num_particles, num_variables);
        
        for i = 1:num_particles
            velocities(i, :) = inertia_weight * velocities(i, :) ...
                + cognitive_weight * rand_coeff1(i, :) .* (personal_best_positions(i, :) - particles(i, :)) ...
                + social_weight * rand_coeff2(i, :) .* (global_best_position - particles(i, :));
            
            % 找到新粒子位置
            new_position = particles(i, :) + velocities(i, :);

             % 确保粒子位置在界限内
            particles(i, :) = min(ub, max(lb, particles(i, :)));

            % 然后使用约束函数检查新位置是否满足约束条件
            c = constraints(new_position,num_mirrors,total_powers(i));
            sum_c=sum(c);

            %满足约束条件，更新粒子位置
            if sum_c ==0
                particles(i, :) = new_position;
            %不满足约束条件 
            else
               % 如果解不满足约束条件，不予考虑，将个体最优值设置为无穷大
                personal_best_values(i) = Inf;
            end
           
        end
    end
    % 返回优化结果
    x_opt = global_best_position;
    f_opt = global_best_value;
end


