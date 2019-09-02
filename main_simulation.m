clear all
close all
% Global set:Necessary forboth simulation and real data
resolution=128;thetaresolution=1;width=0.7;
nol=resolution*180/thetaresolution;
nop=resolution*resolution;dimension=1;
test_slice=resolution/2;
simulation=true;
% load or calculate matrix_A, 
% the returned variables are saved in ".\create_A\A.mat" for quick access;
[len,loc,len_width,loc_width] = load_matrix_A(thetaresolution,resolution,dimension,width);
%len_width,loc_width are bilinear interpolation, len,loc are line_driven methods
globalstruct=struct('resolution',resolution,'thetaresolution',thetaresolution,'len_width',len_width,'loc_width',loc_width);
%globalstruct=struct('resolution',resolution,'thetaresolution',thetaresolution,'len_width',len,'loc_width',loc);


% Set by client for simulation data If projection data is ready, ignore this part
if simulation
    ph=phantom3d(resolution);
    AF1=squeeze(ph(:,:,test_slice));

    noise_parameter=struct();
    noise_parameter.resolution=resolution;
    noise_parameter.add_gaussian=1;% 1 for add gaussian noise, If 1 is choosen, then client should choose noise_paramter.gaussian
    noise_parameter.add_blankedges=1;% 1 for add blankedges, If
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
    pro_direction='.\projection_data\noisy_projection\';%if simulation data was used, direction is ".\projection_data\noisy_projection\"
    %%%%%%%%%%%%%%%%
else
    pro_direction='';%Record the direction of real data here, make sure that the observation data's name is 'X_pro.mat'
end
    



%%%Inverse_algorithm
FBP_result_direct=FBP_algorithm(pro_direction,globalstruct);

SDR_param=struct();
SDR_param.TVresidual=-1;% if residual choose less than 0, then stop rule is iteration times
SDR_param.TVmaxIte=4;
SDR_param.TVSHUF=true;
SDR_param.OutmaxIte=3;
%SDR_param.top=floor(size(pro,2)*0.3);
%SDR_param.bottom=floor(size(pro,2)*0.8);
SDR_param.top=38;
SDR_param.bottom=70;


directnew = SDR_algorithm(globalstruct,SDR_param,pro_direction);
disp(['The result locate in: ',directnew])

figure(1)
load([directnew,'\result_',num2str(test_slice),'.mat']);
load([FBP_result_direct,'FBPresult_',num2str(test_slice),'.mat']);
subplot(2,2,1)
imshow(mat2gray(squeeze(ph(:,:,test_slice))))
title('Model')
subplot(2,2,2)
load(['.\projection_data\noisy_projection\',num2str(test_slice),'_pro.mat']);
imshow(mat2gray(pro))
title('Observation')
subplot(2,2,3)
imshow(mat2gray(finverse))
title('SDR')
subplot(2,2,4)
imshow(mat2gray(FBP_result))
title('FBP')
