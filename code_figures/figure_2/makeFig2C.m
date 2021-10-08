
close all; 
clear all; clc

%% create figure 2C
%% janine.thome@zi-mannheim.de

%% path
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% fig set
fs=16; lw=2;
basevalue=0;                                                               %baseline of background color
height=.1;                                                                 %height of background color

%% load data
x=load('Vol_ALS_HC_Fig2C.mat');

vol_ALS=x.VOL_ALS;
vol_HC=x.VOL_HC;
lab=x.labs';
clear x

%keep only regional GMVs
ind=[1 2 3 4 5 6 7];

vol_ALS=vol_ALS(:,ind); 
vol_HC=vol_HC(:,ind); 
labs=lab(ind,:);

numfeatures=size(vol_ALS,2); 

%% sort feat
m_HC = mean(vol_HC);
[sc ind] = sort(m_HC, 'descend');
vol_HC = vol_HC(:,ind);
vol_ALS = vol_ALS(:,ind);
labs=labs(ind);
labs=convertLab_Fig2C(labs,length(labs));

%% create colored fig
h1=figure('color','white'); hold on; box on
ntot=numfeatures;

%% plot features
colHC=[0 0 0];
colALS=[ 252 141 89]/255;
colors=[.5 .5 .5];

t=1; r=0;
for j=6:6                                                                  % norm CSF 
   labj=labs(j)
   x=j; 

   y=vol_ALS(:,j); ind=isoutlier(y)|isnan(y); y(ind)=[]; 
   ALS=y;
   x=vol_HC(:,j); ind=isoutlier(x)|isnan(x); x(ind)=[];
   HC=x;
     
   p=ones(length(ALS),1)+r; 
   scatter(p,ALS,'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
   bar(t,mean(ALS),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
   errorbar(t,mean(ALS),std(ALS)./(sqrt(length(ALS))),'.','LineWidth',lw,'color','k');
   t=t+1; r=r+1;
   hold on
   
   p=ones(length(HC),1)+r; 
   scatter(p,HC,'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
   bar(t,mean(HC),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
   errorbar(t,mean(HC),std(HC)./(sqrt(length(HC))),'.','LineWidth',lw,'color','k');
   t=t+1; r=r+1;
   
   [h,p,~,stats]=ttest2(HC,ALS);
   pad=p*7;
   [stars, posi]=getStars(pad);
   text(1.5,mean(y)+.002,stars,'FontSize',fs);

end
xlim([.5 2+0.5]); ylim([-0.08 height])
set(gca,'XTick',[1,2],'XTickLabel',[{'ALS', 'HC'}],'FontSize',fs);
xtickangle(30)
ylabel('norm CSF','FontSize',fs);
set(h1,'Position',[200 200 250 190])

filename=[pato 'Figure2C'];
saveas(gca, filename, 'svg');
