function [len,loc,len_width,loc_width] = calculate_A_twice(thetaresolution,resolution,dimension,width)
%CALCULATE_A_TWICE Summary of this function goes here
%   Detailed explanation goes here


loc=zeros(180/thetaresolution,resolution,5*resolution);
len=zeros(180/thetaresolution,resolution,5*resolution);

loc_width=zeros(180/thetaresolution,resolution,6*resolution);
len_width=zeros(180/thetaresolution,resolution,6*resolution);



for theta=0:thetaresolution:180-thetaresolution
    if theta==0 
       for ii=1:1:resolution 
          for iii=1:1:resolution 
          loc(1,ii,iii)=resolution*(resolution-ii)+iii;
          len(1,ii,iii)=dimension; 
          end
       end  
     elseif theta==90
            for ii=1:1:resolution%
               for iii=1:1:resolution%
               loc(theta/thetaresolution+1,ii,iii)=resolution*(resolution-iii)+(resolution+1-ii);%
               len(theta/thetaresolution+1,ii,iii)=dimension;  
               end
            end
     else 
            for ii=1:1:resolution%%%%%%%%%%%%%%%%%%%%%%%%%%%
                che=1;%
                iii=1;%
                [locax,locay]=start(theta,ii,resolution,dimension);%
                temppro=0;
                locy=2;locx=0;
                while che==1
                store=resolution*(locy-1)+locx;%
                [kk,locaxn,locayn,locx,locy]=location(locax,locay,theta,ii,resolution,dimension);%
                distance=sqrt((locaxn-locax)^2+(locayn-locay)^2);
                if store~=kk
                    len(theta/thetaresolution+1,ii,iii)=distance;
                    loc(theta/thetaresolution+1,ii,iii)=kk;
                else %
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

                end
                  
            end
    end 
end
tic;
for theta=0:thetaresolution:180-thetaresolution
    if floor(theta/30)==theta/30
        theta
    end
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
end

