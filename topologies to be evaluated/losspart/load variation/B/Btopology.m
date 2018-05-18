%% B TOPOLOGY 

clear all;
%close all;

cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\GaN-FET\Paper_GaN_Loss\B');
load('Btopology_brandnew');
%%

P_GaNB_cond=zeros();
P_GaNB_sw=zeros();
P_CossB=zeros();
Pmodule=zeros();
P_reverse_condB=zeros();
Pper=zeros();
Ptotal=zeros();
E_b=zeros();
Efficiency_B=zeros();
P=zeros();

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
            Eon=GaNB_sw(abs(Id(satir,n)),'on'); %J
            Esw = Esw + Eon;
            swon=swon+1;
            
  
        elseif (Id(satir,n+1)==0) %meaning that there is an off switching, a decline in the current
            Eoff=GaNB_sw(abs(Id(satir,n)),'off'); %j
            Esw = Esw + Eoff;
            swoff=swoff+1;
            
        else
            Vds=GaNB_cond(Id(satir,n));
            Econd= Econd + Id(satir,n)* Vds*Ts;
            cond=cond+1;
        end
        
        
    elseif  (Id(satir,n)<0 && n<L) %meaning that diode is on operation
        
        if (Id(satir,n+1)==0) %meaning that there is an off switching, a decline in the current
           Eoff=GaNB_sw(abs(Id(satir,n)),'off'); %j
           Esw = Esw + Eoff;
           swoff=swoff+1;
            
        elseif (Id(satir,n-1)==0)
            Eon=GaNB_sw(abs(Id(satir,n)),'on'); %J
            Esw = Esw + Eon;
            swon=swon+1;
            
        else
            Vds=GaNB_reverse_cond(Id(satir,n));
            Erevcond= Erevcond + abs(Id(satir,n))* Vds*Ts;
            revcond=revcond+1;
         end
    end
end

Eoss=swon*14.1e-6; %J

P_GaNB_cond(satir) = (Econd)*50;       %Total loss per IGBT
P_reverse_condB(satir) = (Erevcond)*50;
P_GaNB_sw(satir)= Esw*50;
P_CossB(satir)=Eoss*50;

%%Total Loss

Pper(satir)=P_GaNB_cond(satir)+P_reverse_condB(satir)+P_GaNB_sw(satir)+P_CossB(satir);
Pmodule(satir)=Pper(satir)*6;
Ptotal(satir)=Pmodule(satir)*2;
Efficiency_B(satir)=8000/(8000+Ptotal(satir))*100;

if (fsw==51050)
    E_b=[Esw Econd Eoss Erevcond ]*12*50;
end
%P(satir)=[P_reverse_cond(satir) P_GaN_sw(satir) P_GaN_cond(satir) P_Coss(satir)];



end

%% Graphs
% figure;
% freq=(1.050:5:100.050);
% plot(freq, Ptotal);
% xlabel('frequency (kHz)');
% ylabel('Loss (W)');
% title('IGBT loss calculation vs frequency');
% figure;
% bar(E,'stacked');
% legend('GaN revcond', 'Switch', 'Conduction', 'Coss');

%subpot
figure;
freq=(1.050:1:100.050);
subplot(1,2,1);
plot(freq, Ptotal, 'linewidth', 2);
hold on;
plot(freq,Pmodule,'linewidth', 2);
xlabel('frequency (kHz)');
ylabel('Loss (W)');
legend('Total Loss','Module Loss','Location','NorthWest')
title('GaN 2level/2 Series Topology Loss');
hold off;

subplot(1,2,2);
bar(freq,P,'stacked');
ylabel('E (joule) per transistor');
xlabel('frequency (kHz)');
xlim([-10 105]);
legend('GaN revcond', 'Switch', 'Conduction', 'Coss','Location','NorthWest');
title('Energy distribution');

      
        
%%
P_b=Ptotal;
cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\GaN-FET\Paper_GaN_Loss\ForPlots');
save('P_b','P_b');
save('E_b','E_b');
save('Efficiency_B','Efficiency_B') ;             
 
    
   
        
        
        
            
            
        
            
            
        
        
 




    
    
    
