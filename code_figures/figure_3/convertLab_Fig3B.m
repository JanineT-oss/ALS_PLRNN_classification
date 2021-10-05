function lab= convertLab(lab,nlab)
lab=char(lab)

for i=1:nlab
   ilab=lab(i,:);
 
   ind= strfind(ilab,'D_');
   ilab(ind:ind+1)=[];
   ilab(isspace(ilab))=[];
   ilab(ilab=='_')=[ ];
   ind= strfind(ilab,'resA');
   ilab(ind:ind+3)=[];
   labs{i}=ilab;
end
lab=labs;