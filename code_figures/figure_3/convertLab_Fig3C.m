function lab= convertLab(lab,nlab)
%keyboard

lab = char(lab);

for i=1:nlab
   ilab=lab(1,:,i);
   ind= strfind(ilab,'D_');
   ilab(ind:ind+1)=[];
   ind= strfind(ilab,'_');
   ilab(ind)=[];
   ilab(isspace(ilab))=[];
   labs{i}=ilab;
end
lab=labs;