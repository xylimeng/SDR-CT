function [finverse_TVART] = TVART_algorithm(Fq_initial,pro,globalstruct,SDR_param)

resolution=globalstruct.resolution;
thetaresolution=globalstruct.thetaresolution;
len=globalstruct.len_width;
loc=globalstruct.loc_width;
residual=SDR_param.TVresidual;
maxIte=SDR_param.TVmaxIte;
SHUF=SDR_param.TVSHUF;
nol=resolution*180/thetaresolution;

try
    finverse_TVART=Fq_initial;
catch
    finverse_TVART=zeros(resolution,resolution);  
end
dev=zeros(resolution,resolution);
for i=1:1:resolution
    for j=1:1:resolution
        ind=(i-1)*resolution+j;
        Fq_TVART(ind)=Fq_initial(i,j);  
    end
end
    
if residual>=0
    maxIte=10000;
end

pdfweight=zeros(nol,1);
for i=1:1:180/thetaresolution
    for j=1:1:resolution
        pdfweight((i-1)*resolution+j,1)=sum(len(i,j,:).^2);
    end
end
former=zeros(resolution,resolution);
formerdev=zeros(resolution,resolution);
count=0;
for ite_times=1:1:maxIte
    try 
        former=finverse_TVART;
        formerdev=dev;
    catch
        former=zeros(resolution,resolution);
        formerdev=zeros(resolution,resolution);
    end
    shuf=[];
    for j=1:1:resolution*180/thetaresolution
        shuf=[shuf,j];
    end
    for j=1:1:1*resolution*180/thetaresolution
        w=1;
        count=count+1;
        ajf=0;
        i=1;
        number=1;
        iter=mod(shuf(j)-1,nol)+1;
        numoftheta=mod((floor((iter-0.1)/resolution)+1),180/thetaresolution)+1;
        numofdist=iter-floor((iter-0.1)/resolution)*resolution;
        if pro(numoftheta,numofdist)==0
            continue
        end
        i=loc(numoftheta,numofdist,number);
        while i>0 %&& len(numoftheta,numofdist,number)~=0
                ajf=ajf+len(numoftheta,numofdist,number)*Fq_TVART(i);%%%%%%%%%%%%%%%%%%%%
                number=number+1;
                i=loc(numoftheta,numofdist,number);
        end
        i=1;
        number=1;
        i=loc(numoftheta,numofdist,number);
        ajs=pdfweight(resolution*(numoftheta-1)+numofdist);
        while i>0 && pro(numoftheta,numofdist)~=0
            ai=len(numoftheta,numofdist,number);
            i=loc(numoftheta,numofdist,number);
            Fq_TVART(i)=Fq_TVART(i) + w*(pro(numoftheta,numofdist)-ajf)*ai/ajs;
            number=number + 1;
            i=loc(numoftheta,numofdist,number);
        end      
    end
        finverse_TVART=zeros(resolution,resolution);  

        for i=1:1:resolution
            for j=1:1:resolution
                ind=(i-1)*resolution+j;
                finverse_TVART(i,j)=max(Fq_TVART(ind),0);
            end
        end 
        f_right=zeros(resolution,resolution);
        left_f=zeros(resolution,resolution);
        f_down=zeros(resolution,resolution);
        up_f=zeros(resolution,resolution);
        f_down(1:resolution-1,:)=finverse_TVART(1:resolution-1,:)-finverse_TVART(2:resolution,:);
        up_f(2:resolution,:)=finverse_TVART(1:resolution-1,:)-finverse_TVART(2:resolution,:);
        f_right(:,1:resolution-1)=finverse_TVART(:,1:resolution-1)-finverse_TVART(:,2:resolution);
        left_f(:,2:resolution)=finverse_TVART(:,1:resolution-1)-finverse_TVART(:,2:resolution);    
        f_right_down_2=sqrt(f_right.^2+f_down.^2);
        dev=(-left_f-up_f)./max(f_right_down_2,0.1);
        dev=dev+f_right./max([zeros(resolution,1),f_right_down_2(:,1:resolution-1)],0.1);
        dev=dev+f_down./max([zeros(1,resolution);f_right_down_2(1:resolution-1,:)],0.1);
        BB_step=sum(sum((finverse_TVART-former).^2))/max(sum(sum((finverse_TVART-former).*(dev-formerdev))));
        BB_step=min(BB_step,0.1);
        finverse_TVART=finverse_TVART-1*BB_step*dev/norm(dev);
% % Fq_TVSART=reshape(finverse_TVSART',1,resolution*resolution);
        %Dist=zeros(resolution,resolution);
        for i=1:1:resolution
            for j=1:1:resolution
                ind=(i-1)*resolution+j;
                Fq_TVART(ind)=finverse_TVART(i,j);
            end
        end
    



%     [ite_times,norm(AF1-finverse_TVART),norm(f_right_down_2)]   
if residual>=0
    MM=sparseA*Fq_TVART;
    K=reshape(MM,resolution,180/thetaresolution)';
    dis=reshape(K-pro,resolution*180/thetaresolution,1);
    proline=reshape(pro,resolution*180/thetaresolution,1);
    res=norm(dis)^2/norm(proline)^2;
    if res<=residual
        fprintf('residual=%g',res);
        break
    end
end


end

end

