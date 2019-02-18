
 Id=Isw1_all;
for  (satir=1:100)

L=length(Id(satir,:));


for n=1:L
    
    if (Id(satir,n)>-1e-5 && Id(satir,n)<1e-5) %meaning that there is an on switching, the  swtiching period could take long
       Id(satir,n)=0;    
    end
end

end
save('Btopology_brandnew', 'Id');
