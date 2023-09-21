function [truncation_eff] = truncation_eff(a_s,y_s,suntat_angle_H,suntat_angle_D,sita,mirror_coordinate,mirror_l,mirror_w)
%y_s     太阳方位角 
%a_S      太阳高度角    


time_point = 60;
R  =  4;                    %接收器半径
collect_h= 8 ;            %接收器高度
mirror_num = 1745;          %定日镜数量

sigam = -0.45:0.1:0.45;    % 锥形偏移
sigam = 0.001 .* sigam; 
tao = -0.45:0.1:0.45;
tao =  0.001 .* tao;

light_num = length(sigam);    %一个光锥中光线的数量
sample_num = 8;                 %每行取点数

truncation = zeros(mirror_num,1,time_point);
for w = 1:mirror_num
    truncation_point = zeros(sample_num*sample_num,1,time_point);
    for x =1:sample_num
        for y = 1:sample_num
            mirror_coordinate_ru = [mirror_w/sample_num*(x-1/2);mirror_l/sample_num*(y-1/2);0];          %入射点坐
                        
            T_C = [-sin(suntat_angle_H(w,:));cos(suntat_angle_H(w,:));0*suntat_angle_D(w,:);-sin(suntat_angle_D(w,:)).*cos(suntat_angle_H(w,:));
                 -sin(suntat_angle_D(w,:)).*sin(suntat_angle_H(w,:));cos(suntat_angle_D(w,:));
                  cos(suntat_angle_D(w,:)).*cos(suntat_angle_H(w,:));cos(suntat_angle_D(w,:)).*sin(suntat_angle_H(w,:));sin(suntat_angle_D(w,:))];
            T_1 = reshape(T_C,3,3,time_point);
            mirror_coordinate_ru= pagemtimes(T_1,mirror_coordinate_ru);

            
            vector_s = [sin(sigam).*cos(tao);sin(sigam).*sin(tao);cos(sigam)];
    
            T = [sin(y_s);            
                -cos(y_s);                      
                 0*a_s,;
                -sin(a_s).*cos(y_s);
                -sin(a_s).*sin(y_s);
                 cos(a_s);
                 cos(a_s).*cos(y_s);
                 cos(a_s).*sin(y_s);
                 sin(a_s);
            ];

            T_2 = reshape(T,3,3,time_point);

            vector_st = pagemtimes(T_2,vector_s);        
            vector_n = [cos(suntat_angle_H(1,:));sin(suntat_angle_H(1,:));sin(suntat_angle_D(1,:));];             %定日镜面镜面的法向向量
            vector_n = reshape(vector_n,3,1,60);

            vector_r = zeros(3,light_num,time_point);
            for p = 1:light_num
                vector_r(:,p,:) = 2*cos(reshape(repmat(sita(1,:),3,1),3,1,60)).*vector_n - vector_st(:,p,:);
            end
                                   
            m_2 = vector_r(1,:,:);
            n_2 = vector_r(2,:,:);
            l_2 = vector_r(3,:,:); 
    
            x_1 = mirror_coordinate_ru(1)+mirror_coordinate(w,1);
            y_1 = mirror_coordinate_ru(2)+mirror_coordinate(w,2);

            delta = (2.*m_2.*x_1./l_2+2.*n_2.*y_1./l_2).^2 - 4.*(m_2.^2+n_2.^2)./l_2.^2.*(x_1^2+y_1^2-R^2);

            z_1 = (-(2.*m_2.*x_1./l_2+2.*m_2.*y_1./l_2)+sqrt(delta))./(2.*(m_2.^2+n_2.^2)./l_2.^2);
            z_1(isreal(z_1)) = -collect_h;
            z_1(z_1>-collect_h/2 & z_1 < collect_h/2) = 1;
            z_1(z_1<-collect_h/2) = -collect_h;
            z_1(z_1>collect_h/2) = -collect_h;

            z_2 = (-(2.*m_2.*x_1./l_2+2.*m_2.*y_1./l_2)-sqrt(delta))./(2.*(m_2.^2+n_2.^2)./l_2.^2);
            z_2(isreal(z_2)) = -collect_h;
            z_2(z_2>-collect_h/2 & z_2 < collect_h/2) = 1;
            z_2(z_2<-collect_h/2) = -collect_h;
            z_2(z_2>collect_h/2) = -collect_h;

            z = [z_1;z_2];
            z = sum(z);
            z = sum(z,2);
            z(z>0) = 1;
            z(z<0) = 0;
            truncation_point(x*y,1,:) = z;
        end
    end
    
    truncation(w,:,:) =1 - sum(truncation_point)./sample_num^2;
end

truncation = reshape(truncation,mirror_num,time_point);
truncation_eff = sum(truncation(:))/mirror_num/time_point;
end



