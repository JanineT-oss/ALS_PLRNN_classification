function [ind1,ind2,ind3]=get_subsample(data,N,group, groupN,groupInd,Seed)
        
        test=rng(Seed) 
        
        sizeG=floor(length(find(group==groupInd))./N);
        dum1=find(group(:,1)==groupN(1));                                  % HC
        dum2=find(group(:,1)==groupN(2));                                  % ALS
        for i=1:N
            
            ind1(:,i) = datasample(dum1,sizeG,'Replace',false);            % Index HC per fold
            h=ismember(dum1,ind1);
            dum1(h==1)=[];
            
            ind2(:,i) = datasample(dum2,sizeG,'Replace',false);            % Index ALS per fold   
            h=ismember(dum2,ind2);
            dum2(h==1)=[];
        end
        
        ind3=sort([dum1;dum2],'ascend');                                   % nicht zugeteilte VPs
%keyboard
end