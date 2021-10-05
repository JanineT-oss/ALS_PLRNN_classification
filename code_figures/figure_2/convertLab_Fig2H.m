function lab= convertLab(lab,nlab)

for i=1:nlab
   ilab=lab(i,:);
   if iscell(ilab)
       ilab=ilab{:};
   end

   ilab(ilab=='_')=[];
   ind= strfind(ilab,'VOL');
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'norm');
   ilab(ind:ind+3)=[];
   ind= strfind(ilab,'DMN'); 
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'FPN');
   ilab(ind:ind+2)=[];
   ind= strfind(ilab,'SMN');
   ilab(ind:ind+2)=[];
   ilab(isspace(ilab))=[];
   ind= strfind(ilab,'.nii');
   ilab(ind:ind+3)=[];
   labs{i}=ilab;
end
lab=labs;