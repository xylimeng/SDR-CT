# Scalable Double Regularization for 3D Nano-CT Reconstruction
We utilize the entire 3D Nano-CT volume for simultaneous 3D structural reconstruction across slices through total variation regularization within slices and $L_1$ regularization between adjacent slices.

## Examples using simulated data 
The followling demonstration is also in the `main_simulation.m` script.  

### Simulate 3D CT projection data 'pro' 

```Matlab
%% Specify experiemental parameters & Simulate the true 3D structure 
resolution=128; % resolution for the model
thetaresolution=1; % thetaresolution for the projection numbers
width=0.7; % width of light (the pixel's size is 1)
nol=resolution*180/thetaresolution;
nop=resolution*resolution;dimension=1;
ph=phantom3d(resolution);
AF1=squeeze(ph(:,:,resolution/2));

%% Create matrix A
% the returned variables are saved in '.\create_A\A.mat'" for quick access.
[len,loc,len_width,loc_width] = calculate_A_twice(thetaresolution,resolution,dimension,width);

%% Generate projection data using a forward process 
% the returned variables are saved in '.\projection_data" for quick access.
    for i=1:1:resolution
        model=squeeze(ph(:,:,i));
        pro=projection(AF1,len_width,loc_width);
    end
```

Comments: 
- 1. For real data application, users just need to substitute the simulated projection data `pro` with the real projection data.
- 2. In this simulation, we can further add Gaussian noise to the projection data; see `main_simulation.m` for details. 

### Apply SDR
SDR algorithm is implemented in `SDR.m`.

```Matlab
SDR; 
```

### Output
According to different iteration times (the path for even iteration time and oll iteration time is different), the console in Matlab will show the path for the output path as 
```Matlab
disp(['The result locate in: ',directnew])
```
Choose one slice of the result for visualization: 

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
![image](https://github.com/xylimeng/Scalable-CT/blob/master/Result.png)


