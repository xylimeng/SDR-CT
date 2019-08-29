function [directnew] = SDR_algorithm(globalstruct,SDR_param,pro_direction)
if SDR_param.TVresidual==-1
    fprintf('Stop rule is max iteration')
else
    fprintf('Stop rule is res=norm(Ax-b)^2/norm(b)^2 less than %g.\n',SDR_param.TVresidual);

end
warning off;

resolution=globalstruct.resolution;
thetaresolution=globalstruct.thetaresolution;
len_width=globalstruct.len_width;
loc_width=globalstruct.loc_width;
nol=resolution*180/thetaresolution;
top=SDR_param.top;
bottom=SDR_param.bottom;


[sparseA] = lenloc2sparse(len_width,loc_width,resolution,thetaresolution,1);
warning off;
Xs=sparseA;
mkdir('Result');
cd('./Result');
mkdir('RESULT1');
mkdir('RESULT2');
cd('./RESULT1')
delete('*.mat');
cd('../RESULT2')
delete('*.mat');
cd('../../')

% top shouldn't be 1,calculate diff
top=max(2,top);
for ijk=top:1:bottom
    cd('.\projection_data\noisy_projection')
    num=ijk;
    num_up=ijk-1; 
    load([num2str(num),'_pro','.mat']);
    prodown=pro;
    load([num2str(num_up),'_pro','.mat']);
    proup=pro;
    for ii=1:1:180/thetaresolution
        for jj=1:1:resolution
            if proup(ii,jj)==0 || prodown(ii,jj)==0
                b((ii-1)*resolution+jj)=0;
            else
                b((ii-1)*resolution+jj)=proup(ii,jj)-prodown(ii,jj);
            end
        end
    end
    cd('..\..\glmnet\glmnet_matlab') 
    opt.lambda=0.02;
    opt.nlambda=1;
    options=glmnetSet(opt);
    fit1=glmnet(Xs,b', 'gaussian',options);
    Fq_diff=fit1.beta;
    finverse_diff=zeros(resolution,resolution);
    for ii=1:1:resolution
      for jj=1:1:resolution
         ind=(ii-1)*resolution+jj;
         finverse_diff(ii,jj)=Fq_diff(ind);
      end
    end
    cd('..\..\')
    cd('.\Result\DIFF_ESTIM');
    save(['diff_',num2str(num_up),'_',num2str(num),'.mat'],'finverse_diff','Fq_diff');   
    cd('..\..\')
end
for iteration=1:1:SDR_param.OutmaxIte
    fprintf('iteration was calculating: %g/%g \n',iteration,SDR_param.OutmaxIte);
    if iteration/2~=floor(iteration/2)
        directold='.\Result\RESULT2';
        directnew='.\Result\RESULT1';
    else
        directold='.\Result\RESULT1';
        directnew='.\Result\RESULT2';
    end
    for ijk=top:1:bottom %'J:\Git'
        %AF1=squeeze(ph(:,:,ijk));
        cd(pro_direction);
        load([num2str(ijk),'_pro','.mat']);
        cd('..\..\')
        cd(directold);
        try
            load([num2str(ijk),'_result','.mat']);
            Fq_initial=finverse;
        catch
            Fq_initial=zeros(resolution,resolution);
        end
        cd('..\..\')
        finverse_TVART = TVART_algorithm(Fq_initial,pro,globalstruct,SDR_param);
        cd(directold);
        finverse=finverse_TVART;
        save(['result_',num2str(ijk),'.mat'],'finverse');
        cd('..\..\')
    end
    for ijk=top:1:bottom
        fprintf('slice %g for iteration %g was calculating \n',iteration,iteration);
        num=ijk;
        numup=ijk-1;
        numdown=ijk+1;
        cd(directold);
        load(['result_',num2str(num),'.mat']);
        fmid=finverse;
        if ijk==top
            load(['result_',num2str(numdown),'.mat']);
            fdown=finverse;
            cd('../DIFF_ESTIM')
            load(['diff_',num2str(num),'_',num2str(numdown),'.mat']);
            fdiff_down=finverse_diff;
            finalf=fmid+fdown+fdiff_down;
            finalf=finalf/2; 
        elseif ijk==bottom
            load(['result_',num2str(numup),'.mat']);
            fup=finverse;
            cd('../DIFF_ESTIM')
            load(['diff_',num2str(numup),'_',num2str(num),'.mat']);
            fdiff_up=finverse_diff;
            finalf=fmid+fup-fdiff_up;
            finalf=finalf/2;
        else
            load(['result_',num2str(numup),'.mat']);
            fup=finverse;
            load(['result_',num2str(numdown),'.mat']);
            fdown=finverse;
            cd('../DIFF_ESTIM')
            load(['diff_',num2str(numup),'_',num2str(num),'.mat']);
            fdiff_up=finverse_diff;
            load(['diff_',num2str(num),'_',num2str(numdown),'.mat']);
            fdiff_down=finverse_diff;
            finalf=fmid+fup+fdown-fdiff_up+fdiff_down;
            finalf=finalf/3;
        end
        cd('../../')
        cd(directnew);
        finverse=finalf;
        save(['result_',num2str(ijk),'.mat'],'finverse');
        cd('../../')
    end
end
directnew=directnew;
end

