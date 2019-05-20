function [a,locaxn,locayn,locx,locy] = location(locax,locay,theta,ii,resolution,dimension)
d=(ii-resolution/2-1/2)*dimension;
  if theta<=90
      xnew=floor((locax+dimension)/dimension);
      ynew=floor((locay+dimension)/dimension);  
      xneww=(cos(theta*pi/180)*ynew-d)/sin(theta*pi/180);
      if xneww>xnew
          ynew=(sin(theta*pi/180)*xnew+d)/cos(theta*pi/180);
      else
          xnew=xneww;
      end
      locaxn=xnew;
      locayn=ynew;
      locx=(locaxn+locax)/2;
      locx=resolution/2+floor(locx/dimension)+1;
      locy=(locayn+locay)/2;
      locy=resolution/2-floor(locy/dimension);    
      a=(locy-1)*(resolution)+locx;
  else
      %xnew=floor((locax-dimension)/dimension);
      if floor(locax)==locax
         xnew=floor((locax-dimension)/dimension);
      else
         xnew=floor((locax)/dimension);
      end
      ynew=floor((locay+dimension)/dimension);  
      xneww=(cos(theta*pi/180)*ynew-d)/sin(theta*pi/180);
      if xneww<xnew
         ynew=(sin(theta*pi/180)*xnew+d)/cos(theta*pi/180);
      else
         xnew=xneww;
      end
      
      
%       if abs(xnew-locax)>dimension
%           xnew=xnew+dimension;
%           ynew=(sin(theta*pi/180)*xnew+d)/cos(theta*pi/180);
%       end
%       if abs(ynew-locay)>dimension
%           ynew=ynew+dimension;
%           xnew=(cos(theta*pi/180)*ynew-d)/sin(theta*pi/180);
%       end
      
      
      
      locaxn=xnew;
      locayn=ynew;
      locx=(locaxn+locax)/2;
      locx=resolution/2+floor(locx/dimension)+1;
      locy=(locayn+locay)/2;
      locy=resolution/2-floor(locy/dimension);  
      
      
      a=(locy-1)*(resolution)+locx;

  end
%   if locx<1
% [theta,ii]
%        locx=1;
%   end
end
        
        
    
    
    
    
    
    
    