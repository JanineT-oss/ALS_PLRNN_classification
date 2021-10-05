function [Mdl, C, Accuracy, Sens, Spec, FI, labs]=get_RF(dataTr,groupTr,dataTe,groupTe,lab,NumTrees,PredSample,Method,kf,path,Seed)

    %% hyperpar
    trees=NumTrees;
    pred=PredSample;

    %% prep table for RF
    T_resp = table(groupTr, 'VariableNames',{'group'}) ;
    T = table(groupTr, 'VariableNames',{'group'}) ;
    for i= 1: length(dataTr(1,:))
        dum =cellstr(lab(i)); 
        Tnew = table(dataTr(:,i), 'VariableNames',dum) ;
        T = [T Tnew];
    end
    T=T(:,[2:end]);
    
    %% RF
    rng(Seed) ;                                                            % for reproducabilty
    Mdl = TreeBagger(trees, T, T_resp, ...
                'SampleWithReplacement', 'On', ...
                'OOBPrediction', 'On',  ...
                'OOBPredictorImportance', 'On',...
                'Method', Method,...
                'NumPredictorsToSample',pred );

            %-----------Model Evaluation
            FI = Mdl.OOBPermutedPredictorDeltaError;                       % Variable Importance                                                                
            labs=Mdl.PredictorNames;
            
            pred = str2double(predict(Mdl, dataTe));                       % Predicting Testset
            C = confusionmat(groupTe,pred);                                % confusion matrix
  
            Accuracy  = ((C(1,1)./length(find(groupTe==0)))+(C(2,2)./length(find(groupTe==1))))./2;     %  balanced accuracy 
            Sens= C(2,2)./(C(2,1)+C(2,2));                                 % Sensitivity: True Positives/ (False Negatives + True Positives)
            Spec= C(1,1)./(C(1,2)+C(1,1));                                 % Specifitcy: True Negatives / (False Positives +True Negatives)
            %ERR =  ((C(1,2)./length(find(groupTe==0)))+(C(2,1)./length(find(groupTe==1))))./2;          %  balanced error          
            %PREC= C(2,2)./(C(1,2)+C(2,2));                                % Preciscion: True Positives / (False Positives + True Positives)
            %FPR = C(1,2)./(C(1,2)+C(1,1));                                % False Positive Rate: False Positives / (False Positives +True Negatives)
       
            
            %-----------Fig 1 confusion matrix
            figure 
            confusionchart(groupTe,pred);
            titprep=num2str(kf); titprep=strcat('kfold_', titprep);
            title(titprep)
            filename = strcat('Confusionmatrix_', titprep) 
            saveas(gca,[path filename '.svg']) 
            
            %-----------Fig 2 OOB classification error
            figure;
            oobErrorBaggedEnsemble = oobError(Mdl);
            plot(oobErrorBaggedEnsemble);
            titprep=num2str(kf); titprep=strcat('k-fold_', titprep);
            title(titprep)
            xlabel 'Number of grown trees';
            ylabel 'Out-of-bag classification error';
            filename = strcat('OOBclasserrorTrees_', titprep) 
            saveas(gca, [path filename '.svg']) 
     
            
            %-----------Fig 3 Feautre Importance
            figure;
            [FI_sort,sortIdx] = sort(FI,'descend');
            bar(FI_sort(1:10));
            titprep=num2str(kf); titprep=strcat('k-fold_', titprep, '_10_most_importantF');
            title(titprep);
            ylabel('importance estimates');
            xlabel('features');
            h = gca;
            xticks(1:length(dataTr(1,:)));
            labs_sort=labs(sortIdx);
            h.XTickLabel = labs_sort(1:10);
            h.XTickLabelRotation = 45;
            filename = strcat('FI_', titprep) 
            saveas(gca,[path filename '.svg'])   
          
end