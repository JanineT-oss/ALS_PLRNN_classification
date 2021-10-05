function [SVM, Acc_SVM, Sens_SVM, Spec_SVM, labs_SVM, corr_SVM, corr_SVM_F]=get_svm_jt(groupTrain,groupTest,datTrain,datTest,lab,kernel,Seed,kf,ztransfo)
    
    Xtr = datTrain;
    Xte = datTest;
    Ytr = groupTrain;
    Yte = groupTest;
    
     if ztransfo == 1
          Xtr=(Xtr-mean(Xtr))./std(Xtr); 
          Xte=(Xte-mean(Xtr))./std(Xtr); 
     elseif ztransfo == 0
          Xtr= Xtr;
     end
    
    labs_SVM = lab;
    
        rng(Seed) ;
        if kernel == 1
            SVM = fitcsvm(Xtr,Ytr,'KernelFunction','linear');              % 'KernelScale': 1 (default) | 'auto' | positive scalar; 'Solver': 'ISDA' | 'L1QP' | 'SMO' 
        elseif kernel == 2
            SVM = fitcsvm(Xtr,Ytr,'KernelFunction','Polynomial'); 
        end  
        
        %% Model Evaluation
        SVM_c=predict(SVM,Xte);                                            % test
        corr_SVM=sum(SVM_c==Yte)/length(Yte);                              % correct on left out set
        txt=sprintf('SVM: RCE=%2.2f',1-corr_SVM); 
        disp(txt);
        
        C = confusionmat(Yte,SVM_c);                                       % confusion matrix
  
        Acc_SVM  = ((C(1,1)./length(find(Yte==0)))+(C(2,2)./length(find(Yte==1))))./2; %  balanced accuracy 
        Sens_SVM= C(2,2)./(C(2,1)+C(2,2));                                 % Sensitivity: True Positives/ (False Negatives + True Positives)
        Spec_SVM= C(1,1)./(C(1,2)+C(1,1));                                 % Specifitcy: True Negatives / (False Positives +True Negatives)
                 
        %check removing different features
         nfeat=size(Xtr,2);
         for i=1:nfeat
                feat1=Xtr; feat1(:,i)=[]; 
                feat1_te=Xte;feat1_te(:,i)=[];
                if kernel == 1
                    SVM = fitcsvm(feat1,Ytr,'Standardize',true, 'KernelFunction','linear');
                elseif kernel == 2
                    SVM = fitcsvm(feat1,Ytr,'Standardize',true, 'KernelFunction','Polynomial');
                end
                SVM_c=predict(SVM,feat1_te);                               % test
                corr_SVM_F(i)=(sum(SVM_c==Yte)/length(Yte))*100;
                txt=sprintf('SVM: RCE=%2.2f', 1-corr_SVM_F); 
                %disp(txt);
         end
          [val,ind]=sort(corr_SVM_F,'descend');
          vallabs=lab(ind);
end


