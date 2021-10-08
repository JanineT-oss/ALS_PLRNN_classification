close all
clear all

%% create figure 4A_B_C
%% janine.thome@zi-mannheim.de

%% paths
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% load
file = 'Multim_Performance.mat';
load(file)

%% plot Balanced Accuracy
% create colored fig
h1=figure('color','white'); hold on; box on
fs=16; lw=2; 

colors=[.5 .5 .5];
ylabel('%','FontSize',fs);

x = 1; b = 1; 
p=[1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4]; p=jitter(p, [], 0.5, 0.5);
for m = 1 : 4
    Acc_n=squeeze(Acc(m,:,:)*100);

    for i=1:5
        scatter(p(b:b+4),Acc_n(i,:),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(Acc_n,2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(Acc_n,2)), (std(mean(Acc_n,2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1; b=b+5;
    
end

xlim([0.5 4.5]);
ylim([0 100]);
labs={'Three-fold','VOL & rsFC','VOL & rsDYN','rsFC & rsDYN'}
set(gca,'XTick', [1,2,3,4],'XTickLabel',labs,'FontSize',fs);
xtickangle(40);
set(h1,'Position',[200 200 200 250])

filename=[pato 'Figure4A'];
saveas(gca, filename, 'svg');


h1=figure('color','white'); hold on; box on
fs=16; lw=2; 
x = 1; b = 1; 
p=[1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4]; p=jitter(p, [], 0.5, 0.5);
for m = 1 : 4
    Sens_n=squeeze(Sens(m,:,:)*100);

    for i=1:5
        scatter(p(b:b+4),Sens_n(i,:),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(Sens_n,2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(Sens_n,2)), (std(mean(Sens_n,2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1;  b=b+5;
    
end

xlim([0.5 4.5]);
ylim([0 100]);
labs={'Three-fold','VOL & rsFC','VOL & rsDYN','rsFC & rsDYN'}
set(gca,'XTick', [1,2,3,4],'XTickLabel',labs,'FontSize',fs);
xtickangle(40);
set(h1,'Position',[200 200 185 250])

filename=[pato 'Figure4B'];
saveas(gca, filename, 'svg');
    

h1=figure('color','white'); hold on; box on
fs=16; lw=2; 
x = 1; b = 1; 
p=[1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4]; p=jitter(p, [], 0.5, 0.5);
for m = 1 : 4
    Spec_n=squeeze(Spec(m,:,:)*100);

    for i=1:5
        scatter(p(b:b+4),Spec_n(i,:),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(Spec_n,2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(Spec_n,2)), (std(mean(Spec_n,2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1; b=b+5;
    
end

xlim([0.5 4.5]);
ylim([0 100]);
labs={'Three-fold','VOL & rsFC','VOL & rsDYN','rsFC & rsDYN'}
set(gca,'XTick', [1,2,3,4],'XTickLabel',labs,'FontSize',fs);
xtickangle(40);
set(h1,'Position',[200 200 185 250])

filename=[pato 'Figure4C'];
saveas(gca, filename, 'svg');


