function [shading_eff] = shading_eff(a_s,y_s,suntat_angle_H,suntat_angle_D,sita,mirror_l,mirror_w,mirror_height,mirror_coordinate)

%mirror_l = 6;     %镜面长
%mirror_w = 6;     %镜面宽
%mirror_height  = 4 ;     %镜中心高度

%y_s 太阳方位角   beta  
%a_s 太阳高度角   erfa 
%AH    定日镜方位角
%EH    定日镜俯仰角
%sita  反射角
% O 坐标

%O_a = [0;0;0];        %A镜坐标系原点在地面坐标系的坐标
%O_b = [0;1;1];        %B镜坐标系原点在地面坐标系的坐标

mirror_num = 1745;  
mim_distance = 13;      %最小作用距离
n = 8;                 %每行取点数
time_point = 60;         %时间点个数
shading_pro = zeros(1745,time_point);          %遮挡率


mirror_coordinate = [mirror_coordinate,mirror_height];             %三维


for i = 1:1745
    tep_distance = sqrt((mirror_coordinate(:,1) -mirror_coordinate(i,1)).^2 + (mirror_coordinate(:,2)-mirror_coordinate(i,2)).^2);  
    tep_index = find(tep_distance < mim_distance);
    if length(tep_index) > 1
        shaded_pro = zeros(length(tep_index),time_point);
        for k=1:length(tep_index)
            if tep_index(k) ~= i
                O_a = mirror_coordinate(i,:);
                O_b = mirror_coordinate(tep_index(k),:);
                x_y_sum = zeros(n*n,time_point);   % 60  时间点个数
                for x = 1:n
                    for y = 1:n 
                        H1 = [mirror_w/n*(x-1/2);mirror_l/n*(y-1/2);0];                          %入射点坐标

                        vector_n = [cos(suntat_angle_H(i,:))',sin(suntat_angle_H(i,:))',sin(suntat_angle_D(i,:))'];          %定日镜面镜面的法向向量                                     
                        vector_r = [cos(a_s).*cos(y_s),cos(a_s).*sin(y_s),sin(a_s)];     %入射光束地面坐标系的向量值
                        
                        sita_1 = sita(i,:) .* ones(1,60);
                        sita_2 = [sita_1;sita_1;sita_1]' ;   

                        vector_f = 2*vector_n.*cos(sita_2) - vector_r;                  %反射光束地面坐标系的向量值
                        vector_f_1 = reshape(vector_f',3,1,time_point);

                        
                        T = [-sin(suntat_angle_H(i,:));cos(suntat_angle_H(i,:));0*suntat_angle_D(i,:);-sin(suntat_angle_D(i,:)).*cos(suntat_angle_H(i,:));
                            -sin(suntat_angle_D(i,:)).*sin(suntat_angle_H(i,:));cos(suntat_angle_D(i,:));
                            cos(suntat_angle_D(i,:)).*cos(suntat_angle_H(i,:));cos(suntat_angle_D(i,:)).*sin(suntat_angle_H(i,:));sin(suntat_angle_D(i,:))];
                        
                        T_1 = reshape(T,3,3,time_point);

                        O_a_1 =repmat(O_a',1,1,time_point);
                        H2 = pagemtimes(T_1,H1) + O_a_1;
                        
                        T_2_1 = [ -sin(suntat_angle_H(i,:));-sin(suntat_angle_D(i,:)).*cos(suntat_angle_H(i,:));cos(suntat_angle_D(i,:)).*cos(suntat_angle_H(i,:));
                                cos(suntat_angle_H(i,:));-sin(suntat_angle_D(i,:)).*sin(suntat_angle_H(i,:));cos(suntat_angle_D(i,:)).*sin(suntat_angle_H(i,:));
                                0*suntat_angle_D(i,:);cos(suntat_angle_D(i,:));sin(suntat_angle_D(i,:));
                               ];

                        T_2 = reshape(T_2_1,3,3,time_point);
                        O_b_1 = repmat(O_b',1,1,time_point);
                        H3 = pagemtimes(T_2, (H2 - O_b_1));
                        vector_H = pagemtimes(T_2,vector_f_1);

                         x_b = (vector_H(3,1,:).*H3(1,1,:) - vector_H(1,1,:).*H3(3,1,:))./vector_H(3,1,:);
                         y_b = (vector_H(3,1,:).*H3(2,1,:) - vector_H(2,1,:).*H3(3,1,:))./vector_H(3,1,:);

                         x_b_1 = reshape(x_b,1,time_point);
                         x_b_1(x_b_1<0) = 0;
                         x_b_1(x_b_1>mirror_w) = 0;
                         x_b_1(x_b_1>0 & x_b_1<mirror_w) = -1;


                         y_b_1 = reshape(y_b,1,time_point);
                         y_b_1(y_b_1<0) = 0;
                         y_b_1(y_b_1>mirror_l) = 0;
                         y_b_1(y_b_1>0&y_b_1<mirror_l) = -1;

                         x_y_sum(x*y,:) = sum([x_b_1;y_b_1]);                        
                    end
                end
                %一个镜子对另一个镜子的遮挡率
                x_y_sum(x_y_sum<0) = 1;
                shaded_pro(k,:) = sum(x_y_sum)/(n*n);
            end
        end
    end
    shading_pro(i,:) = max(shaded_pro);
    shaded_pro(:) = 0;
end
shading_eff = sum(shading_pro(:))/(mirror_num*time_point);

end



