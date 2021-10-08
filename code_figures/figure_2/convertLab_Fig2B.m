function lab= convertLab(lab,nlab)
lab=char(lab)

for i=1:nlab
   ilab=lab(i,:,:);
   ilab(ilab=='_')=[];
   ind= strfind(ilab,'VOL');
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'lnorm');
   ilab(ind+1:ind+4)=[];
   ind= strfind(ilab,'rnorm');
   ilab(ind+1:ind+4)=[];
   ind= strfind(ilab,'bnorm');
   ilab(ind+1:ind+4)=[];
   ind= strfind(ilab,'DMN'); 
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'FPN');
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'SMN');
   ilab(ind:ind+2)=[];
   ilab(isspace(ilab))=[];
   ind= strfind(ilab,'resA');
   ilab(ind:ind+3)=[];
   labs{i}=ilab;
end
lab=labs;