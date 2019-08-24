# Scalable-CT
Scalable 3D CT reconstruction utilizing sparsity of neighboring slices 

## Parameter set
main function is main_simulation.m
Several parameter can be set at main_simulation like the resolution for the model and thetaresolution for the projection numbers
width is the width of light we set and the pixel's size is 1.

```Matlab
resolution=128;thetaresolution=1;width=0.7;
nol=resolution*180/thetaresolution;
nop=resolution*resolution;dimension=1;
ph=phantom3d(resolution);
AF1=squeeze(ph(:,:,resolution/2));
```

## Create_matrix A & Forward process
First time we need to calculate 
1.Matrix A: the returned variables are saved in '.\create_A\A.mat'" for quick access.
2.Simulated projection data. the returned variables are saved in '.\projection_data" for quick access.
  
  
## Input
If real data is going to be applied in this algorithm, Please save the input (projection data) in the save path as simulated projection data.

## SDR
SDR algorithm was achieved in SDR.m, top and bottom can be set in SDR.m as the top and bottom slice we need to calculate.

```Matlab
[sparseA] = lenloc2sparse(len_width,loc_width,resolution,thetaresolution,1);
Xs=sparseA;
top=floor(size(pro,2)*0.3);
bottom=floor(size(pro,2)*0.8);
```

## Output
According to different iteration times(the path for even iteration time and oll iteration time is different), the console in Matlab will show the path for the output path as 
```Matlab
disp(['The result locate in: ',directnew])
```
Then you can choose one slice of the result as

```Matlab
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
```

## Result



