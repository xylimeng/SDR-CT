function [len,loc,len_width,loc_width] = calculate_A_twice(thetaresolution,resolution,dimension,width)
%CALCULATE_A_TWICE Summary of this function goes here
%   Detailed explanation goes here

%thetaresolution=30;resolution=8;dimension=1;width=0.7;
loc=zeros(180/thetaresolution,resolution,5*resolution);
len=zeros(180/thetaresolution,resolution,5*resolution);

loc_width=zeros(180/thetaresolution,resolution,6*resolution);
len_width=zeros(180/thetaresolution,resolution,6*resolution);



for theta=0:thetaresolution:180-thetaresolution
    %theta
%     if floor(theta/30)==theta/30
%         theta
%     end
    if theta==0 
       for ii=1:1:resolution %(行数，从第一行到最后一行有ii=resolution：-1:1)
          for iii=1:1:resolution % 列数，从左到右依次有iii=1:1:resolution
          loc(1,ii,iii)=resolution*(resolution-ii)+iii;%存了经过的格点的位置信息
          len(1,ii,iii)=dimension;%每个格点长度均为1    
          end
       end  
     elseif theta==90
            for ii=1:1:resolution%（列数，从左到右依次是128：-1:1）
               for iii=1:1:resolution%行数，从上到下依次是128：-1:1
               loc(theta/thetaresolution+1,ii,iii)=resolution*(resolution-iii)+(resolution+1-ii);%存了经过的128个格点的位置信息
               len(theta/thetaresolution+1,ii,iii)=dimension;%每个格点长度均为2/127    
               end
            end
     else 
            for ii=1:1:resolution%目前有了角度和距离的数值theta是角度，ii表示距离从1到resolution角度小于90°的时候，从下到上。%%%%%%%%%%%%%%%%%%%%%%%%%%%
                che=1;%检测是否超出范围
                iii=1;%系数矩阵每一个“存储位置”的地址
                [locax,locay]=start(theta,ii,resolution,dimension);%找到第一个方格的交点x,y
                temppro=0;
                locy=2;locx=0;
                while che==1
                store=resolution*(locy-1)+locx;%存储之前一个的位置
                [kk,locaxn,locayn,locx,locy]=location(locax,locay,theta,ii,resolution,dimension);%输出像素位置并迭代下一步
                distance=sqrt((locaxn-locax)^2+(locayn-locay)^2);
                if store~=kk
                    len(theta/thetaresolution+1,ii,iii)=distance;
                    loc(theta/thetaresolution+1,ii,iii)=kk;
                else %如果之前存过，说明可能有问题，会被误判
                    if iii>1
                        iii=iii-1;
                        len(theta/thetaresolution+1,ii,iii)=max(distance,len(theta/thetaresolution+1,ii,iii));
                    end
                end
                locax=locaxn;
                locay=locayn;
                  if locax<=-(resolution/2)*dimension || locay<=-(resolution/2)*dimension || locax>=(resolution/2)*dimension || locay>=(resolution/2)*dimension
                  che=0;
                  break;
                  else 
                  iii=iii+1;
                  end
%                   if   store~=kk
%                   tempprohistory=temppro;
%                   temppro=temppro+len(theta/thetaresolution+1,ii,iii-1)*AF1(locy,locx);
%                   else
%                   temppro=tempprohistory+len(theta/thetaresolution+1,ii,iii-1)*AF1(locy,locx) ;
%                   end
                 
                end
                  
            end
    end 
end
tic;
for theta=0:thetaresolution:180-thetaresolution
    if theta==0 
       for ii=1:1:resolution 
          for iii=1:1:resolution 
          loc_width(1,ii,iii)=resolution*(resolution-ii)+iii;
          len_width(1,ii,iii)=dimension;    
          end
       end  
     elseif theta==90
            for ii=1:1:resolution
               for iii=1:1:resolution
               loc_width(theta/thetaresolution+1,ii,iii)=resolution*(resolution-iii)+(resolution+1-ii);
               len_width(theta/thetaresolution+1,ii,iii)=dimension;  
               end
            end
     else 
            for ii=1:1:resolution    
                %[theta,ii,toc]
                starttocheck=1;
                polyshape_indlist=[];
                while loc(theta/thetaresolution+1,ii,starttocheck)~=0
                    ind=loc(theta/thetaresolution+1,ii,starttocheck);
                    aroundlist=around_block(ind,resolution);
                    polyshape_indlist=[polyshape_indlist,aroundlist];
                    starttocheck=starttocheck+1;
                end
                if size(polyshape_indlist,1)==0
                    continue
                end
                polyshape_indlist=unique(polyshape_indlist);
                polyshape_list=giveme_polyshape(polyshape_indlist,resolution,dimension);
                rayshape=ray_polyshape(theta,ii,resolution,dimension,width);
                arealist=area(intersect(rayshape,polyshape_list));
                loc_width(theta/thetaresolution+1,ii,:)=[polyshape_indlist(:);zeros(6*resolution-size(polyshape_indlist,2),1)];
                len_width(theta/thetaresolution+1,ii,:)=[arealist(:)/width;zeros(6*resolution-size(arealist,2),1)];
            end
    end
end

% for i=2:1:size(loc,1)
%     for j=1:1:size(loc,2)
%         I=zeros(resolution,resolution);
%         Inew=zeros(resolution,resolution);
%         for k=1:1:size(loc,3)
%             if loc(i,j,k)==0
%                 break
%             else
%                 mm=loc(i,j,k);
%                 x=floor((mm-0.5)/resolution)+1;
%                 y=mm-(x-1)*resolution;
%                 I(x,y)=len(i,j,k);
%             end
%         end
%         for k=1:1:size(loc_width,3)
%             if loc_width(i,j,k)==0
%                 break
%             else
%                 mm=loc_width(i,j,k);
%                 x=floor((mm-0.5)/resolution)+1;
%                 y=mm-(x-1)*resolution;
%                 Inew(x,y)=len_width(i,j,k);
%             end
%         end
%         figure(1)
%         subplot(1,2,1)
%         imshow(I) 
%         subplot(1,2,2)
%         imshow(Inew)
%     end   
% end


end

