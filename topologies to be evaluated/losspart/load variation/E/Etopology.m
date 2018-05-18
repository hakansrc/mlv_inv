%%  TOPOLOGY 

clear all;
%close all;

cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\GaN-FET\Paper_GaN_Loss\t3level\E_topology');
 load('topology_E_detaileddatas_50.mat')


Id=zeros();
E_e=zeros();
E1=zeros();
E2=zeros();
E3=zeros();


%% 
P_diode=zeros();

Pper=zeros();
Ptotal=zeros();

Id=diode1_current_all;
for (satir=1:100)

L=length(Id(satir,:));
fsw=1050+(satir-1)*1000;
Ts=1/(20*fsw);


Edcond=0;
Ecap=0;
swoff=0;
dcond=0;
Ron=(3.96-0.76)/(45);

for n=1:L
    if (Id(satir,n)>0  && n>1 && n<L) %meaning that IGBT is on operation
    
       if ((Id(satir,n+1)<0) ) %meaning that there is an off switching, a decline in the current
        swoff=swoff+1;
       end

      Edcond= Edcond + abs(Id(satir,n))^2*Ron*Ts+abs(Id(satir,n))*0.76*Ts;
      dcond=dcond+1;
    end
end

Ecap=swoff*3.44*1e-6; %@ 270 C it has this amount of loss uJ

P_diode(satir) = (Ecap + Edcond)*50;

if (fsw==51050)
    E1=[0 0 0 0 Ecap+Edcond];
end

end
       

%%
Id=lowersw_current_all;
P_GaNtop=zeros();
P_GaNtop_sw=zeros();
P_Cossbottom=zeros();
P_reverse_condbottom=zeros();
Pbottom=zeros();

%% 

for (satir=1:100)

L=length(Id(satir,:));
fsw=1050+(satir-1)*1000;
Ts=1/(20*fsw);

Esw=0;
Eoff=0;
Eon=0;
Eoss=0;
Econd=0;
Erevcond=0;

swon=0;
swoff=0;
swrev=0;
cond=0;
revcond=0;
%%
for n=1:L
    if (Id(satir,n)>0  && n>1 && n<L) %meaning that IGBT is on operation
    
        if (Id(satir,n-1)==0) %meaning that there is an on switching, the  swtiching period could take long
            Eon=GaN_sw(abs(Id(satir,n)),'on'); %J
            Esw = Esw + Eon;
            swon=swon+1;
            
  
        elseif (Id(satir,n+1)==0) %meaning that there is an off switching, a decline in the current
            Eoff=GaN_sw(abs(Id(satir,n)),'off'); %j
            Esw = Esw + Eoff;
            swoff=swoff+1;
            
        else
            Vds=GaN_cond(Id(satir,n));
            Econd= Econd + Id(satir,n)* Vds*Ts;
            cond=cond+1;
        end
        
        
    elseif  (Id(satir,n)<0 && n<L) %meaning that diode is on operation
        
        if (Id(satir,n+1)==0) %meaning that there is an off switching, a decline in the current
           Eoff=GaN_sw(abs(Id(satir,n)),'off'); %j
           Esw = Esw + Eoff;
           swoff=swoff+1;
            
        elseif (Id(satir,n-1)==0)
            Eon=GaN_sw(abs(Id(satir,n)),'on'); %J
            Esw = Esw + Eon;
            swon=swon+1;
            
        else
            Vds=GaN_reverse_cond(Id(satir,n));
            Erevcond= Erevcond + abs(Id(satir,n))* Vds*Ts;
            revcond=revcond+1;
         end
    end
end

Eoss=swon*11e-6; %J

P_GaNbottom(satir) = (Econd)*50;       %Total loss per IGBT
P_reverse_condbottom(satir) = (Erevcond)*50;
P_GaNbottom_sw(satir)= Esw*50;
P_Cossbottom(satir)=Eoss*50;

%%Total Loss

