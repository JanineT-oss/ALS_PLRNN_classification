
%% create figure 2H
%% janine.thome@zi-mannheim.de


%% paths 
clear all; close all
addpath([pwd '/circularGraph/'])

%% load data
x=load('FC_ALS_HC_Fig2H.mat');

cols=[213 62 79; 154 213 148; 50 136 189]/255;                             %background colors
col1=cols(1,:); col2=cols(2,:); col3=cols(3,:);

nvp1=size(x.xg1,1); 
nvp2=size(x.xg2,1);
for i=1:nvp1
    xg1(:,:,i)=x.xg1(i,:,:);
end
for i=1:nvp2
    xg2(:,:,i)=x.xg2(i,:,:);
end
nfeat=size(xg1,1);

myLabel=x.lab;
myLabel=convertLab_Fig2H(myLabel,nfeat);

myLabel={'PCCb','mPFCb','IPCr','SFGl','SFGr','SPCl',...
    'Cereb','PrePostcl','PrePostcr','SMAb','Thall','Thalr'};
clear x

%% plot significant group differences, seperate for pos and neg. corr
clear x xpos* xneg*
x=nanmean(xg1,3);                                                          %mean along 3rd dim 
xposALS=x.*(x>0);                                                          %positive corr vals first 
xnegALS=abs(x.*(x<0));                                                     %positive corr vals first 

x=nanmean(xg2,3);                                                          %mean along 3rd dim 
xposHC=x.*(x>0);                                                           %positive corr vals first 
xnegHC=abs(x.*(x<0));                                                      %positive corr vals first

%now keep only significant connections
thresh=.05/(12*12-12);                                                     %p-value
[nrow,ncol,~]=size(xg1);
sigMtx=zeros(nrow,ncol);
for i=1:nrow                                                               %move across columns for each row
    myLabel(i)
    for j=1:ncol
         myLabel(j)
        ALS=squeeze(xg1(i,j,:));
        HC=squeeze(xg2(i,j,:));
        ind=isnan(ALS); ALS(ind)=[]; sum(ind); a1=isoutlier(ALS); ALS=ALS(a1==0);
        ind=isnan(HC); HC(ind)=[]; sum(ind); a2=isoutlier(HC); HC=HC(a2==0);
        [~,p,~,STATS]=ttest2(ALS,HC)
        
        if p<thresh, sigMtx(i,j)=1; 
        pMtx(i,j)=(p*(12*12-12));
        padj =pMtx(i,j)
        tMtx(i,j)=STATS.tstat;
        dfMtx(i,j)=STATS.df;
        %keyboard
        end
    end
end

h1=figure; hold on;
fs=16; 

x=xposHC-xposALS;
xpos=x.*(x>0);                                                             %greater positive corr in HC 
xneg=abs(x.*(x<0));                                                        %greater positive corr in ALS 
xpos=xpos.*(sigMtx>0);  xpos=xpos>0;                                       %filter significances at thresh and set all to 1
xneg=xneg.*(sigMtx>0);  xneg=xneg>0;                                       %filter significances at thresh

subplot(1,2,1); hold on
myColorMap = repmat(cols(1,:),nfeat,1);                                    %colormap (used sequentially as the lines are drawn)
circularGraph(xpos,'Colormap',myColorMap,'Label',myLabel);

subplot(1,2,1); hold on
myColorMap = repmat(cols(2,:),nfeat,1);                                    %colormap
circularGraph(xneg,'Colormap',myColorMap,'Label',myLabel);

clear x xpos xneg xposALS xposHC
x=xnegHC-xnegALS;
xpos=x.*(x>0);                                                             %greater neg. corr in HC
xneg=abs(x.*(x<0));                                                        %greater neg. corr in ALS
xpos=xpos.*(sigMtx>0);  xpos=xpos>0;                                       %filter significances at thresh and set all to 1
xneg=xneg.*(sigMtx>0);  xneg=xneg>0;                                       %filter significances at thresh

subplot(1,2,2); hold on
myColorMap = repmat(cols(1,:),nfeat,1);                                    %colormap
circularGraph(xpos,'Colormap',myColorMap,'Label',myLabel);

subplot(1,2,2); hold on
myColorMap = repmat(cols(2,:),nfeat,1);                                    %colormap
circularGraph(xneg,'Colormap',myColorMap,'Label',myLabel);

set(gca,'FontSize',fs)

