function [len,loc,len_width,loc_width] = load_matrix_A(thetaresolution,resolution,dimension,width)
%LOAD_MATRIX_A �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
try
    load('.\create_A\A.mat')
catch
    cd('.\create_A');
    [len,loc,len_width,loc_width] = calculate_A_twice(thetaresolution,resolution,dimension,width);
    save('A.mat','len','loc','len_width','loc_width');
    cd('..\')
end
end

