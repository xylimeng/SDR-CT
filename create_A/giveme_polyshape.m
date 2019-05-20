function [output_polyshape] = giveme_polyshape(ind_list,resolution,dimension)
output_polyshape=[];
for i=1:1:size(ind_list,2)
    ind=ind_list(i);
    x=floor((ind-0.1)/resolution)+1;
    y=ind-(x-1)*resolution;
    size_lattice=dimension;
    x1=-resolution/2+(y-1)*size_lattice;
    x2=x1+size_lattice;
    y1=resolution/2-(x-1)*size_lattice;
    y2=y1-size_lattice;
    output_polyshape=[output_polyshape,polyshape([x1,x2,x2,x1],[y1,y1,y2,y2])];
end
end

