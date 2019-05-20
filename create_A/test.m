m=phantom('Modified Shepp-Logan',resolution);
mvector=reshape(m',resolution*resolution,1);

R = radon(m,0:thetaresolution:180-180/thetaresolution);
figure(1)
imshow(mat2gray(R))

A=full(lenloc2sparse(len,loc,resolution,thetaresolution,1));
projection=A*mvector;
figure(2)
subplot(1,2,1)
imshow(mat2gray(reshape(projection,resolution,180/thetaresolution)))
Standard_K;
subplot(1,2,2)
finverse=finverse_direct;
imshow(mat2gray(finverse_direct))

A=full(lenloc2sparse(len_width,loc_width,resolution,thetaresolution,1));
projection=A*mvector;
figure(3)
subplot(1,2,1)
imshow(mat2gray(reshape(projection,resolution,180/thetaresolution)))
Standard_K;
subplot(1,2,2)
imshow(mat2gray(finverse_direct))

figure(4)
imshow(mat2gray(finverse_direct-finverse))