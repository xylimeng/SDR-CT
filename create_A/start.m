function [x,y] = start(theta,ii,resolution,dimension)
d=(ii-resolution/2-1/2)*dimension;
if theta<90
    y=-(resolution/2)*dimension;
    x=(cos(theta*pi/180)*y-d)/sin(theta*pi/180);
    if x<-(resolution/2)*dimension
        x=-(resolution/2)*dimension;
        y=(sin(theta*pi/180)*x+d)/cos(theta*pi/180);
    end
else
    x=(resolution/2)*dimension;
    y=(sin(theta*pi/180)*x+d)/cos(theta*pi/180);
    if y<-(resolution/2)*dimension
        y=-(resolution/2)*dimension;
        x=(cos(theta*pi/180)*y-d)/sin(theta*pi/180);
    end
end