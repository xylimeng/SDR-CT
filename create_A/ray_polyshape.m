function [result] = ray_polyshape(theta,ii,resolution,dimension,width)
%RAY_POLYSHAPE 此处显示有关此函数的摘要
%   给定光线返回光线所在polyshape
d=(ii-resolution/2-1/2)*dimension;
d1=d-width/2;
d2=d+width/2;
x=-resolution;
y=-resolution;
if theta<90
    if (cos(theta*pi/180)*y-d)/sin(theta*pi/180)<-resolution
        x1=-resolution; y1=(sin(theta*pi/180)*x1+d1)/cos(theta*pi/180);
        x2= resolution; y2=(sin(theta*pi/180)*x2+d1)/cos(theta*pi/180);
        x3= resolution; y3=(sin(theta*pi/180)*x3+d2)/cos(theta*pi/180);
        x4=-resolution; y4=(sin(theta*pi/180)*x4+d2)/cos(theta*pi/180);
    else
        y1=-resolution; x1=(cos(theta*pi/180)*y1-d1)/sin(theta*pi/180);
        y2= resolution; x2=(cos(theta*pi/180)*y2-d1)/sin(theta*pi/180);
        y3= resolution; x3=(cos(theta*pi/180)*y3-d2)/sin(theta*pi/180);
        y4=-resolution; x4=(cos(theta*pi/180)*y4-d2)/sin(theta*pi/180);
    end
else
    if (cos(theta*pi/180)*y-d)/sin(theta*pi/180)<-resolution
        x1=-resolution; y1=(sin(theta*pi/180)*x1+d1)/cos(theta*pi/180);
        x2= resolution; y2=(sin(theta*pi/180)*x2+d1)/cos(theta*pi/180);
        x3= resolution; y3=(sin(theta*pi/180)*x3+d2)/cos(theta*pi/180);
        x4=-resolution; y4=(sin(theta*pi/180)*x4+d2)/cos(theta*pi/180);
    else
        y1=-resolution; x1=(cos(theta*pi/180)*y1-d1)/sin(theta*pi/180);
        y2= resolution; x2=(cos(theta*pi/180)*y2-d1)/sin(theta*pi/180);
        y3= resolution; x3=(cos(theta*pi/180)*y3-d2)/sin(theta*pi/180);
        y4=-resolution; x4=(cos(theta*pi/180)*y4-d2)/sin(theta*pi/180);
    end
end   
result=polyshape([x1,x2,x3,x4],[y1,y2,y3,y4]);
end