Pbottom(satir)=P_GaNbottom(satir)+P_reverse_condbottom(satir)+P_GaNbottom_sw(satir)+P_Cossbottom(satir);

if (fsw==51050)
    E2=[Esw  Econd Eoss Erevcond 0];
end

end


%%
Id=uppersw_current_all;

P_GaNtop=zeros();
P_GaNtop_sw=zeros();
P_Cosstop=zeros();
P_reverse_condtop=zeros();
Ptop=zeros();


%% 

for (satir=1:100)

L=length(Id(satir,:));
fsw=1050+(satir-1)*1000;
Ts=1/(20*fsw);

Esw=0;
Eoff=0;
Eon=0;
Eoss=0;
Econd=0;
Erevcond=0;

swon=0;
swoff=0;
swrev=0;
cond=0;
revcond=0;
%%
for n=1:L
    if (Id(satir,n)>0  && n>1 && n<L) %meaning that IGBT is on operation
    
        if (Id(satir,n-1)==0) %meaning that there is an on switching, the  swtiching period could take long
            Eon=GaN_sw(abs(Id(satir,n)),'on'); %J
            Esw = Esw + Eon;
            swon=swon+1;
            
  
        elseif (Id(satir,n+1)==0) %meaning that there is an off switching, a decline in the current
            Eoff=GaN_sw(abs(Id(satir,n)),'off'); %j
            Esw = Esw + Eoff;
            swoff=swoff+1;
            
        else
            Vds=GaN_cond(Id(satir,n));
            Econd= Econd + Id(satir,n)* Vds*Ts;
            cond=cond+1;
        end
        
        
    elseif  (Id(satir,n)<0 && n<L) %meaning that diode is on operation
        
        if (Id(satir,n+1)==0) %meaning that there is an off switching, a decline in the current
           Eoff=GaN_sw(abs(Id(satir,n)),'off'); %j
           Esw = Esw + Eoff;
           swoff=swoff+1;
            
        elseif (Id(satir,n-1)==0)
            Eon=GaN_sw(abs(Id(satir,n)),'on'); %J
            Esw = Esw + Eon;
            swon=swon+1;
            
        else
            Vds=GaN_reverse_cond(Id(satir,n));
            Erevcond= Erevcond + abs(Id(satir,n))* Vds*Ts;
            revcond=revcond+1;
         end
    end
    
 
    
end

Eoss=swon*11e-6; %J

P_GaNtop(satir) = (Econd)*50;       %Total loss per IGBT
P_reverse_condtop(satir) = (Erevcond)*50;
P_GaNtop_sw(satir)= Esw*50;
P_Cosstop(satir)=Eoss*50;
Ptop(satir)=P_GaNtop(satir)+P_reverse_condtop(satir)+P_GaNtop_sw(satir)+P_Cosstop(satir);

   if (fsw==51050)
        E3=[Esw  Econd Eoss Erevcond 0];
   end


%P(satir)=[P_reverse_cond(satir) P_GaN_sw(satir) P_GaN_cond(satir) P_Coss(satir)];

end

E_e=(E1+E2+E3)*24*50;

%% Total Loss

Pper=Ptop+Pbottom+P_diode;
Pmodule=Pper*12;
Ptotal=Pmodule*2;
Efficiency_E=8000./(Ptotal+8000)*100;



%% GRAPHS

figure;
freq=(1.05:100.05);
plot(freq, Ptotal, 'linewidth', 2);
grid on;
xlabel('frequency (kHz)');
ylabel('Loss (W)');
title('GaN 3level/2 Parallel Topology Loss');

figure;
%freq=(1.050:1:101.050);
plot(freq, Efficiency_E, 'linewidth', 2);
grid on;
xlabel('frequency (kHz)');
ylabel('Efficiency');
title('GaN 3level/2 Parallel Topology Loss');
%%
P_e=Ptotal;
cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\GaN-FET\Paper_GaN_Loss\ForPlots');
save('P_e','P_e');
save('E_e','E_e');
save('Efficiency_E','Efficiency_E');
              
 
      
      
        


        

