
% 定义目标函数
function [f,total_power] = Q2_Fitness(x1, num_mirrors,a_s,y_s)
    %变量x1i=[L，W，Z， [x11，y1]，[x12，y2]，[x13, y3]……，[x1i，yi]]
    %x1:横坐标 y：纵坐标 z:高度坐标 L：长度 W：宽度
    %a_s：太阳高度角
    %y_s:太阳方位角
    %mirror_cordinate:镜子坐标
    %mirror_height：镜子高度
    x1_y=x1(end-3490+1:end);
    %n = length(x1_y) / 2;
    mirror_cordinate = reshape(x1_y, 2, [])';
    % 使用 reshape 函数将 data 转换为一个二维矩阵
    % 第一个参数是数据，第二个参数是新矩阵的行数，第三个参数是新矩阵的列数

    mirror_height=4;
    DNI=2.2003;

    [suntat_angle_H,suntat_angle_D,suntat_angle_F] = suntat_angle_1(a_s,y_s,mirror_cordinate,mirror_height);
    mirror_l=6;
    mirror_w=6;

    %求eta
    %求eta_sb
    eta_sb=shading_eff(a_s,y_s,suntat_angle_H,suntat_angle_D,suntat_angle_F,mirror_l,mirror_w,6,mirror_cordinate);
    %求eta_cos
    eta_cos=mean(mean(cos(suntat_angle_F)));
    %求eta_at
    collectorCenter = [0, 0, 80];%集热器坐标
    distances = zeros(1745, 0);
    for i = 1:num_mirrors
        %mirrorPoint = [mirror_cordinate(i,1), mirror_cordinate(i,2),mirror_height];
        mirrorPoint = [1, 1,1];
        distance = norm(collectorCenter - mirrorPoint); % 使用 norm 函数计算距离
        distances(i) = distance;
    end
    eta_at= mean(0.99321 - 0.0001176 * distances + 1.97e-8 * (distances.^2));
    %求eta_trunc
    eta_trunc=truncation_eff(a_s,y_s,suntat_angle_H,suntat_angle_D,suntat_angle_F,mirror_cordinate,mirror_l,mirror_w);
    %eta_ref=0.92
    eta_ref=0.92;
    eta=eta_sb*eta_cos*eta_at*eta_trunc*eta_ref;
    % 计算单位镜面面积年平均输出热功率
    ave_power=DNI*eta;


    %计算镜子的总面积
    total_area = num_mirrors*mirror_w*mirror_l;
    
    %计算总功率
    total_power=ave_power*total_area;

    % 目标函数是输出功率的负值，因为我们要最大化功率
    f=-ave_power;
    disp(f)
end