clear
topology_type = 'A';
% count = 1;
% file_direction = strcat('C:\Users\hakan\Documents\GitHub\mlv_inv\topologies to be evaluated\losspart\load variation\',topology_type);
% cd(file_direction)
for satir = 1:1:13
    savename1 = strcat(topology_type,'_sw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_sw_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
    
    %%
    %     satir = 1;
    Id(satir,:) = A_sw1_cur.signals.values;
    L=length(Id(satir,:));
    Ts=1e-7;
    
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
    %% pre filtering
    for la = 1:numel(Id)
        if (Id(la) < 1e-4)&&(Id(la) > -1e-4)
            Id(la) = 0;
        end
    end
    %%
    
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
    
    %% IGBT Loss : Switching+Conduction(steady state)
    
    P_IGBT(satir) = (Esw+Econd)*50;       %Total loss per IGBT
    
    %% Diode Loss : Condunction(ss) + Reverse Recovery
    
    P_diode(satir) = (Edsw + Edcond)*50;
    
    
    
    %%Total Loss
    
    Pper(satir)=P_IGBT(satir)+P_diode(satir);
    PLA(satir)=Pper(satir)*6;
    %Eload_a(satir)=load/(PLA(satir)+load)*100;
    E(satir,1:4)=[Esw Econd Edsw Edcond];
    P_IGBT_sw(satir) = Esw*50;
    P_IGBT_cond(satir) = Econd*50;
    P_diode_sw(satir) = Edsw*50;    
    P_diode_cond(satir) = Edcond*50;
end

%% efficiency versus power
figure
fsw=2000:2000:26000;
satir=PLA+8000;
Eload_a=8000./(satir)*100;
plot(fsw/1000,Eload_a,'LineWidth',2)
xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',16,'FontWeight','bold')
title('Efficiency versus Pout for A','FontWeight','bold')
set(gca,'fontsize',12,'FontWeight','bold')
grid on

%% loss components versus power
figure
plot(fsw/1000,P_IGBT_sw,'LineWidth',2)
hold on
plot(fsw/1000,P_IGBT_cond,'LineWidth',2)
hold on
plot(fsw/1000,P_diode_sw,'LineWidth',2)
hold on
plot(fsw/1000,P_diode_cond,'LineWidth',2)
hold off
xlabel('Pout (kW)','FontSize',16,'FontWeight','bold')
ylabel('Losses per device (W)','FontSize',16,'FontWeight','bold')
title('Losses per device versus Pout for A','FontWeight','bold')
legend('IGBT sw','IGBT cond','Diode sw','Diode cond','FontWeight','bold','Location','northwest')
set(gca,'fontsize',12,'FontWeight','bold')
grid on







