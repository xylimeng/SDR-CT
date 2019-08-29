# Scalable Double Regularization for 3D Nano-CT Reconstruction
We utilize the entire 3D Nano-CT volume for simultaneous 3D structural reconstruction across slices through total variation regularization within slices and $L_1$ regularization between adjacent slices.

## Examples 
The followling demonstration is also in the `main_simulation.m` script.  

### Global parameter setting
```Matlab
% Global set:Necessary forboth simulation and real data
resolution=128;thetaresolution=1;width=0.7;
nol=resolution*180/thetaresolution;
nop=resolution*resolution;dimension=1;
test_slice=resolution/2;
simulation=true;
[len,loc,len_width,loc_width] = load_matrix_A(thetaresolution,resolution,dimension,width);
len=len_width;
loc=loc_width;
globalstruct=struct('resolution',resolution,'thetaresolution',thetaresolution,'len_width',len,'loc_width',loc);
```
Comments: 
- 1. If simulation is set as true, it means the code will use simulated data. 


Comments: If simulation is set as true, it means the code will use simulated data. 

### Simulate 3D CT projection data 'pro' 
```Matlab
    ph=phantom3d(resolution);
    AF1=squeeze(ph(:,:,test_slice));

    noise_parameter=struct();
    noise_parameter.resolution=resolution;
    noise_parameter.add_gaussian=1;% 1 for add gaussian noise
    noise_parameter.add_blankedges=1;
    noise_parameter.gaussian=0.5;% 0.5*randn(size(pro,1),size(pro,2))
    noise_parameter.blankedges_ratio=0.15;%The higher the worse of blank edges problem;
``` 

Comments: 
- 1. Simulation data is 3D Shepp-logan model. 
- 2. We can further add Gaussian noise to the projection data; We can choose the parameter for different leval of gaussian noise and blankedges_ratio.

### Calculate FBP result
```Matlab
pro_direction='.\projection_data\noisy_projection\';
FBP_result=FBP_algorithm(test_slice,pro_direction,globalstruct);
``` 
Comments: 
- 1. The function FBP_algorithm calculate every slices of the data, the test_slice is just used for showing of result

### Calculate SDR result
```Matlab
SDR_param=struct();
SDR_param.TVresidual=-1;% if residual choose less than 0, then stop rule is iteration times
SDR_param.TVmaxIte=4;
SDR_param.TVSHUF=true;
SDR_param.OutmaxIte=3;
%SDR_param.top=floor(size(pro,2)*0.3);
%SDR_param.bottom=floor(size(pro,2)*0.8);
SDR_param.top=38;
SDR_param.bottom=60;
directnew = SDR_algorithm(globalstruct,SDR_param,pro_direction);
```
Comments: 
- 1. First Set for SDR param. 
- 2. The function FBP_algorithm calculate every slices(from top to bottom) of the data. Then client can find result from the direction in "directnew"
## Result
![image](https://github.com/xylimeng/Scalable-CT/blob/master/Result.png)


