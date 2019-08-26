function [proture] = load_pro(test_slice,inputstruct)
try
    pro_name=['.\projection_data\original_projection\',num2str(test_slice),'_pro.mat'];
    load(pro_name);
    proture=pro;
catch
    resolution=inputstruct.resolution;
    ph=inputstruct.ph;
    AF1 =inputstruct.AF1;
    len_width=inputstruct.len_width;
    loc_width=inputstruct.loc_width;
    
    
    cd('.\projection_data');
    mkdir('original_projection');
    for i=1:1:resolution
        model=squeeze(ph(:,:,i));
        pro=projection(AF1,len_width,loc_width);
        cd('.\original_projection');
        save([num2str(i),'_pro.mat'],'pro');
        cd('..\')
    end
    cd('..\')
    
    pro_name=['.\projection_data\original_projection\',test_slice,'_pro.mat'];
    load(pro_name);
    proture=pro;
end
end

