clear all
close all
resolution=128;thetaresolution=1;width=0.7;
nol=resolution*180/thetaresolution;
nop=resolution*resolution;dimension=1;
ph=phantom3d(resolution);
AF1=squeeze(ph(:,:,resolution/2));
%calcaulate or load matrix
try
    load('.\create_A\A.mat')
catch
    cd('.\create_A');
    [len,loc,len_width,loc_width] = calculate_A_twice(thetaresolution,resolution,dimension,width);
    save('A.mat','len','loc','len_width','loc_width');
    cd('..\')
end
%calcaulate or load projection
try
    pro_name=['.\projection_data\original_projection\',num2str(resolution/2),'_pro.mat'];
    load(pro_name);
catch
    cd('.\projection_data');
    mkdir('original_projection');
    for i=1:1:resolution
        model=squeeze(ph(:,:,i));
        pro=projection(AF1,len_width,loc_width);
        cd('.\original_projection');
        save([num2str(i),'_pro.mat'],'pro');
        cd('..\')
    end
    cd('..\')
end
%corrupted by gaussian noise and blank edges
try
    pro_name=['.\projection_data\noisy_projection\',num2str(resolution/2),'_pro.mat'];
    load(pro_name);
catch
    cd('.\projection_data')
    mkdir('noisy_projection');
    for i=1:1:resolution
        cd('.\original_projection');
        load([num2str(i),'_pro.mat']);
        pro=pro+0.5*randn(size(pro,1),size(pro,2));
        for ij=1:1:size(pro,1)
            zz=floor(rand(1,1)*floor(size(pro,2)*0.15));
            pro(ij,1:zz)=zeros(1,zz);
            zz=floor(rand(1,1)*floor(size(pro,2)*0.15));
            pro(ij,size(pro,2)-zz+1:size(pro,2))=zeros(1,zz);
        end
        cd('..\noisy_projection')
        save([num2str(i),'_pro.mat'],'pro');
        cd('..\')
    end
    cd('..\')
end
load(['.\projection_data\noisy_projection\',num2str(resolution/2),'_pro.mat']);
FBP;
SDR;
disp(['The result locate in: ',directnew])
load([directnew,'\result_',num2str(resolution/2),'.mat']);
figure(1)
subplot(2,2,1)
imshow(mat2gray(squeeze(ph(:,:,resolution/2))))
title('Model')
subplot(2,2,2)
load(['.\projection_data\noisy_projection\',num2str(resolution/2),'_pro.mat']);
imshow(mat2gray(pro))
title('Pro')
subplot(2,2,3)
imshow(mat2gray(finverse))
title('SDR')
subplot(2,2,4)
imshow(mat2gray(FBP_result))
title('FBP')


