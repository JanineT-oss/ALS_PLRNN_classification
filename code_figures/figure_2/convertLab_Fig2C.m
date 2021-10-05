function lab= convertLab(lab,nlab)
lab=char(lab)
keyboard
for i=1:nlab
   ilab=lab(i,:);
   ind= strfind(ilab,'VOL');
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'resA');
   ilab(ind:ind+3)=[];
   
   ilab = char(ilab)
   ind= strfind(ilab,'_norm');
   if length(ind) > 0
    ilab(ind:ind+4)=[];
    ilab=strcat(ilab, {' '}, 'norm');
   else
   end
   
   ilab = char(ilab)
   ilab(ilab=='_')=[];
   labs{i}=ilab;
end
lab=labs;