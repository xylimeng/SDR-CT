clear all
close all
% Global set:Necessary forboth simulation and real data
resolution=128;thetaresolution=1;width=0.7;
nol=resolution*180/thetaresolution;
nop=resolution*resolution;dimension=1;
test_slice=resolution/2;
Simulation=true;
% load or calculate matrix_A, 
% the returned variables are saved in ".\create_A\A.mat" for quick access;
[len,loc,len_width,loc_width] = load_matrix_A(thetaresolution,resolution,dimension,width);
globalstruct=struct('resolution',resolution,'thetaresolution',thetaresolution,'len_width',len_width,'loc_width',loc_width);


% Set by client for simulation data If projection data is ready, ignore this part
if simulation
    ph=phantom3d(resolution);
    AF1=squeeze(ph(:,:,test_slice));


    noise_parameter=struct();
    noise_parameter.add_gaussian='1';% 1 for add gaussian noise
    noise_parameter.add_blankedges='1';
    noise_parameter.gaussian=0.5;% 0.5*randn(size(pro,1),size(pro,2))
    noise_parameter.blankedges_ratio=0.15;%The higher the worse of blank edges problem;


    % load or calculate simulated noiseless projection, 
    % the returned variables are saved in ".\projection_data\original_projection\" for quick access:
    inputstruct=struct('resolution',resolution,'ph',ph,'AF1',AF1,'len_width',len_width,'loc_width',loc_width);
    inputstruct.thetaresolution=thetaresolution;
    proture = load_pro(test_slice,inputstruct);
    % load or calculate projection corrupted by gaussian noise and blank edges, 
    % the returned variables are saved in ".\projection_data\noisy_projection\" for quick access:
    pro=addnoise(test_slice,noise_parameter);
    %%%%%%%%%%%%%%%%
end
    



%%%Inverse_algorithm
pro_direction='.\projection_data\noisy_projection\';
FBP_result=FBP_algorithm(test_slice,pro_direction,globalstruct);

SDR_param=struct();
SDR_param.add_gaussian='1';% 1 for add gaussian noise
SDR_param.add_blankedges='1';
SDR_param.gaussian=0.5;% 0.5*randn(size(pro,1),size(pro,2))
SDR_param.blankedges_ratio=0.15;%The higher the worse of blank edges problem;

SDR_result=SDR_algorithm();

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


