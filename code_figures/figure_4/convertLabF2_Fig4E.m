function lab= convertLab(lab,nlab)
lab=char(lab)

for i=1:nlab
   ilab=lab(i,:);
   ilab(ilab=='_')=[];
   ind= strfind(ilab,'_1');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'2');
   ilab(ind)=[];
   ind= strfind(ilab,'1');
   ilab(ind)=[];
   ind= strfind(ilab,'0');
   ilab(ind)=[];
   ind= strfind(ilab,'resA');
   ilab(ind:ind+3)=[];
   labs{i}=ilab;
end
lab=labs;