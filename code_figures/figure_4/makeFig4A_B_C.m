close all
clear all

%% paths
patiM='/###/Multimodal/Multimodal_classification_';                        %% add path with Multimodal classifier
pati_VOLFC='/###/Bimodal_VOLFC/VOLFC_classification_';                     %% add path with Bimodal VOL&FC classifier
pati_VOLDYN='/###/Bimodal_VOLDYN/VOLDYN_classification_';                  %% add path with Bimodal VOL&DYNclassifier
pati_FCDYN='/###/Bimodal_FCDYN/FCDYN_classification_';                     %% add path with Bimodal FC&DYN classifier
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end


%% load
for m = 1:4
    files = [{'/RF_classifier_Multimodal.mat'; '/RF_classifier_2fold_VOLFC.mat'; '/RF_classifier_2fold_VOLDYN.mat'; '/RF_classifier_2fold_FCDYN.mat'}]
    file = char(files(m));
    for i=1:5
        dum=num2str(i);
        if m ==1
            pati_a= strcat(patiM, dum)  
        elseif m==2
            pati_a= strcat(pati_VOLFC, dum)  
        elseif m==3
            pati_a= strcat(pati_VOLDYN, dum)  
        elseif m==4
            pati_a= strcat(pati_FCDYN, dum)  
        end
        filename=[pati_a file];
        load(filename);
        for j=1:5;
            Acc(m,i,j)=ClassifierRF(j).Performance.Acc;
            Sens(m,i,j)=ClassifierRF(j).Performance.Sens;
            Spec(m,i,j)=ClassifierRF(j).Performance.Spec;
        end
    end
end

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
keyboard
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
keyboard

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
keyboard
filename=[pato 'Figure4C'];
saveas(gca, filename, 'svg');


