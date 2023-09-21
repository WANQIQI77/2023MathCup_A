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

filename = '定日镜高度角初始表.xlsx';
[suntat_angle_H] = readmatrix(filename);
filename = '定日镜方位角初始表.xlsx';
[suntat_angle_D] = readmatrix(filename);
filename = '光线反射角初始表.xlsx';
[sita] = readmatrix(filename);

filename_1 = '附件';
opts = detectImportOptions(filename_1);
opts.Sheet = 'sheet1';
opts.SelectedVariableNames = 1:2; 
opts.DataRange = '2:1746';
[mirror_coordinate] = readmatrix(filename_1,opts);     %镜面中心的坐标

mirror_l = 6;
mirror_w = 6;

[truncation_eff,truncation_1] = truncation_eff_matrix(a_s,y_s,suntat_angle_H,suntat_angle_D,sita,mirror_coordinate,mirror_l,mirror_w);

writematrix(truncation_1,'截断损失初始表.xlsx','Sheet',1);
