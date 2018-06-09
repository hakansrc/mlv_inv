%% C TOPOLOGY
clear all
close all
% load('B_loadvariated.mat')
topology_type = 'C';
P_GaN_cond=zeros();
P_GaN_sw=zeros();
P_Coss=zeros();
P_reverse_cond=zeros();
Pper=zeros();
PLC=zeros();
Pmodule=zeros();
E=zeros();
fsw=51050;
Eload_c=zeros();

%%

for satir=1:1:50
    clearvars -except satir E Pper topology_type P_GaNB_cond P_reverse_condB P_GaNB_sw P_CossB Id PLC Eload_b...
        P_GaN_cond P_reverse_cond P_GaN_sw P_Coss
    savename1 = strcat(topology_type,'_sw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_sw_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
     %% fitering
    minval = min(C_sw1_cur.signals.values);
    maxval = max(C_sw1_cur.signals.values);
    peak = (maxval-minval)/2;
    dcval = maxval-peak;
    filtered_signal = zeros(1,numel(C_sw1_cur.signals.values));
    for k = 1:numel(C_sw1_cur.signals.values)
        if abs(C_sw1_cur.signals.values(k)) > 1e-3
            filtered_signal(k) = C_sw1_cur.signals.values(k) - dcval;
        else
            filtered_signal(k) = C_sw1_cur.signals.values(k);
        end
    end
        fprintf('Dc value for %s  is %d\n',savename1,dcval)
        %%
    
    
    Id(satir,:)= filtered_signal;
    for la = 1:numel(Id)
        if (Id(la) < 1e-4)&&(Id(la) > -1e-4)
            Id(la) = 0;
        end
    end
    L=length(Id(satir,:));
    Ts=1e-7;
    % load=800*satir;
    
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
    
    P_GaN_cond(satir) = (Econd)*50;       %Total loss per IGBT
    P_reverse_cond(satir) = (Erevcond)*50;
    P_GaN_sw(satir)= Esw*50;
    P_Coss(satir)=Eoss*50;
    
    %%Total Loss
    
    Pper(satir)=P_GaN_cond(satir)+P_reverse_cond(satir)+P_GaN_sw(satir)+P_Coss(satir);
    Pmodule(satir)=Pper(satir)*6;
    PLC(satir)=Pmodule(satir)*4;
    %     Eload_c(satir)=load/(PLC(satir)+load)*100;
    
    E(satir,1:4)=[Esw  Econd Eoss Erevcond ];
end

%%
figure
fsw=2000:2000:100000;
satir=PLC+8000;
Eload_c=8000./(satir)*100;
plot(fsw/1000,Eload_c,'LineWidth',2)
xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',16,'FontWeight','bold')
title('Efficiency versus Pout for C','FontWeight','bold')
set(gca,'fontsize',12,'FontWeight','bold')
grid on
%% loss components versus power
figure
plot(fsw/1000,P_GaN_sw,'LineWidth',2)
hold on
plot(fsw/1000,P_GaN_cond,'LineWidth',2)
hold on
plot(fsw/1000,P_Coss,'LineWidth',2)
hold on
plot(fsw/1000,P_reverse_cond,'LineWidth',2)
hold off
xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus fsw for C','FontWeight','bold')
legend('Psw','Pcond','Poss','Prevcond','FontWeight','bold','Location','northwest')
set(gca,'fontsize',12,'FontWeight','bold')
grid on
%%
% for satir=1:9:30
%     savename1 = strcat(topology_type,'_sw_currents_',num2str(satir*2),'000Hz');
%     load(savename1);
%     savename2 = strcat(topology_type,'_sw_voltages_',num2str(satir*2),'000Hz');
%     load(savename2);
%    
%    plot(C_sw1_cur.signals.values)
%    hold on
% end  
%     
%     
%     
%     hold off
%     legend('10','20','30','40','50','60','70')%,'','35','40','45','50')%,'55','60','65','70','75','80','85','90','95','100')
%     
%     
%     
    
    
    
    
    
    