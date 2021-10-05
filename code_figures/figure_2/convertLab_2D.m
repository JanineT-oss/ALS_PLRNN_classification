function lab= convertLab(lab,nlab)
lab=char(lab)
%keyboard
for i=1:nlab
   ilab=lab(i,:);
   ind= strfind(ilab,'resA');
   ilab(ind:ind+3)=[];
   
   ilab = char(ilab)
   ind= strfind(ilab,'_l');
   if length(ind) > 0
    ilab(ind:ind+1)=[];
    ilab=strcat(ilab, {' '}, 'l');
   else
   end
   
   ilab = char(ilab)
   ind= strfind(ilab,'_r');
   if length(ind) > 0
    ilab(ind:ind+1)=[];
    ilab=strcat(ilab, {' '}, 'r');
   else
   end
   
   ilab = char(ilab)
   ind= strfind(ilab,'_b');
   if length(ind) > 0
    ilab(ind:ind+1)=[];
   else
   end
   
   ind= strfind(ilab,'VOL');
   ilab(ind:ind+2)=[];
   
   ind= strfind(ilab,'DMN');
   ilab(ind:ind+2)=[];
   
   ind= strfind(ilab,'FPN');
   ilab(ind:ind+2)=[];
   
   ind= strfind(ilab,'SMN');
   ilab(ind:ind+2)=[];
   
   ind= strfind(ilab,'lnorm');
   ilab(ind:ind+4)=[];
   
   ind= strfind(ilab,'rnorm');
   ilab(ind:ind+4)=[];
   
   ind= strfind(ilab,'norm');
   ilab(ind:ind+3)=[];
   
   ilab=char(ilab);
   ilab(ilab=='_')=[];
   
   labs{i}=ilab;
end
lab=labs;