function lab= convertLab(lab,nlab)
lab=char(lab)

for i=1:nlab
   ilab=lab(i,:);
   %ilab(ilab=='_')=[];
   ind= strfind(ilab,'FC_');
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'norm');
   ilab(ind:ind+3)=[];
   ind= strfind(ilab,'_DMN'); 
   ilab(ind:ind+4)=[];
   ind= strfind(ilab,'DMN_'); 
   ilab(ind:ind+3)=[];
   ind= strfind(ilab,'FPN_');
   ilab(ind:ind+3)=[];
   ind= strfind(ilab,'SMN_');
   ilab(ind:ind+3)=[];
   ind= strfind(ilab,'_0');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_1');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_2');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_3');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_4');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_5');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_6');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_7');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_8');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_9');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_10');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_11');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_12');
   ilab(ind:ind+1)=[];
   ilab(ilab=='_')=[];
   ind= strfind(ilab,'_1');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'2');
   ilab(ind)=[];
   ind= strfind(ilab,'1');
   ilab(ind)=[];
   ind= strfind(ilab,'0');
   ilab(ind)=[];
   ind= strfind(ilab,'with');
   ilab(ind)=[];
   %ilab(isspace(ilab))=[];
   labs{i}=ilab;
end
lab=labs;