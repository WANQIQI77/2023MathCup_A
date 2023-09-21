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

filename_1 = '附件';
opts = detectImportOptions(filename_1);
opts.Sheet = 'sheet1';
opts.SelectedVariableNames = 1:2; 
opts.DataRange = '2:1746';
[coordinate] = readmatrix(filename_1,opts);        %镜面中心的坐标

distance = coordinate(:,1).^2 + coordinate(:,2).^2;
distance = sqrt(distance);

vector_r = [cos(a_s).*cos(y_s),cos(a_s).*sin(y_s),sin(a_s)];
tower_height = 76;              % 相对高度

x = vector_r(:,1)./vector_r(:,3).*80;
y = vector_r(:,2)./vector_r(:,3).*80;
A = x.^2 + y.^2;

distance_shading = sqrt(A);
distance_shaded = distance_shading(distance_shading>100);
length(distance_shaded)
mean(distance_shaded)

plot(distance_shaded)
min(distance)

