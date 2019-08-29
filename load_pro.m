function [proture] = load_pro(test_slice,inputstruct)
try
    pro_name=['.\projection_data\original_projection\',num2str(test_slice),'_pro.mat'];
    load(pro_name);
    proture=pro;
catch
    fprintf('No pro data was found.\n');
    resolution=inputstruct.resolution;
    ph=inputstruct.ph;
    AF1 =inputstruct.AF1;
    len_width=inputstruct.len_width;
    loc_width=inputstruct.loc_width;
    cd('.\projection_data');
    mkdir('original_projection');
    for i=1:1:resolution
        model=squeeze(ph(:,:,i));
        pro=projection(model,len_width,loc_width);
        cd('.\original_projection');
        save([num2str(i),'_pro.mat'],'pro');
        cd('..\')
        fprintf('Slice %g projection data was finished. Total num of slices is %g\n',i,resolution);
    end
    cd('..\')
    
    pro_name=['.\projection_data\original_projection\',num2str(test_slice),'_pro.mat'];
    load(pro_name);
    proture=pro;
end
end

