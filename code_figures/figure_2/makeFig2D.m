
close all; 
clear all; clc

%% path
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% fig set
fs=16; lw=2;
basevalue=0;                                                               %baseline of background color


%% load data
x=load('Vol_ALS_HC_Fig2D.mat');

vol_ALS=x.VOL_ALS;
vol_HC=x.VOL_HC;
lab=x.labs';
clear x

%keep only regional GMVs
ind2=[8:19];

vol_ALS=vol_ALS(:,ind2); 
vol_HC=vol_HC(:,ind2); 
labs=lab(ind2,:);


%% plot features
colHC=[0 0 0];
colALS=[ 252 141 89]/255;
colors=[.5 .5 .5]; 

%% sort features
% DMN
DMN_ALS = vol_ALS(:,1:2);
DMN_HC = vol_HC(:,1:2); m_DMN_HC = mean(DMN_HC);
[sc ind] = sort(m_DMN_HC, 'descend');
DMN_HC = DMN_HC(:,ind);
DMN_ALS = DMN_ALS(:,ind);
lab_DMN = labs(1:2); lab_DMN = lab_DMN(ind);

% FPN
FPN_ALS = vol_ALS(:,3:6);
FPN_HC = vol_HC(:,3:6); m_FPN_HC = mean(FPN_HC);
[sc ind] = sort(m_FPN_HC, 'descend');
FPN_HC = FPN_HC(:,ind);
FPN_ALS = FPN_ALS(:,ind);
lab_FPN = labs(3:6); lab_FPN = lab_FPN(ind);

% SMN
SMN_ALS = vol_ALS(:,7:12);
SMN_HC = vol_HC(:,7:12); m_SMN_HC = mean(SMN_HC);
[sc ind] = sort(m_SMN_HC, 'descend');
SMN_HC = SMN_HC(:,ind);
SMN_ALS = SMN_ALS(:,ind);
lab_SMN = labs(7:12); lab_SMN = lab_SMN(ind);

% comb
vol_ALS = [DMN_ALS, FPN_ALS, SMN_ALS];
vol_HC = [DMN_HC, FPN_HC, SMN_HC];
labs = [lab_DMN; lab_FPN; lab_SMN];
keyboard

%% mPFC
h1=figure('color','white'); hold on; box on
t=1; r=0;
for j=1:1
    
   labj=labs(j)
   y=vol_ALS(:,j); ind=isoutlier(y)|isnan(y); y(ind)=[]; 
   ALS=y; 
   x=vol_HC(:,j); ind=isoutlier(x); x(ind)=[]; 
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
   
   mean(ALS)
   std(ALS)
   mean(HC)
   std(HC)
   keyboard
   
   [h,p,~,stats]=ttest2(HC,ALS)
   pad=p*12
   [stars, posi]=getStars(pad);
   text(j+.5,mean(y)+.002,stars,'FontSize',fs);
   keyboard
   
end
xlim([.5 2.5]); 
ylim([-0.0036 .0036]);
lab_DMN = convertLab_Fig2D(lab_DMN, length(lab_DMN));
set(gca,'XTick',[1,2],'XTickLabel',[{'ALS', 'HC'}],'FontSize',fs);
ylabel('GMV of mPFC','FontSize',fs);
xtickangle(30)
set(h1,'Position',[200 200 230 200])
keyboard
filename=[pato 'Figure2D'];
saveas(gca, filename, 'svg');

