function c = constraints(x,num_mirrors,total_powers)
%CONSTRAINTS 此处显示有关此函数的摘要
%   此处显示详细说明
    c=[];
    L=x(1);
    W=x(2);
    Z=x(3);
    % 约束条件1：镜宽不小于z
    c = [c, W >=Z];

    % 约束条件2：镜长的一半小于z
    c = [c, L / 2 <= Z];
    
    % 约束条件3：年平均输出热功率为60MW即60000kW
    delta=total_powers - 6;
    c = [c, delta>0]; 
   
    % 约束条件4：相邻定日镜距离比镜面宽度多5m以上
    for i = 1:num_mirrors
        xi = x((i - 1) * 2 + 3);
        yi = x((i - 1) * 2 + 4);
        for j = 1:num_mirrors
                x_next = x((j - 1) * 2 + 3);
                y_next = x((j - 1) * 2 + 4);
                distance = sqrt((xi - x_next)^2 + (yi - y_next)^2);
                c = [c, distance >= W + 5];
        end
    end
end





