close all
clear all

%% create figure 2B
%% janine.thome@zi-mannheim.de

%% paths
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% fig set
fs=16; lw=2;
basevalue=-0.2;            %baseline of background color
height=.5;                 %height of background color


%% load results
file = 'VOL_FI.mat';
load(file)

Vi_mean = squeeze(mean(mean(Vi_kfold)));
labK = squeeze(labs_kfold(1,1,:));

[mVI I]=sort(Vi_mean, 'descend');
FivemostI = labK(I); FivemostI=FivemostI(1:5)

%% create colored fig
h1=figure('color','white'); hold on; box on
ntot=length(labK);

colors=[.5 .5 .5] 

x=1:7; %Global (grey)
y=[ones(1,ntot+1)*height]; 
a(4)=area([0 x]+.5,[height y(x)]);
x=7:9; %DMN  (red)
a(1)=area(x+.5,y(x)); 
x=9:13; %FPN (green)
a(2)=area(x+.5,y(x));
x=13:19+1; %SMN (blue)
a(3)=area(x+.5,y(x));

cols=[213 62 79; 154 213 148; 50 136 189;0.941 0.941 0.941]/255; %background colors
col1=cols(1,:); col2=cols(2,:); col3=cols(3,:);col4=cols(4,:);
a(1).FaceColor =col1;   %area color
a(2).FaceColor =col2;
a(3).FaceColor =col3;
a(4).FaceColor =col4;
a(1).FaceAlpha=.2;      %area transparency
a(2).FaceAlpha=.2;
a(3).FaceAlpha=.2;
a(4).FaceAlpha=.2;

Global=[1:7]; %Total VOL (black)
DMN=8:9;   %DMN  (red)
FPN=10:13; %FPN (green)
SMN=14:19; %SMN (blue)

VI_Global=Vi_kfold(:,:,Global);
mVI_Global=squeeze(mean(mean(VI_Global))); 
[mVI_Global I_Global]=sort(mVI_Global, 'descend');
VI_Global_n=(VI_Global(:,:,I_Global));
lab=labK(Global); labGlobal=lab(I_Global);
labDum(1:7)=labGlobal(1:end);

VI_DMN=Vi_kfold(:,:, DMN(1):DMN(end));
mVI_DMN=squeeze(mean(mean(VI_DMN))); 
[mVI_DMN I_DMN]=sort(mVI_DMN, 'descend');
VI_DMN_n=(VI_DMN(:,:,I_DMN));
lab=labK(DMN(1):DMN(end)); labDMNs=lab(I_DMN);
labDum(8:9)=labDMNs(1:2);

VI_FPN=Vi_kfold(:,:,FPN(1):FPN(end));
mVI_FPN=squeeze(mean(mean(VI_FPN)));
[mVI_FPN I_FPN]=sort(mVI_FPN, 'descend');
VI_FPN_n=(VI_FPN(:,:,I_FPN));
lab=labK(FPN(1):FPN(end)); labFPNs=lab(I_FPN);
labDum(10:13)=labFPNs(1:end);

VI_SMN=Vi_kfold(:,:,SMN(1):SMN(end));
mVI_SMN=squeeze(mean(mean(VI_SMN)));
[mVI_SMN I_SMN]=sort(mVI_SMN, 'descend');
VI_SMN_n=(VI_SMN(:,:,I_SMN));
lab=labK(SMN(1):SMN(end)); labSMNs=lab(I_SMN);
labDum(14:19)=labSMNs(1:end);

labD=convertLab_Fig2B(labDum, length(labDum));

k=zeros(1,5);
x=1;
for j=1:7
    for i=1:5
        scatter(k+x,VI_Global_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(VI_Global_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_Global_n(:,:,j))), (std(mean(VI_Global_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1;
end
hold on
k=zeros(1,5);
for j=1:2
    for i=1:5
        scatter(k+x,VI_DMN_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(VI_DMN_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_DMN_n(:,:,j))), (std(mean(VI_DMN_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    
    x=x+1;
end
hold on
k=zeros(1,5);
for j=1:4
    for i=1:5
        scatter(k+x,VI_FPN_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(VI_FPN_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_FPN_n(:,:,j))), (std(mean(VI_FPN_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    
    x=x+1;
end
hold on
k=zeros(1,5);
for j=1:6
    for i=1:5
        scatter(k+x,VI_SMN_n(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
    end
    bar(x,mean(mean(VI_SMN_n(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
    errorbar(x,mean(mean(VI_SMN_n(:,:,j))), (std(mean(VI_SMN_n(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
    x=x+1;
end
hold on

xlim([.5 length(labD)+1]); ylim([-0.2 0.5]);
set(gca,'XTick',1:length(labD),'XTickLabel',labD,'FontSize',fs)
xtickangle(30)
ylabel('Importance','FontSize',fs);
set(h1,'Position',[200 200 800 250])

filename=[pato 'Figure2B'];
saveas(gca, filename, 'svg');
