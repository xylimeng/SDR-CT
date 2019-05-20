function [pro] = projection(AF1,len,loc)
%PROJECTION 此处显示有关此函数的摘要
%   此处显示详细说明
resolution=size(AF1,1);
thetaresolution=180/size(len,1);
xline=zeros(resolution*resolution,1);
for i=1:1:resolution
    for j=1:1:resolution
        ind=(i-1)*resolution+j;
        xline(ind)=AF1(i,j);
    end
end
sparseAprepare=zeros(size(find(loc~=0),1),3);
mm=1;
for i=1:1:180/thetaresolution
    for j=1:1:resolution
        k=1;
        while loc(i,j,k)~=0
            sparseAprepare(mm,:)=[(i-1)*resolution+j,loc(i,j,k),len(i,j,k)];
            k=k+1;
            mm=mm+1;
        end
   end
end
sparseAprepare=sparseAprepare(1:mm-1,:);
m=resolution*180/thetaresolution;
n=resolution*resolution;
sparseA=sparse(sparseAprepare(:,1),sparseAprepare(:,2),sparseAprepare(:,3),m,n);
proline=sparseA*xline;
pro=zeros(180/thetaresolution,resolution);
for i=1:1:180/thetaresolution
    for j=1:1:resolution
        ind=(i-1)*resolution+j;
        pro(i,j)=proline(ind);
    end
end        
end

