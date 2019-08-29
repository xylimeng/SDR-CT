function [len,loc,len_width,loc_width] = load_matrix_A(thetaresolution,resolution,dimension,width)
%LOAD_MATRIX_A 此处显示有关此函数的摘要
%   此处显示详细说明
try
    load('.\create_A\A.mat')
catch
    cd('.\create_A');
    [len,loc,len_width,loc_width] = calculate_A_twice(thetaresolution,resolution,dimension,width);
    save('A.mat','len','loc','len_width','loc_width');
    cd('..\')
end
end

