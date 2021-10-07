function HBM_ALS_get_features_rsDyn()
%get dynamics features from PLRNN of the form
    %z_t=A*z_{t-1} + W*max(0,z_{t-1}) + h + noise

%please note that this code will not run on its own and is only intended to
%provide the reader with a precise definition of the input features,
%data files and additional functions are needed to run,
%for further details please contact janine.thome@zi-mannheim.de or
%georgia.koppe@zi-mannheim.de
 
%set directories
startpath='/xxx/';
addpath([startpath 'xxxx/']); %PLRNN class
addpath([startpath 'xxxx/']); %necessary subfunctions

pati='/xxxx/';                %data input path

% feature labels
featurelabels={'FD1_#FPs','FD2_#unstableFPs','FD4_1-max|eig|','FD3_meanIm',...
    'FD5_var(A+W)','FD7_var(A+W)_nr','FD6_var(A+W)_r','FD9_mean(|h|)_nr','FD8_mean(|h|)_r',...
    'FD10_#cycles', 'FD12_mean(W)_nr','FD11_mean(W)_r', 'FD14_eucl dist',...
    'FD15_state var', 'FD17_mean(B)','FD18_var(B)','FD16_var(d)','FD13_|WD|'};

%select features from featurelabels
selectedFeat=[1:length(featurelabels)]; %set to all
featlabs=featurelabels(selectedFeat);

%select PLRNN files
p='8';
str=['*_resting_*Z' p '*1000*.mat'];
files=dir([pati str]);
nfiles=size(files,1);

nfeat=length(featlabs);
features=nan(nfiles,nfeat);
warning off 

%loop over different subjects
for k=1:nfiles
    
    %load PLRNNs
    file=files(k).name;
    filename=file(1:end-4);
    disp(filename)
    dat=load([pati file]);
    
    %assign group
    if strcmp(file(17:18),'AL')
        g(k)=1;
    elseif strcmp(file(17:18),'HC')
        g(k)=0;
    end
    
    %load PLRNN object and regularization info
    net=dat.net;
    W=net.W;
    A=net.A;
    h=net.h;
    B=net.B;
    reg=dat.net.reg.Lreg;
    M=size(A,1);
    regA=reg(:,1:M); regA=regA(:,1);
    regW=reg(:,M+1:2*M);
    regh=reg(:,2*M+1);
    Ezi=dat.Ezi;
    
    %% collect features
    ifeat=0;
    
    %fixed points and eigenvalues around fixed points: z*=f(z*)
    [zs,ev]=AllFP_PLRNN(A,W,h);
    nfp=length(zs);
    if nfp==1 && isempty(zs{1})
        nfp=0;
    end
    nstab=0; maxev=[]; maxim=[]; nrepell=0;
    
    try
        for i=1:nfp
            evi=ev{i};
            maxev(i)=max(abs(evi));
            if maxev(i)<1
                nstab=nstab+1;
            end
            maxim(i)=max(abs(imag(evi)));
            if sum(evi>1)==length(evi)
                nrepell=nrepell+1;
            end
        end
        nstableFPs=nstab;
        nunstableFPs=nfp-nstableFPs; %may add repeller
    end
    
    % FD1: # of  FPS
    if ismember(1,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=nfp; end
    end
    % FD2: # of unstable FPs
    if ismember(2,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=nunstableFPs; end
    end
    % FD4: mean of maximum absolute (real) eigenvalues of all FPs
    if ismember(3,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(1-maxev); end
    end
    % FD3: mean of absolute imaginary eigenvalues of all FPs
    if ismember(4,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(maxim); end
    end  
    % FD5: variance of pars = complexity
    AW=A+W;
    if ismember(5,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=var(AW(:)); end
    end   
    % FD7: variance of non regularized pars
    AWnr=AW(regW==0);
    if ismember(6,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=var(AWnr); end
    end   
    % FD6: variance of regularized pars (time scales)
    AWr=AW(regW==1);
    if ismember(7,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=var(AWr); end
    end   
    % FD9: mean of non-regularized bias
    if ismember(8,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(abs(h(regh==0))); end
    end   
    % FD8: mean of regularized bias
    if ismember(9,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(abs(h(regh==1))); end
    end
    % FD10: n stable cycles
    if ismember(10,selectedFeat)
        T=2000; ninits=1000;
        nstableCycles=getDynObjects(net,T,ninits);
        ifeat=ifeat+1;
        try features(k,ifeat)=nstableCycles; end
    end
    % FD12: mean of non-regularized wij
    Ws=sum(W')';
    if ismember(11,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(Ws(reg(:,end)==0)); end
    end
    % FD11: mean of regularized wij
    if ismember(12,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(Ws(reg(:,end)==1)); end
    end
    % FD14: Euclidean distance of states
    if ismember(13,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(sqrt(sum((diff(Ezi)).^2))); end
    end
    % FD15: variance in states
    if ismember(14,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)= mean(var(Ezi')); end
    end
    % FD17: mean of B
    if ismember(15,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(mean(B)); end
    end
    % FD18: variance in B
    if ismember(16,selectedFeat)
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(var(B)); end
    end
    % FD16: variance in d
    if ismember(17,selectedFeat)
        d=Ezi>0;
        ifeat=ifeat+1;
        try features(k,ifeat)=mean(var(d')); end
    end
    % FD13: magnitude of connectivity matrix across trajectory
    if ismember(18,selectedFeat)
        d=Ezi>0;
        for t=1:size(d,2)
            D=repmat(d(:,t),1,M);
            WD(:,:,t)=W.*(D');
        end
        ifeat=ifeat+1;
        tmp=nanmean(WD,3);
        try features(k,ifeat)=mean(abs(sum(tmp'))); end
    end
    
    clearvars -except feat* files* k nfiles pati selectedFeat g vpn
end

save('ALS_dyn_features_z8.mat','features','g','featlabs')
keyboard
filename='ALS_dyn_features_z8.xls';
flabs{1}='vpn'; flabs{2}='group';
for i=1:length(featlabs)
    flabs{i+2}=featlabs{i};
end
dat=[g' features];
celltab=[flabs; vpn' num2cell(dat)];
writetable(cell2table(celltab),filename,'writevariablenames',0)

