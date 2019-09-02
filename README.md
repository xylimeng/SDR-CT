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
simulation=true; 
[len,loc,len_width,loc_width] = load_matrix_A(thetaresolution,resolution,dimension,width);
globalstruct=struct('resolution',resolution,'thetaresolution',thetaresolution,'len_width',len_width,'loc_width',loc_width);
```

If `simulation` is set as `true`, the code will use simulated data. For real data application, set `simulation` as `false` and put observations into one directory and save the path of this directory to the variable `pro_direction`. 

### Simulate 3D CT projection data 'pro' using 3D Shepp-logan model
```Matlab
ph=phantom3d(resolution);
AF1=squeeze(ph(:,:,test_slice));

noise_parameter=struct();
noise_parameter.resolution=resolution;
% Add Gaussian noise 
noise_parameter.add_gaussian=1;% 1 to indicate adding gaussian noise. If 1 is chosen, then users should specify noise_paramter.gaussian
noise_parameter.gaussian=0.5;% 0.5*randn(size(pro,1),size(pro,2)) % standard derivation of Gaussian noise 

% Add blank edges 
noise_parameter.add_blankedges=1;% 1 to indicate adding blankedges. If 1 is chosen, then users should specify noise_parameter.blankedges_ratio
noise_parameter.blankedges_ratio=0.15; % Higher ratio means more blank edges. 
``` 

### Calculate FBP reconstructions
```Matlab
% Reconstruct all slices of the data (from the first to the last). 
% Users can find the reconstructions from the directory saved in FBP_result_direct.
FBP_result_direct=FBP_algorithm(pro_direction,globalstruct);
``` 

### Calculate SDR reconstructions
```Matlab
% First Set for SDR param.
SDR_param=struct();
SDR_param.TVresidual=-1;% if residual choose less than 0, then stop rule is iteration times
SDR_param.TVmaxIte=4;
SDR_param.TVSHUF=true;
SDR_param.OutmaxIte=3;
%SDR_param.top=floor(size(pro,2)*0.3);
%SDR_param.bottom=floor(size(pro,2)*0.8);
SDR_param.top=38;
SDR_param.bottom=70;

% Reconstruct all slices ranging from specified `top` to `bottom` of the data. 
% Users can find reconstructions from the directory saved in `directnew`. 
directnew = SDR_algorithm(globalstruct,SDR_param,pro_direction);
```

## Result
We compare the reconstructions by FBP and SDR using the 60th slice:

![image](https://github.com/xylimeng/SDR-CT/blob/master/Result2.png)



