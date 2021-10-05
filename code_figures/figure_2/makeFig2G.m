%close all
clear all

%% Make Figure 1C

%% paths
pati='/###/FC/FC_classification_';                                         %% add path FC classi results 
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% fig set
fs=16; lw=2;
basevalue=0;            %baseline of background color
height=[.6];            %height of background color

%% load results
file = '/RF_classifier_FC.mat';
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
ntot=length(labK);

colors=[.5 .5 .5]; 

DMN=1:22; %DMN  (red)
FPN=23:66; %FPN (green)
SMN=67:132; %SMN (blue)

VI_DMN=Vi_kfold(:,:,DMN(1):DMN(end));   
mVI_DMN=squeeze(mean(mean(VI_DMN))); 
[mVI_DMN I_DMN]=sort(mVI_DMN, 'descend');
VI_DMN_n=(VI_DMN(:,:,I_DMN));
lab=labK(DMN(1):DMN(end)); labDMNs=lab(I_DMN);
lab1=labDMNs(1:5,1);

VI_FPN=Vi_kfold(:,:,FPN(1):FPN(end));   
mVI_FPN=squeeze(mean(mean(VI_FPN))); 
[mVI_FPN I_FPN]=sort(mVI_FPN, 'descend');
VI_FPN_n=(VI_FPN(:,:,I_FPN));
lab=labK(FPN(1):FPN(end)); labFPNs=lab(I_FPN);
lab2=labFPNs(1:5,1);

VI_SMN=Vi_kfold(:,:,SMN(1):SMN(end));   
mVI_SMN=squeeze(mean(mean(VI_SMN))); 
[mVI_SMN I_SMN]=sort(mVI_SMN, 'descend');
VI_SMN_n=(VI_SMN(:,:,I_SMN));
lab=labK(SMN(1):SMN(end)); labSMNs=lab(I_SMN);
lab3=labSMNs(1:5,1);

labN=[lab1;lab2;lab3];
labNe=convertLab_Fig2G(labN, length(labN));
labNew=convertLab2_Fig2G(labNe, length(labNe));

%keyboard
x=1:5; %DMN  (red)
y=[ones(1,ntot+1)*height]; 
a(1)=area([0 x]+.5,[height y(x)]);
x=5:10; %FPN  (green)
a(2)=area(x+.5,y(x));
x=10:15; %DYN (orange)
a(3)=area(x+.5,y(x));

cols=[213 62 79; 154 213 148; 50 136 189;0.941 0.941 0.941]/255; %background colors
col1=cols(1,:); col2=cols(2,:); col3=cols(3,:);
a(1).FaceColor =col1;   %area color
a(2).FaceColor =col2;
a(3).FaceColor =col3;
a(1).FaceAlpha=.2;      %area transparency
a(2).FaceAlpha=.2;
a(3).FaceAlpha=.2;

x=1;
k=zeros(1,5);
for j=1:5 
    for i=1:5
        scatter(k+x,VI_DMN_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(VI_DMN_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_DMN_n(:,:,j))), (std(mean(VI_DMN_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1;
end
hold on
for j=1:5
     for i=1:5
        scatter(k+x,VI_FPN_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
     end
    bar(x,mean(mean(VI_FPN_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_FPN_n(:,:,j))), (std(mean(VI_FPN_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1;
end
hold on
for j=1:5
     for i=1:5
        scatter(k+x,VI_SMN_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
     end
    bar(x,mean(mean(VI_SMN_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_SMN_n(:,:,j))), (std(mean(VI_SMN_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1;
end

xlim([.5 15+1]); ylim([-0.1 0.4]);
set(gca,'XTick',1:15,'XTickLabel',labNew,'FontSize',fs)
xtickangle(30)
ylabel('Importance','FontSize',fs)
set(h1,'Position',[200 200 800 290])

keyboard

filename=[pato 'Figure2G'];
saveas(gca, filename, 'svg');
