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

filename_1 = '第二问最优解.xlsx';
opts = detectImportOptions(filename_1);
opts.Sheet = 'sheet1';
opts.SelectedVariableNames = 1:2; 
opts.DataRange = '2:1746';
[mirror_coordinate] = readmatrix(filename_1,opts);     %镜面中心的坐标
tower_height = 81;

a_s = asin(a_s);
y_s = acos(y_s);

[suntat_angle_H,suntat_ganle_D,suntat_angle_F] = suntat_angle_1(a_s,y_s,mirror_coordinate,tower_height);


writematrix(suntat_angle_H,'第二问定日镜高度角初始表.xlsx','Sheet',1);
writematrix(suntat_ganle_D,'第二问定日镜方位角初始表.xlsx','Sheet',1);
writematrix(suntat_angle_F,'第二问光线反射角初始表.xlsx','Sheet',1);