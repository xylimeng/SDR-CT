function [FBP_result_direction] = FBP_algorithm(pro_direction,globalstruct)
%FBP_ALGORITHM 此处显示有关此函数的摘要
%   此处显示详细说明
warning off;
mkdir('Result');
cd('./Result');
mkdir('FBP_result');
cd('../')
for slice=1:1:globalstruct.resolution
    cd(pro_direction);
    pro_name=[num2str(slice),'_pro.mat'];
    load(pro_name);
    resolution=globalstruct.resolution;
    thetaresolution=globalstruct.thetaresolution;
    [iradon_x,iradon_y]=size(radon(ones(resolution,resolution),1:thetaresolution:180));
    data_iradon=[];
    data_iradon=[zeros(floor((iradon_x-size(pro,2))/2),size(pro,1));pro'];
    data_iradon=[data_iradon;zeros(iradon_x-size(pro,2)-floor((iradon_x-size(pro,2))/2),size(pro,1))];
    FBP_result=iradon(data_iradon,90:thetaresolution:269);
    FBP_result=FBP_result(2:resolution+1,2:resolution+1);
    cd('../../Result/FBP_result');
    save(['FBPresult_',num2str(slice),'.mat'],'FBP_result');
    cd('../../');
end
FBP_result_direction='./Result/FBP_result/';
end

