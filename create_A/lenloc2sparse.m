function [sparseA] = lenloc2sparse(len,loc,resolution,thetaresolution,direction)
sparseAprepare=zeros(size(find(loc~=0),1),3);
mm=1;
if direction==1
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
else
    for i=1:1:resolution
       for j=1:1:resolution
           ind=(i-1)*resolution+j;
           k=1;
           while loc(ind,k)~=0
               sparseAprepare(mm,:)=[loc(ind,k),ind,len(ind,k)];
               k=k+1;
               mm=mm+1;
           end
       end
    end
end
    

sparseAprepare=sparseAprepare(1:mm-1,:);
m=resolution*180/thetaresolution;
n=resolution*resolution;
try
   sparseA=sparse(sparseAprepare(:,1),sparseAprepare(:,2),sparseAprepare(:,3),m,n);
catch ErrorInfo %捕获到的错误是一个MException对象
    disp(ErrorInfo);

end
end

