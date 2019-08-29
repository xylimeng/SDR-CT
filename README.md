# Scalable Double Regularization for 3D Nano-CT Reconstruction
We utilize the entire 3D Nano-CT volume for simultaneous 3D structural reconstruction across slices through total variation regularization within slices and $L_1$ regularization between adjacent slices.

## Examples 
The followling demonstration is also in the `main_simulation.m` script.  

### Global parameter setting
```Matlab
% Global set: Necessary for both simulation and real data
resolution=128; thetaresolution=1; width=0.7;
nol=resolution*180/thetaresolution;
nop=resolution*resolution;dimension=1;
simulation=true; (???)
[len,loc,len_width,loc_width] = load_matrix_A(thetaresolution,resolution,dimension,width);
len=len_width; (???)
loc=loc_width; (???) 
globalstruct=struct('resolution',resolution,'thetaresolution',thetaresolution,'len_width',len,'loc_width',loc);
```

If `simulation` is set as true, the code will use simulated data. 

### Simulate 3D CT projection data 'pro' using 3D Shepp-logan model
```Matlab
    ph=phantom3d(resolution);
    AF1=squeeze(ph(:,:,test_slice));

    noise_parameter=struct();
    noise_parameter.resolution=resolution;
    noise_parameter.add_gaussian=1;% indicator for adding gaussian noise
    noise_parameter.add_blankedges=1;
    noise_parameter.gaussian=0.5;% 0.5*randn(size(pro,1),size(pro,2))
    noise_parameter.blankedges_ratio=0.15;%The higher the worse of blank edges problem;
``` 

Comments: 
- We can further add Gaussian noise to the projection data (???). Users can vary the leval of gaussian noise and blankedges_ratio.

### Calculate FBP result
```Matlab
pro_direction='.\projection_data\noisy_projection\';
test_slice=resolution/2; % test_slice indicates which slice is to be used for displaying the reconstruction
FBP_result=FBP_algorithm(test_slice,pro_direction,globalstruct);
``` 
Comments: 
- The function `FBP_algorithm` calculates every slices of the data (from top to bottom). Users can find result from the direction in "directnew".(???) 

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
- 2. The function `SDR_algorithm` calculates all slices ranging from specified `top` to `bottom` of the data. Users can find reconstructions from the direction in `directnew`. 

## Result
![image](https://github.com/xylimeng/Scalable-CT/blob/master/Result.png)


