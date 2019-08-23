# Scalable-CT
Scalable 3D CT reconstruction utilizing sparsity of neighboring slices 
## Parameter set
main function is main_simulation.m
Several parameter can be set at main_simulation like the resolution for the model and thetaresolution for the projection numbers
width is the width of light we set and the pixel's size is 1.

resolution=128;thetaresolution=1;width=0.7;

## Create_matrix A
First time we need to calculate the matrix A, and the matrix will be stored at create_A as '.\create_A\A.mat'

```Matlab
try
    load('.\create_A\A.mat')
catch
    cd('.\create_A');    
    [len,loc,len_width,loc_width] = calculate_A_twice(thetaresolution,resolution,dimension,width);    
    save('A.mat','len','loc','len_width','loc_width');   
    cd('..\')   
end```

## Forward process
Next two section in main_simulation.m is to simulate the projection data.
ratio for blank edges is set as 0.15, we can change in 45 and 47 line

## SDR
SDR algorithm was achieved in SDR.m, top and bottom can be set in SDR.m as the top and bottom slice we need to calculate.

```Matlab
[sparseA] = lenloc2sparse(len_width,loc_width,resolution,thetaresolution,1);
Xs=sparseA;
top=floor(size(pro,2)*0.3);
bottom=floor(size(pro,2)*0.8);
end```
