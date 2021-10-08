function [stars,posi]= getStars(p)

stars=''; posi=0;
if p<.1 && p>=.05
    stars='(*)';    
    posi=.15;
elseif p<.05 && p>=.01
    stars='*';
    posi=.08;
elseif p<.01 && p>=.001
    stars='**';
    posi=.12;
elseif p<.001
    stars='***';
    posi=.15;
end