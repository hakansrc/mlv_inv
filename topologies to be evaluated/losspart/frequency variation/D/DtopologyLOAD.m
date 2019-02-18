%% D TOPOLOGY

clear all
% close all
% load('topology_D_loadvariated.mat')
% fsw=51050;
Eload_d=zeros();
topology_type = 'D';
% fsw = 50000;
%%
P_diode=zeros();

Pper=zeros();
PLD=zeros();
Edcond=0;
Ecap=0;
swoff=0;
dcond=0;
% Id=diode1_current_all;
for (satir=1:8)
    clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff
    savename1 = strcat(topology_type,'_diode_currents_',num2str(satir),'000_W');
    load(savename1);
    savename2 = strcat(topology_type,'_diode_voltages_',num2str(satir),'000_W');
    load(savename2);
    Id(satir,:) = D_diode_currents.signals.values;
    L=length(Id(satir,:));
    Ts=1e-7;
    for la = 1:numel(Id)
        if (Id(la) < 1e-4)&&(Id(la) > -1e-4)
            Id(la) = 0;
        end
    end
 Edcond=0;
Ecap=0;
swoff=0;
dcond=0;   
        
    
%     Ron=(2.49-0.83)/(86.5);
    
    for n=1:L
        if (Id(satir,n)>0  && n>1 && n<L) %meaning that IGBT is on operation
            
            if ((Id(satir,n+1)<0) ) %meaning that there is an off switching, a decline in the current
                swoff=swoff+1;
            end
            
            Vds = diode_cond(Id(satir,n));
            Edcond= Edcond + Vds*Id(satir,n)*Ts;%abs(Id(satir,n))*0.83*Ts;%+abs(Id(satir,n))^2*Ron*Ts;
             dcond=dcond+1;
        end
    end
    
    Ecap=swoff*(9.3-3)/(282-146)*270*1e-6;
    
    P_diode(satir) = (Ecap + Edcond)*50;
    
end


%%
% Id=lowersw_current_all;
P_GaNtop=zeros();
P_GaNtop_sw=zeros();
P_Cossbottom=zeros();
P_reverse_condbottom=zeros();
Pbottom=zeros();

%%

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
for (satir=1:8)
    clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff Econd swon n L Pbottom P_reverse_condbottom ...
       P_GaNtop P_GaNbottom P_GaNbottom_sw P_Cossbottom Pbottom Erevcond Esw revcond Eon Ts cond Ecoss Eoss Ts
    savename1 = strcat(topology_type,'_lowersw_currents_',num2str(satir),'000_W');
    load(savename1);
    savename2 = strcat(topology_type,'_lowersw_voltages_',num2str(satir),'000_W');
    load(savename2);
    Id(satir,:) = D_lowersw_currents.signals.values;
    
    L=length(Id(satir,:));
    Ts=1e-7;
    for la = 1:numel(Id)
        if (Id(la) < 1e-3)&&(Id(la) > -1e-3)
            Id(la) = 0;
        end
    end
    
    
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
    
    P_GaNbottom(satir) = (Econd)*50;       %Total loss per IGBT
    P_reverse_condbottom(satir) = (Erevcond)*50;
    P_GaNbottom_sw(satir)= Esw*50;
    P_Cossbottom(satir)=Eoss*50;
    
    %%Total Loss
    
    Pbottom(satir)=P_GaNbottom(satir)+P_reverse_condbottom(satir)+P_GaNbottom_sw(satir)+P_Cossbottom(satir);
end

%%
% Id=uppersw_current_all;

P_GaNtop=zeros();
P_GaNtop_sw=zeros();
P_Cosstop=zeros();
P_reverse_condtop=zeros();
Ptop=zeros();


%%
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

for (satir=1:8)
    clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff Econd swon n L Pbottom P_reverse_condbottom ...
       P_GaNtop P_GaNbottom P_GaNbottom_sw P_Cossbottom Pbottom Erevcond Esw revcond Eon Ts cond Ptop P_GaNtop P_reverse_condtop P_GaNtop_sw P_Cosstop Ecoss cond  Eoss
    savename1 = strcat(topology_type,'_uppersw_currents_',num2str(satir),'000_W');
    load(savename1);
    savename2 = strcat(topology_type,'_uppersw_voltages_',num2str(satir),'000_W');
    load(savename2);
    Id(satir,:) = D_uppersw_currents.signals.values;
    
    L=length(Id(satir,:));
    Ts=1e-7;
    for la = 1:numel(Id)
        if (Id(la) < 1e-4)&&(Id(la) > -1e-4)
            Id(la) = 0;
        end
    end
    
    %
    
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
    
    P_GaNtop(satir) = (Econd)*50;       %Total loss per IGBT
    P_reverse_condtop(satir) = (Erevcond)*50;
    P_GaNtop_sw(satir)= Esw*50;
    P_Cosstop(satir)=Eoss*50;
    Ptop(satir)=P_GaNtop(satir)+P_reverse_condtop(satir)+P_GaNtop_sw(satir)+P_Cosstop(satir);
    
end


%% Total Loss
% load=[800 1600 2400 3200 4000 4800 5600 6400 7200 8000];
% Pper=Ptop+Pbottom+P_diode;
% PLD=Pper*12;
% Eload_d=load./(PLD+load)*100;
% %eff_D=8000./(Ptotal+8000)*10;
%
%
figure
load=[1000 2000 3000 4000 5000 6000 7000 8000];
satir=6*Ptop+6*Pbottom+6*P_diode+load;
Eload_b=load./(satir)*100;
plot(load/1000,Eload_b)
xlabel('Pout (kW)','FontSize',16,'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',16,'FontWeight','bold')
title('Efficiency versus Pout for D','FontWeight','bold')

%% loss components versus power
figure
plot(load,P_Cossbottom)
hold on
plot(load,P_GaNbottom_sw)
hold on
plot(load,P_reverse_condbottom)
hold on
plot(load,P_GaNbottom)
hold off
xlabel('Pout (kW)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus Pout for B','FontWeight','bold')
legend('P Cossbottom','P GaNbottom sw','Preverse condbottom','Pcondbottom','FontWeight','bold','Location','northwest')
%%
figure
plot(load,P_Cosstop)
hold on
plot(load,P_GaNtop_sw)
hold on
plot(load,P_reverse_condtop)
hold on
plot(load,P_GaNtop)
hold off
xlabel('Pout (kW)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus Pout for B','FontWeight','bold')
legend('P Cosstop','P GaNtop sw','Preverse condtop','Pcondtop','FontWeight','bold','Location','northwest')
%% 
figure
plot(load,P_diode)

xlabel('Pout (kW)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus Pout for B','FontWeight','bold')
legend('P Diode')
