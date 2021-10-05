clear all; close all; clc

%%%% janine.thome@zi-mannheim.de
%% RF classifier reported in "Classification of amyotrophic lateral sclerosis by brain volume, connectivity, and network dynamics" (HBM)


%% SPECIFY:
groupN = [0,1];                                                            % group coding
groupL = ["Controls", "ALS"];                                              % group labels      
GroupInd = 2;                                                              % column with group info

Kn = 5;                                                                    % # k-folds              
groupInd=0;                                                                % indicating index group (smaller N) for balancing out fold
ztransfo = 1;                                                              % 1 = z transfo features
n_nans=10;                                                                 % # missing values "allowed"

repro = 1;                                                                 % 1 = if reproducing classifier
NumTrees=5000;                                                             % # trees RF
Method='classification';                                                   % method RF
kernel = 2;                                                                % SVM: 1 = linear, 2 = polynominal

for repe = 1 : 5
    
    %% paths
    pati='/###/';                                                          % add path containing excel "ALS_ALL_DATA_ALL_FCDYN.xlsx"                                                                     
    dum = num2str(repe);
    pato = strcat('/###/Bimodal_FCDYN/Bimodal_FCDYN_classification_', dum , '/');% add output path for a new classifier OR if you want to reproduce classifier reported in the publication, point path to the respective classifier
    if ~isdir(pato), mkdir(pato); end


    %% reproduce classifier?
    if repro == 1

        file = 'RF_classifier_2FOLD_FCDYN.mat'; filename=[pato file]; load(filename); 
        Seed = ClassifierRF.RandomSeed;
        clear Classifier

        dum = num2str(repe);
        patoR = strcat('/###/Bimodal_FCDYN_repli/FCDYN_', dum , '/');      % add output path where you want to store the replicated classifier in
        if ~isdir(patoR), mkdir(patoR); end
    
    else 
        numbSeeds = ceil(normrnd(50,10))
        Seed=rng(numbSeeds)
        disp('new classifier')
    end

    %% load data 
    file_T = 'ALS_ALL_DATA_ALL_FCDYN.xlsx';
    filename=[pati file_T];
    tbl = readtable(filename);

    %% get data
    dataN(:,3) = str2double(table2array(tbl(:,3)));
    dataN(:,4:width(tbl))= table2array(tbl(:,4:width(tbl)));
    labels = string(tbl.Properties.VariableNames(3:end));                      

    data=dataN(:,3:end);
    group=data(:,1);
    code = table2cell(tbl(:,1)); 

    clear dataN

    %% exclude VPs with more than 10 nan entries 
    k=strfind(labels,'D_'); idx=(cellfun('isempty', k));                                                                                      
    tmp=isnan(data(:,find(idx==0)));                   
    outlier= find(sum(tmp')>n_nans);
    code(outlier)
    %keyboard

    data(outlier,:)=[];
    group(outlier,:)=[];
    code(outlier)=[];

    nvps=size(data,1);
    clear idx

    %% Classification (RF)
     dat= data(:,28:end); lab = labels(28:end);                            
     find(isnan(dat))
     whos dat 
     whos lab
     find(isnan(dat))
     %keyboard

        %% build k-folds     
        [indO1,indO2,indO3]=get_subsample(data, Kn, group, groupN, groupInd, Seed); % stratified: equal # ALS/HC in each fold, ind01: G1, ind02: G2, ind03: remaining subjects 

        %% run RF-CV
        for kf = 1:Kn                                                      

               %% get folds
               % get k-fold testsample
               idxTest = sort([indO1(:,kf);indO2(:,kf);indO3]);            % inds testfold 
               datTest = dat(idxTest,:); 
               groupTest = group(idxTest,:);                            

               % get k-folds trainingsammple
               indG1 = indO1; 
               indG1(:,kf) = [];                                           % inds trainingsfolds G1 without testfold
               indG2 = indO2;
               indG2(:,kf) = [];                                           % inds trainingsfolds G2 without testfold
               idxTrain =([indG1;indG2]); idxTrain = idxTrain(:);                                     
               datTrain = dat(idxTrain,:); 
               groupTrain = group(idxTrain,:);

               %% check training/testsample
               for i=1: length(dat(:,1))
                   dum = find((ismember(idxTest, i))==1);
                   dum2 = find((ismember(idxTrain, i))==1);
                   if dum > 0 TestC(i) = 1; else TestC(i) = 0; end
                   if dum2 > 0 TrainC(i) = 0.9; else TrainC(i) = 0; end
               end
               figure
               bar(TrainC, 'EdgeColor', 'k', 'FaceColor', 'r'); hold on
               bar(TestC, 'EdgeColor', 'k', 'FaceColor', 'w')
               xlim([-0.5 157]); ylim([0 1.1]); legend('train', 'test');
               set(gca,'YTick',[], 'XTick',[1:157]); xlabel('Cases'); xtickangle(45);

               disp('check that test and train sample do not overlap')
               %keyboard
               titprep=num2str(kf); titprep=strcat('k-fold_', titprep);
               filename = strcat('SampleCheck_', titprep) 
               if repro == 0
                  saveas(gca, [pato filename '.svg']) 
               elseif repro == 1
                  saveas(gca, [patoR filename '.svg']) 
               end
               %% run RF on training and test set according to k-fold CV  
               PredSample=floor(sqrt(length(datTrain(1,:))));              % vars per split (default)            
               
               if repro == 0
                  [Mdl, CM, Accuracy, Sens, Spec, FI, labs]=get_RF(datTrain,groupTrain,datTest,groupTest,lab,NumTrees,PredSample,Method,kf,pato,Seed);
               elseif repro == 1
                  [Mdl, CM, Accuracy, Sens, Spec, FI, labs]=get_RF(datTrain,groupTrain,datTest,groupTest,lab,NumTrees,PredSample,Method,kf,patoR,Seed);
               end
               
               %% store 
               %Performance
               ClassifierRF(kf).Performance.CM = CM;
               ClassifierRF(kf).Performance.Acc = Accuracy;
               ClassifierRF(kf).Performance.Sens = Sens;
               ClassifierRF(kf).Performance.Spec = Spec;
               % Pred importance
               ClassifierRF(kf).Importance.FI = FI;
               ClassifierRF(kf).Importance.labs = labs;
               % Classifier
               ClassifierRF(kf).Mdl = Mdl;
               
               
               %% run SVM on training and test set according to k-fold CV  
               [SVM, Acc_SVM, Sens_SVM, Spec_SVM, labs_SVM]=get_svm(groupTrain,groupTest,datTrain,datTest,lab,kernel,Seed,kf,ztransfo);
               
               %% store 
               %Performance
               ClassifierSVM(kf).Performance.Acc = Acc_SVM;
               ClassifierSVM(kf).Performance.Sens = Sens_SVM;
               ClassifierSVM(kf).Performance.Spec = Spec_SVM;
               % Pred importance
               ClassifierSVM(kf).Importance.labs = labs_SVM;
               % Classifier
               ClassifierSVM(kf).Mdl = SVM;
               
               %keyboard
               close all

                end
    

    %% store 
    %hyperparameter
    ClassifierRF(1).Hyperpar.Trees = NumTrees;
    ClassifierRF(1).Hyperpar.PredSplit = PredSample;
    %Seed
    ClassifierRF(1).RandomSeed = Seed;
    if repro == 0   
        ClassifierRF(1).RandomSeedNumb = numbSeeds;
    elseif repro == 1
    end
    %Kfolds
    ClassifierRF(1).Indices_folds.G1 = indO1;
    ClassifierRF(1).Indices_folds.G2 = indO2;
    ClassifierRF(1).Indices_folds.Rest_alwaysadded2test = indO3;
    
    %hyperparameter
    ClassifierSVM(1).Hyperpar.kernel = kernel;
    %Seed
    ClassifierSVM(1).RandomSeed = Seed;
    if repro == 0
        ClassifierSVM(1).RandomSeedNumb = numbSeeds;
    elseif repro == 1
    end
    %Kfolds
    ClassifierSVM(1).Indices_folds.G1 = indO1;
    ClassifierSVM(1).Indices_folds.G2 = indO2;
    ClassifierSVM(1).Indices_folds.Rest_alwaysadded2test = indO3;
    
    %Classifier
    if repro == 0
        filename = [pato 'RF_classifier_2FOLD_FCDYN.mat'];
        save(filename, 'ClassifierRF', 'ClassifierSVM');
    elseif repro == 1
        filename = [patoR 'RF_classifier_2FOLD_FCDYN.mat'];
        save(filename, 'ClassifierRF', 'ClassifierSVM');
    end

end
