close all
clear all

%% create figure 4D
%% janine.thome@zi-mannheim.de

mod = 1;                                                                   % 1=VOL & FC; 2= VOL & DYN; 3= DYN & FC

%% paths
pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% load results
file = 'VOLFC_FI.mat';                                                     % mod = 1 inf Figure 4D
load(file)

Vi_mean = squeeze(mean(mean(Vi_kfold)));
labK = squeeze(labs_kfold(1,1,:));

[mVI I]=sort(Vi_mean, 'descend');
FivemostI = labK(I); FivemostI=FivemostI(1:5);

%% create colored fig
h1=figure('color','white'); hold on; box on
fs=16; lw=2;
basevalue=-0.2;                                                            %baseline of background color
height=.6;                                                                 %height of background color
ntot=length(labK);

colors=[.5 .5 .5];

dumV = contains(labK, 'VOL_');
dumF = contains(labK, 'FC_');
dumD = contains(labK, 'D_');

if mod == 1  % VOL & FC
    
    x=1:5; %VOL (orange)
    y=[ones(1,ntot+1)*height]; 
    a(2)=area([0 x]+.5,[height y(x)]);
    
    x=5:10; %FC (grey)
    a(3)=area(x+.5,y(x));
    
    
    cols=[1 0.5 0; 1 1 0;0.7 0.7 0.7]; %background colors
    col1=cols(1,:); col2=cols(2,:); col3=cols(3,:);
    %a(1).FaceColor =col1;   %area color
    a(2).FaceColor =col2;
    a(3).FaceColor =col3;
    %a(1).FaceAlpha=.2;      %area transparency
    a(2).FaceAlpha=.2; 
    a(3).FaceAlpha=.2;

    VVI=Vi_kfold(:,:,dumV==1);
    mVVI=squeeze(mean(mean(VVI))); 
    labV=labK(dumV==1);
    [mVVI I]=sort(mVVI, 'descend');
    VVI=VVI(:,:,I);
    labV=labV(I); labV=labV(1:5); labV =convertLabV_Fig4D(labV, length(labV));

    FVI=Vi_kfold(:,:,dumF==1);
    mFVI=squeeze(mean(mean(FVI))); 
    labF=labK(dumF==1);
    [mFVI I]=sort(mFVI, 'descend');
    FVI=FVI(:,:,I);
    labF=labF(I); labF=labF(1:5); labF=convertLabF_Fig4D(labF, length(labF)); labF=convertLabF2_Fig4D(labF, length(labF));
    labK=[labV(1:5),labF(1:5)];
    
    k=zeros(1,5);
    x=1;
    for j=1:5
         for i=1:5
            scatter(k+x,VVI(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
         end
        bar(x,mean(mean(VVI(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
        errorbar(x,mean(mean(VVI(:,:,j))), (std(mean(VVI(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
        x=x+1;
    end
    hold on
    for j=1:5
           for i=1:5
                scatter(k+x,FVI(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
           end
           bar(x,mean(mean(FVI(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
           errorbar(x,mean(mean(FVI(:,:,j))), (std(mean(FVI(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
            x=x+1;
    end
    
    filename=[pato 'Figure4D'];
    
elseif mod == 2 % VOL & DYN
    
    x=1:5; %Dyn (orange)
    y=[ones(1,ntot+1)*height]; 
    a(1)=area([0 x]+.5,[height y(x)]);
    
    x=5:10; %VOL (orange)
    y=[ones(1,ntot+1)*height]; 
    a(2)=area([0 x]+.5,[height y(x)]);
 
    cols=[1 0.5 0; 1 1 0;0.7 0.7 0.7]; %background colors
    col1=cols(1,:); col2=cols(2,:); col3=cols(3,:);
    a(1).FaceColor =col1;   %area color
    a(2).FaceColor =col2;
    %a(3).FaceColor =col3;
    a(1).FaceAlpha=.2;      %area transparency
    a(2).FaceAlpha=.2; 
    %a(3).FaceAlpha=.2;
    
    DVI=Vi_kfold(:,:,dumD==1);
    mDVI=squeeze(mean(mean(DVI))); 
    labDy=labK(dumD==1);
    [mDVI I]=sort(mDVI, 'descend');
    DVI=DVI(:,:,I);
    labDy=labDy(I); labDy=labDy(1:5); labDy=convertLabD_Fig4D(labDy, length(labDy));

    VVI=Vi_kfold(:,:,dumV==1);
    mVVI=squeeze(mean(mean(VVI))); 
    labV=labK(dumV==1);
    [mVVI I]=sort(mVVI, 'descend');
    VVI=VVI(:,:,I);
    labV=labV(I); labV=labV(1:5); labV =convertLabV_Fig4D(labV, length(labV));
    labK=[labDy(1:5), labV(1:5)];
    
    k=zeros(1,5);
    x=1;
    for j=1:5
            for i=1:5
                scatter(k+x,DVI(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
            end
            bar(x,mean(mean(DVI(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
            errorbar(x,mean(mean(DVI(:,:,j))), (std(mean(DVI(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
            x=x+1;
    end
    hold on
    for j=1:5
            for i=1:5
                scatter(k+x,VVI(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
            end
            bar(x,mean(mean(VVI(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
            errorbar(x,mean(mean(VVI(:,:,j))), (std(mean(VVI(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
            x=x+1;
    end

    filename=[pato 'FigureS_2A'];
    
elseif mod == 3 % DYN & FC
    
    x=1:5; %Dyn (orange)
    y=[ones(1,ntot+1)*height]; 
    a(1)=area([0 x]+.5,[height y(x)]);
    
    x=5:10; %FC (grey)
    a(3)=area(x+.5,y(x));
    
    cols=[1 0.5 0; 1 1 0;0.7 0.7 0.7]; %background colors
    col1=cols(1,:); col2=cols(2,:); col3=cols(3,:);
    a(1).FaceColor =col1;   %area color
    %a(2).FaceColor =col2;
    a(3).FaceColor =col3;
    a(1).FaceAlpha=.2;      %area transparency
    %a(2).FaceAlpha=.2; 
    a(3).FaceAlpha=.2;

    DVI=Vi_kfold(:,:,dumD==1);
    mDVI=squeeze(mean(mean(DVI))); 
    labDy=labK(dumD==1);
    [mDVI I]=sort(mDVI, 'descend');
    DVI=DVI(:,:,I);
    labDy=labDy(I); labDy=labDy(1:5); labDy=convertLabD_Fig4D(labDy, length(labDy));
    
    FVI=Vi_kfold(:,:,dumF==1);
    mFVI=squeeze(mean(mean(FVI))); 
    labF=labK(dumF==1);
    [mFVI I]=sort(mFVI, 'descend');
    FVI=FVI(:,:,I);
    labF=labF(I); labF=labF(1:5); labF=convertLabF_Fig4D(labF, length(labF)); labF=convertLabF2_Fig4D(labF, length(labF));

    labK=[labDy(1:5), labF(1:5)];
    
    k=zeros(1,5);
    x=1;
    for j=1:5
            for i=1:5
                scatter(k+x,DVI(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
            end
            bar(x,mean(mean(DVI(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
            errorbar(x,mean(mean(DVI(:,:,j))), (std(mean(DVI(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
            x=x+1;
    end
    hold on
    for j=1:5
            for i=1:5
                scatter(k+x,FVI(i,:,j),'MarkerEdgeColor', colors,'LineWidth',2.0);hold on 
            end
            bar(x,mean(mean(FVI(:,:,j),2)),'LineWidth',lw,'EdgeColor','k','Facecolor','none','LineWidth',3.0);
            errorbar(x,mean(mean(FVI(:,:,j))), (std(mean(FVI(:,:,j),2)))./sqrt(5),'.','LineWidth',lw,'color','k');
            x=x+1;
    end
 
    filename=[pato 'FigureS_2B'];
end

dum=10;
xlim([.5 dum+1]); ylim([-0.1 0.4]);
set(gca,'XTick',1:10,'XTickLabel',labK,'FontSize',fs)
xtickangle(40)
ylabel('Importance','FontSize',fs);
set(h1,'Position',[200 200 500 190])

saveas(gca, filename, 'svg');
