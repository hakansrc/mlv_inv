%% A TOPOLOGY 
clear all;
close all;

cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\GaN-FET\Paper_GaN_Loss\A_topology');
load('data_corrected');

%%
P_IGBT=zeros();
P_diode=zeros();
Pper=zeros();
Ptotal=zeros();
E_a=zeros();
Efficiency_A=zeros();
P=zeros();


%% 

for (satir=1:25)

L=length(Id(satir,:));
fsw=1050+(satir-1)*1000;
Ts=1/(20*fsw);


Esw=0;
Eoff=0;
Eon=0;
Edoff=0;
Econd=0;
Edcond=0;
Edsw=0;

swon=0;
swoff=0;
swd=0;
cond=0;
dcond=0;

for n=1:L
    if (Id(satir,n)>0  && n>1 && n<L) %meaning that IGBT is on operation
    
        if (Id(satir,n-1)==0) %meaning that there is an on switching, the  swtiching period could take long
            Eon=IGBT_sw(abs(Id(satir,n)),'on')*1e-3; %J
            Esw = Esw + Eon;
            swon=swon+1;
  
        elseif ((Id(satir,n+1)==0) ) %meaning that there is an off switching, a decline in the current
            Eoff=IGBT_sw(abs(Id(satir,n)),'off')*1e-3; %j
            Esw = Esw + Eoff;
            swoff=swoff+1;
            
        else
            Vds=IGBT_cond(Id(satir,n));
            Econd= Econd + Id(satir,n)* Vds*Ts;
            cond=cond+1;
        end
        
        
    elseif  (Id(satir,n)<0 && n<L) %meaning that diode is on operation
        
        if ((Id(satir,n+1)==0)) %meaning that there is an off switching, a decline in the current
            Edoff=diode_sw(Id(satir,n))*1e-3;
            Edsw = Edsw + Edoff;
            swd=swd+1;
            
        else
            Vds=diode_cond(Id(satir,n));
            Edcond= Edcond + abs(Id(satir,n))* Vds*Ts;
            dcond=dcond+1;
         end
    end
end

% IGBT Loss : Switching+Conduction(steady state)

P_IGBT(satir) = (Esw+Econd)*50;       %Total loss per IGBT

% Diode Loss : Condunction(ss) + Reverse Recovery

P_diode(satir) = (Edsw + Edcond)*50;



%%Total Loss

Pper(satir)=P_IGBT(satir)+P_diode(satir);
Ptotal(satir)=Pper(satir)*6;
Efficiency_A(satir)=8000/(8000+Ptotal(satir))*100;

if (fsw==10050)
    E_a=[Esw Econd Edsw Edcond]*6*50;
end
%P(satir)=[P_reverse_cond(satir) P_GaN_sw(satir) P_GaN_cond(satir) P_Coss(satir)];


end

%% Graphs

%%
% figure;
% freq=(1.050:1:25.050);
% plot(freq, Ptotal);
% xlabel('frequency (kHz)');
% ylabel('Loss (W)');
% title('IGBT loss calculation vs frequency');
% figure;
% bar(E,'stacked');
% legend('IGBT sw', 'IGBT cond', 'Diode sw', 'diode cond');
% 
% 

        
%subpot
figure;
freq=(1.050:1:25.050);
subplot(1,2,1);
plot(freq, Ptotal, 'linewidth', 2);
xlabel('frequency (kHz)');
ylabel('Loss (W)');
legend('Total Loss','Location','NorthWest')
title('IGBT 2 level-single Topology Loss');

subplot(1,2,2);
bar(freq,P,'stacked');
ylabel('E (joule) per transistor');
xlabel('frequency (kHz)');
xlim([0 26]);
legend('IGBT sw', 'IGBT cond', 'Diode sw', 'diode cond','Location','NorthWest');
title('Energy distribution');


%%
P_a=Ptotal;
cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\GaN-FET\Paper_GaN_Loss\ForPlots');
save('P_a','P_a');
save('Efficiency_A','Efficiency_A');
save('E_a','E_a');
              
 
   
        
        
        
            
            
        
            
            
        
        
 




    
    
    
