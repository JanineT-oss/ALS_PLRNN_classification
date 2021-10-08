clear all; close all; clc

%% create figure 2E
%% janine.thome@zi-mannheim.de

%% SPECIFY:
% allgemein
groupN = [0,1];                                                            % group coding
groupL = ["Controls", "ALS"];                                              % group labels      
GroupInd = 2;                                                              % column with group info

%% paths
pati='/###/';                                                              % add path containing "ALS_ALL_DATA_ALL.xlsx"
pato=['/###/Figures/'];                                                    % add output path
if ~isdir(pato), mkdir(pato); end

%% load data 
file_T = 'ALS_ALL_DATA_ALL.xlsx';
filename=[pati file_T];
tbl = readtable(filename);

%% get data
dataN(:,3) = (table2array(tbl(:,3)));
dataN(:,4:width(tbl))= table2array(tbl(:,4:width(tbl)));
labels = string(tbl.Properties.VariableNames(3:end));                      % specify
data=dataN(:,3:end);
group=data(:,1);
code = table2cell(tbl(:,1)); 
clear dataN

%% daten zuordnen
datC=data(:,6:6); dum= find(datC==-1); datC(dum)=NaN;                      % symptom duration
labC=labels(6:6);

datV=data(:,198:198); dum= find(datV==-1); datV(dum)=NaN;                  % certainty ALS diag VOL classifier
labV=labels(198:198);

ClinG2 = datC(find(group== groupN(2))); a2=isoutlier(ClinG2); ClinG2(a2==1)=NaN;
VolG2 = datV(find(group== groupN(2))); b2=isoutlier(VolG2); VolG2(b2==1)=NaN; 
[r2,p2] = corr(ClinG2,VolG2, 'rows', 'pairwise');

h1=figure('color','white'); hold on; box on        
fs=16; lw=2; 
           
scatter(ClinG2,VolG2, 'o','MarkerEdgeColor','k','LineWidth',1.5);  lsline
xlabel(labC,'FontSize',fs); ylabel(labV,'FontSize',fs);
dum2=num2str(r2);  dum2=dum2(1:5); dum3=strcat('R=', dum2); 
title(dum3,'FontSize',fs);
set(h1,'Position',[200 200 200 215])              

filename=strcat(pato,'Figure2E',labC);
saveas(gcf,filename,'svg');
       
       


         