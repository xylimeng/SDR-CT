try
    [iradon_x,iradon_y]=size(radon(AF1,1:thetaresolution:180));
catch
    [iradon_x,iradon_y]=size(radon(ones(resolution,resolution),1:thetaresolution:180));
end
    
data_iradon=[];
data_iradon=[zeros(floor((iradon_x-size(pro,2))/2),size(pro,1));pro'];
data_iradon=[data_iradon;zeros(iradon_x-size(pro,2)-floor((iradon_x-size(pro,2))/2),size(pro,1))];
FBP_result=iradon(data_iradon,90:thetaresolution:269);
FBP_result=FBP_result(2:resolution+1,2:resolution+1);
% 

