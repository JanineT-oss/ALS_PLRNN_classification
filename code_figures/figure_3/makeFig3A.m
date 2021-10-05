close all
clear all

%% Make Figure 3B

%% paths
pati='/###/DYN/D_classification_';                                         %% add path Dyn classi results 
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% load
file = '/RF_classifier_D.mat';
for i=1:5
    dum=num2str(i);
    pati_a= strcat(pati, dum)  
    filename=[pati_a file];
    load(filename);
    for j=1:5;
        Acc(i,j)=ClassifierRF(j).Performance.Acc;
        Sens(i,j)=ClassifierRF(j).Performance.Sens;
        Spec(i,j)=ClassifierRF(j).Performance.Spec;
    end
end

%% plot Balanced Accuracy
% create colored fig
h1=figure('color','white'); hold on; box on
fs=16; lw=2; 

colors=[.5 .5 .5];
ylabel('%','FontSize',fs);

Acc=Acc*100;
Sens=Sens*100;
Spec=Spec*100;

x=3;
k=[1, 1, 1, 1, 1,2,2,2,2,2,3,3,3,3,3];
k=jitter(k, [], 0.5, 0.5);


for i=1:5
    scatter(k(1:5),Acc(i,:),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
end
bar(x-2,mean(mean(Acc,2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
errorbar(x-2,mean(mean(Acc,2)), (std(mean(Acc,2)))./sqrt(5),'.','LineWidth',lw,'color','k');


for i=1:5
    scatter(k(6:10),Sens(i,:),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
end
bar(x-1,mean(mean(Sens,2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
errorbar(x-1,mean(mean(Sens,2)), (std(mean(Sens,2)))./sqrt(5),'.','LineWidth',lw,'color','k');


for i=1:5
    scatter(k(11:15),Spec(i,:),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
end
bar(x,mean(mean(Spec,2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
errorbar(x,mean(mean(Spec,2)), (std(mean(Spec,2)))./sqrt(5),'.','LineWidth',lw,'color','k');


xlim([0.5 3.5]);
ylim([0 100]);
labs={'Accuracy','Sensitivity','Specificity'}
set(gca,'XTick',1:3,'XTickLabel',labs,'FontSize',fs);
xtickangle(30);
set(h1,'Position',[200 200 200 250])

filename=[pato 'Figure3A'];
saveas(gca, filename, 'svg');

