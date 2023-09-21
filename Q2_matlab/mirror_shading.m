filename = '太阳高度角和方位角.xlsx';
opts = detectImportOptions(filename);
opts.Sheet = '太阳高度角';
opts.SelectedVariableNames = 3; 
opts.DataRange = '2:61';
[a_s] = readmatrix(filename,opts);

opts = detectImportOptions(filename);
opts.Sheet = '太阳方位角';
opts.SelectedVariableNames = 3; 
opts.DataRange = '2:61';
[y_s] = readmatrix(filename,opts);

filename = '第二问定日镜高度角初始表.xlsx';
[suntat_angle_H] = readmatrix(filename);
filename = '第二问定日镜方位角初始表.xlsx';
[suntat_angle_D] = readmatrix(filename);
filename = '第二问光线反射角初始表.xlsx';
[sita] = readmatrix(filename);

filename_1 = '第二问最优解.xlsx';
opts = detectImportOptions(filename_1);
opts.Sheet = 'sheet1';
opts.SelectedVariableNames = 1:2; 
opts.DataRange = '2:1746';
[mirror_coordinate] = readmatrix(filename_1,opts);     %镜面中心的坐标

a_s = asin(a_s);
y_s = acos(y_s);

mirror_l = 6;            %镜面长
mirror_w = 7.5;            %镜面宽
mirror_height = 8 ;     %镜中心高度

[shading_eff,shading_pro] = shading_eff_matrix(a_s,y_s,suntat_angle_H,suntat_angle_D,sita,mirror_l,mirror_w,mirror_height,mirror_coordinate); 

writematrix(shading_pro,'第二问遮挡损失初始表.xlsx','Sheet',1);