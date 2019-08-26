function pro=addnoise(test_slice,noise_parameter)
%ADDNOISE 此处显示有关此函数的摘要
%   此处显示详细说明
if noise_parameter.add_gaussian==1
    gauss=noise_parameter.gaussian;
else
    gauss=0;
end
    
if noise_parameter.add_blankedges==1
    bkratio=noise_parameter.blankedges_ratio;
else
    bkratio=0;
end


try
    pro_name=['.\projection_data\noisy_projection\',num2str(test_slice),'_pro.mat'];
    load(pro_name);
catch
    cd('.\projection_data')
    mkdir('noisy_projection');
    for i=1:1:resolution
        cd('.\original_projection');
        load([num2str(i),'_pro.mat']);
        pro=pro+gauss*randn(size(pro,1),size(pro,2));
        for ij=1:1:size(pro,1)
            zz=floor(rand(1,1)*floor(size(pro,2)*bkratio));
            pro(ij,1:zz)=zeros(1,zz);
            zz=floor(rand(1,1)*floor(size(pro,2)*bkratio));
            pro(ij,size(pro,2)-zz+1:size(pro,2))=zeros(1,zz);
        end
        cd('..\noisy_projection')
        save([num2str(i),'_pro.mat'],'pro');
        cd('..\')
    end
    cd('..\')
end
    pro_name=['.\projection_data\noisy_projection\',num2str(test_slice),'_pro.mat'];
    load(pro_name);
    pro=pro;
end

