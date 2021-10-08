
clear all 
close all

%% create figure 3C
%% janine.thome@zi-mannheim.de

pato=['/###/Figures/'];                                                    %% add output path
if ~isdir(pato), mkdir(pato); end

%% set fig
fs=16; lw=2;

%% load feat
load('D_ALS_HC_Fig3C.mat');

%% color def
colHC=[0 0 0];
colALS=[ 252 141 89]/255;

%% dim reduction and multivariate group plot
% features 
X=dat; 
dum = find(isnan(X));
tmp=isnan(X);                   
outlier= find(sum(tmp')>10);
disp(outlier)

labnew=convertLab_Fig3C(lab, length(lab));

%%  stairs diagram
h1=figure('color','white'); 
iplot=1;
inD = [16];

for i=1:length(inD) 
    ylab={inD(i)}; 
    x=X(:,inD(i)); 

    
    ALS=x(group==1); HC=x(group==0);
    
    ind=isnan(ALS)|isoutlier(ALS); ALS(ind)=[];
    ind=isnan(HC)|isoutlier(HC); HC(ind)=[];
    
    [~,p,~,stats]=ttest2(ALS,HC)
    
    pad = p.*(length(lab))
    keyboard
    
    if pad >0.1
        pad = 0.1;
    else
        pad = pad;
    end
    
    subplot(1,1,iplot); hold on; box on  
    try
        xmin=min(x); xmax=max(x); ss=(xmax-xmin)/25;
        bins=[xmin:ss:xmax];
        [xHC,bins]=hist(HC,bins);
        [xALS,bins]=hist(ALS,bins);
        
        xHC=xHC/sum(xHC);
        xALS=xALS/sum(xALS);
        bottom=0;
        
        c='b'; x=xHC;
        l1=stairs(bins,x, 'color',colHC,'MarkerFaceColor',colHC,'LineWidth',lw);
        x = [l1.XData(1),repelem(l1.XData(2:end),2)];
        y = [repelem(l1.YData(1:end-1),2),l1.YData(end)];
        h=fill([x,fliplr(x)],[y,bottom*ones(size(y))],colHC, 'EdgeColor',colHC)
        set(h,'facealpha',.5)
        
        c='r'; x=xALS;
        l1=stairs(bins,x, 'color',colALS,'MarkerFaceColor',colALS,'LineWidth',lw);
        x = [l1.XData(1),repelem(l1.XData(2:end),2)];
        y = [repelem(l1.YData(1:end-1),2),l1.YData(end)];
        h=fill([x,fliplr(x)],[y,bottom*ones(size(y))],colALS, 'EdgeColor',colALS)
        set(h,'facealpha',.5)
         
        if pad >= .1
            txt=sprintf('p>%2.3f',pad); title(txt);
        else
            txt=sprintf('p=%2.3f',pad); title(txt);
        end
        set(gca,'xtick',[],'FontSize',fs);
        set(gca,'xticklabel',[],'FontSize',fs);
        xlabel(ylab,'FontSize',fs); 
        xlim([-0.01199,0.02])
        ylabel('rel frequency')
        xlabel('FD 18')

    end
    iplot=iplot+1;
end

set(h1,'Position',[200 200 200 230])
filename=[pato 'Figure3C'];
saveas(gca, filename, 'svg');

