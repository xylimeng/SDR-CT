clear all
close all
thetaresolution=1;resolution=512;dimension=1;
loc=zeros(180/thetaresolution,resolution,5*resolution);%ÿ��������������λ����Ϣ��129������ϢΪ����Ӹ�������
len=zeros(180/thetaresolution,resolution,5*resolution);%ÿ�����������ص��ཻ����

% cd('D:\Shale_Li')
% load('data.mat')
% cd('D:\Shale_Li\christmas\createnewA')
loc_width=zeros(180/thetaresolution,resolution,6*resolution);%ÿ��������������λ����Ϣ��129������ϢΪ����Ӹ�������
len_width=zeros(180/thetaresolution,resolution,6*resolution);%ÿ�����������ص��ཻ����
width=0.7;

%%%%%%%%%%%%%%%%%%����Ϊ������¹����ͶӰ���̣�������֮ǰ��Сֵ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%
for theta=0:thetaresolution:180-thetaresolution
    theta
%     if floor(theta/30)==theta/30
%         theta
%     end
    if theta==0 
       for ii=1:1:resolution %(�������ӵ�һ�е����һ����ii=resolution��-1:1)
          for iii=1:1:resolution % ������������������iii=1:1:resolution
          loc(1,ii,iii)=resolution*(resolution-ii)+iii;%���˾����ĸ���λ����Ϣ
          len(1,ii,iii)=dimension;%ÿ����㳤�Ⱦ�Ϊ1    
          end
       end  
     elseif theta==90
            for ii=1:1:resolution%��������������������128��-1:1��
               for iii=1:1:resolution%���������ϵ���������128��-1:1
               loc(theta/thetaresolution+1,ii,iii)=resolution*(resolution-iii)+(resolution+1-ii);%���˾�����128������λ����Ϣ
               len(theta/thetaresolution+1,ii,iii)=dimension;%ÿ����㳤�Ⱦ�Ϊ2/127    
               end
            end
     else 
            for ii=1:1:resolution%Ŀǰ���˽ǶȺ;������ֵtheta�ǽǶȣ�ii��ʾ�����1��resolution�Ƕ�С��90���ʱ�򣬴��µ��ϡ�%%%%%%%%%%%%%%%%%%%%%%%%%%%
                che=1;%����Ƿ񳬳���Χ
                iii=1;%ϵ������ÿһ�����洢λ�á��ĵ�ַ
                [locax,locay]=start(theta,ii,resolution,dimension);%�ҵ���һ������Ľ���x,y
                temppro=0;
                locy=2;locx=0;
                while che==1
                store=resolution*(locy-1)+locx;%�洢֮ǰһ����λ��
                [kk,locaxn,locayn,locx,locy]=location(locax,locay,theta,ii,resolution,dimension);%�������λ�ò�������һ��
                distance=sqrt((locaxn-locax)^2+(locayn-locay)^2);
                if store~=kk
                    len(theta/thetaresolution+1,ii,iii)=distance;
                    loc(theta/thetaresolution+1,ii,iii)=kk;
                else %���֮ǰ�����˵�����������⣬�ᱻ����
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

for theta=0:thetaresolution:180-thetaresolution
%for theta=10:1:10
    theta
%     if floor(theta/30)==theta/30
%         theta
%     end
    if theta==0 
       for ii=1:1:resolution %(�������ӵ�һ�е����һ����ii=resolution��-1:1)
          for iii=1:1:resolution % ������������������iii=1:1:resolution
          loc_width(1,ii,iii)=resolution*(resolution-ii)+iii;%���˾����ĸ���λ����Ϣ
          len_width(1,ii,iii)=dimension;%ÿ����㳤�Ⱦ�Ϊ1    
          end
       end  
     elseif theta==90
            for ii=1:1:resolution%��������������������128��-1:1��
               for iii=1:1:resolution%���������ϵ���������128��-1:1
               loc_width(theta/thetaresolution+1,ii,iii)=resolution*(resolution-iii)+(resolution+1-ii);%���˾�����128������λ����Ϣ
               len_width(theta/thetaresolution+1,ii,iii)=dimension;%ÿ����㳤�Ⱦ�Ϊ2/127    
               end
            end
    else 
            thetareal=theta/thetaresolution+1;
            parfor ii=1:1:resolution%Ŀǰ���˽ǶȺ;������ֵtheta�ǽǶȣ�ii��ʾ�����1��resolution�Ƕ�С��90���ʱ�򣬴��µ��ϡ�%%%%%%%%%%%%%%%%%%%%%%%%%%%               
%                 [theta,ii]
                [theta,ii]
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
                slice_loc_width=[polyshape_indlist(:);zeros(6*resolution-size(polyshape_indlist,2),1)];
                
                loc_width(thetareal,ii,:)=slice_loc_width;
                slice_len_width=[arealist(:)/width;zeros(6*resolution-size(arealist,2),1)];
                len_width(thetareal,ii,:)=slice_len_width;
%                 for ij=1:1:size(polyshape_indlist,2)
%                     loc_width(theta,ii,ij)=polyshape_indlist(ij);
%                     len_width(theta,ii,ij)=arealist(ij)/width;%��һ��ʹ��ƽ������ʱ��ÿ�����ع���Ϊ1
%                 end
            end
    end
end

for i=2:1:size(loc,1)
    for j=1:1:size(loc,2)
        I=zeros(resolution,resolution);
        Inew=zeros(resolution,resolution);
        for k=1:1:size(loc,3)
            if loc(i,j,k)==0
                break
            else
                mm=loc(i,j,k);
                x=floor((mm-0.5)/resolution)+1;
                y=mm-(x-1)*resolution;
                I(x,y)=len(i,j,k);
            end
        end
        for k=1:1:size(loc_width,3)
            if loc_width(i,j,k)==0
                break
            else
                mm=loc_width(i,j,k);
                x=floor((mm-0.5)/resolution)+1;
                y=mm-(x-1)*resolution;
                Inew(x,y)=len_width(i,j,k);
            end
        end
        figure(1)
        subplot(1,2,1)
        imshow(I)
        subplot(1,2,2)
        imshow(Inew)
        pause(0.2)
        
    end
    
end
            


