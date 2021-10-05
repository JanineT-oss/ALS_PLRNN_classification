close all
clear all

%% paths
pati='/###/DYN/D_classification_';                                         %% add path Dyn classi results 
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% load results
file = '/RF_classifier_D.mat';
for i=1:5
    dum=num2str(i);
    pati_a= strcat(pati, dum)  
    filename=[pati_a file];
    load(filename);
    for j=1:5
        labs_kfold(i,j,:)=ClassifierRF(j).Importance.labs;
        Vi_kfold(i,j,:)=ClassifierRF(j).Importance.FI;
    end
end

Vi_mean = squeeze(mean(mean(Vi_kfold)));
labK = squeeze(labs_kfold(1,1,:));

[mVI I]=sort(Vi_mean, 'descend');
FivemostI = labK(I); FivemostI=FivemostI(1:5)

keyboard

%% create colored fig
h1=figure('color','white'); hold on; box on
fs=16; lw=2;
basevalue=-0.4;                                                            %baseline of background color
height=.015;                                                               %height of background color
ntot=length(labK);

colors=[.5 .5 .5];

mVI=squeeze(mean(mean(Vi_kfold))); 
[mVI I]=sort(mVI, 'descend');
VI_n=(Vi_kfold(:,:,I));
lab=labK(I,:);

labD=convertLab_Fig3B(lab, length(lab));

x=1;
k=zeros(1,5);
for j=1:length(labD) 
    for i=1:5
        scatter(k+x,VI_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(VI_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_n(:,:,j))), (std(mean(VI_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
   
    x=x+1;
end

xlim([.5 length(labD)+1]); ylim([-0.2 0.4]);
set(gca,'XTick',1:length(labD),'XTickLabel',labD,'FontSize',fs)
xtickangle(30)
ylabel('Importance','FontSize',fs);
set(h1,'Position',[200 200 800 285])
keyboard

filename=[pato 'Figure3B'];
saveas(gca, filename, 'svg');
