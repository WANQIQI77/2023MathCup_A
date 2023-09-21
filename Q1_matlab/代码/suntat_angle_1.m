function [suntat_angle_H,suntat_angle_D,suntat_angle_F] = suntat_angle_1(a_s,y_s,mirror_cordinate,tower_height)

%y_s    太阳方位角   
%a_s    太阳高度角  
%mirro_cordinate  镜面坐标
%mirro_height     镜面高度

y_s = y_s;
time_point = 60;

A = ones(1,time_point);
a = sqrt(mirror_cordinate(:,1).^2+mirror_cordinate(:,2).^2+tower_height^2); 
a = a*A;                                 % 镜面中心到接受中心的距离包括高度

b = a * diag(sin(a_s)); 
k = a * diag(cos(a_s));

m = k * diag(sin(y_s)) + mirror_cordinate(:,1)*A; 
n = k * diag(cos(y_s)) + mirror_cordinate(:,2)*A; 

EF = (b+tower_height)/2; 
BF = sqrt((mirror_cordinate(:,1)*A-m/2).^2 + (mirror_cordinate(:,2)*A-n/2).^2);
BE = sqrt(EF.^2 + BF.^2);

suntat_angle_F = acos(BE./a);
suntat_angle_H = atan(EF./BF);                            % 定日镜高度角
suntat_angle_D = asin((mirror_cordinate(1)-m/2)./BF);     
end 