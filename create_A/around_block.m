function [ind_list] = around_block(ind,resolution)
x=floor((ind-0.1)/resolution)+1;
y=ind-(x-1)*resolution;
result=[];
if x==1
    if y==1
        result=[1,1;1,2;2,1;2,2];
    elseif y==resolution
        result=[1,resolution;1,resolution-1;2,resolution;2,resolution-1];
    else
        result=[x,y;x,y-1;x,y+1;x+1,y;x+1,y-1;x+1,y+1];
    end
elseif x==resolution
    if y==1
        result=[x,1;x,2;x-1,1;x-1,2];
    elseif y==resolution
        result=[x,y;x,y-1;x-1,y;x-1,y-1];
    else
        result=[x,y;x,y-1;x,y+1;x-1,y;x-1,y-1;x-1,y+1];
    end
else
    if y==1
        result=[x,1;x,2;x-1,1;x-1,2;x+1,1;x+1,2];
    elseif y==resolution
        result=[x,y;x,y-1;x-1,y;x-1,y-1;x+1,y;x+1,y-1];
    else
        result=[x-1,y-1;x,y-1;x+1,y-1;x-1,y;x,y;x+1,y;x-1,y+1;x,y+1;x+1,y+1];
    end
end
ind_list=[];
for i=1:1:size(result,1)
    ind_list=[ind_list,resolution*(result(i,1)-1)+result(i,2)];
end
end

