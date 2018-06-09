%% B TOPOLOGY
clear all
close all
% load('B_loadvariated.mat')
topology_type = 'B';

%%
    P_GaNB_cond=zeros();
    P_GaNB_sw=zeros();  
    P_CossB=zeros();
    Pmodule=zeros();
    P_reverse_condB=zeros();
    Pper=zeros();
    PLB=zeros();
    E=zeros();
    Eload_b=zeros();
for satir = 1:1:8
    clearvars -except satir E Pper topology_type P_GaNB_cond P_reverse_condB P_GaNB_sw P_CossB Id PLB Eload_b
    savename1 = strcat(topology_type,'_sw_currents_',num2str(satir),'000_W');
    load(savename1);
    savename2 = strcat(topology_type,'_sw_voltages_',num2str(satir),'000_W');
    load(savename2);
 %% fitering
    minval = min(B_sw1_cur.signals.values);
    maxval = max(B_sw1_cur.signals.values);
    peak = (maxval-minval)/2;
    dcval = maxval-peak;
    filtered_signal = zeros(1,numel(B_sw1_cur.signals.values));
    for k = 1:numel(B_sw1_cur.signals.values)
        if abs(B_sw1_cur.signals.values(k)) > 1e-3
            filtered_signal(k) = B_sw1_cur.signals.values(k) - dcval;
        else
            filtered_signal(k) = B_sw1_cur.signals.values(k);
        end
    end
    
        fprintf('Dc value for %s  is %d\n',savename1,dcval)    
        %%
fsw=50000;
Id(satir,:)= filtered_signal;
% Vds = B_sw1_volt.signals.values;
% Id = Id';
for la = 1:numel(Id)
    if (Id(la) < 1e-4)&&(Id(la) > -1e-4)
        Id(la) = 0;
    end
end   
% Id = B_sw1_cur.signals.values;
    %%
    
    
    L=length(Id(satir,:));
    Ts=1e-7;
    load=800*satir;
    
    
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
        if Id(satir,1) < 0
            Id(satir,1)= 0;
        end
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
    PLB(satir)=Pmodule(satir)*2;
    Eload_b(satir)=load/(PLB(satir)+load)*100;
    
    E(satir,1:4)=[Esw  Econd Eoss Erevcond];
end


%%
figure
load=[1000 2000 3000 4000 5000 6000 7000 8000];
satir=PLB+load;
Eload_b=load./(satir)*100;
plot(load/1000,Eload_b,'LineWidth',2)
xlabel('Pout (kW)','FontSize',16,'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',16,'FontWeight','bold')
grid on
set(gca,'fontsize',12,'FontWeight','bold')
title('Efficiency versus Pout for B','FontWeight','bold')

%% loss components versus power
figure
plot(load/1000,P_GaNB_sw,'LineWidth',2)
hold on
plot(load/1000,P_GaNB_cond,'LineWidth',2)
hold on
plot(load/1000,P_CossB,'LineWidth',2)
hold on
plot(load/1000,P_reverse_condB,'LineWidth',2)
hold off
xlabel('Pout (kW)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus Pout for B','FontWeight','bold')
set(gca,'fontsize',12,'FontWeight','bold')
grid on
legend('Psw','Pcond','Poss','Prevcond','FontWeight','bold','Location','northwest')























