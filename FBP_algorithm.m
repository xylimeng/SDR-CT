function [FBP_result] = FBP_algorithm(test_slice,pro_direction,globalstruct)
%FBP_ALGORITHM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    pro_name=[pro_direction,num2str(test_slice),'_pro.mat'];
    load(pro_name);


    resolution=globalstruct.resolution;
    thetaresolution=globalstruct.thetaresolution;

    
    [iradon_x,iradon_y]=size(radon(ones(resolution,resolution),1:thetaresolution:180));
    data_iradon=[];
    data_iradon=[zeros(floor((iradon_x-size(pro,2))/2),size(pro,1));pro'];
    data_iradon=[data_iradon;zeros(iradon_x-size(pro,2)-floor((iradon_x-size(pro,2))/2),size(pro,1))];
    FBP_result=iradon(data_iradon,90:thetaresolution:269);
    FBP_result=FBP_result(2:resolution+1,2:resolution+1);


end

