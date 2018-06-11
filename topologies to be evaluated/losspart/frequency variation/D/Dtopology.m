%% D TOPOLOGY

clear 
%close all;
%
% cd('C:\Users\syf.DESKTOP-JNMNU9A\Documents\GitHub\GaN-FET\Paper_GaN_Loss\t3level\D_topology');
% load('topology_D_detaileddatas_50.mat');
topology_type = 'D';
% Id=zeros();
E_d=zeros();
E1=zeros();
E2=zeros();
E3=zeros();

%%
P_diode=zeros();

Pper=zeros();
Ptotal=zeros();

% Id=diode1_current_all;
for (satir=1:50)
        clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff

    savename1 = strcat(topology_type,'_diode_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_diode_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
    
            %% fitering
%     minval = min(D_diode_currents.signals.values);
    maxval = max(D_diode_currents.signals.values);
    peak = 24.5242;
    dcval = maxval-peak;
    filtered_signal = zeros(1,numel(D_diode_currents.signals.values));
    for k = 1:numel(D_diode_currents.signals.values)
        if abs(D_diode_currents.signals.values(k)) > 1e-3
            filtered_signal(k) = D_diode_currents.signals.values(k) - dcval;
        else
            filtered_signal(k) = D_diode_currents.signals.values(k);
        end
    end
%     figure 
%     plot(filtered_signal)
%     hold on
%     plot(A_sw1_cur.signals.values)
    fprintf('Dc value for %s W is %d\n',savename1,dcval)
    %%
    Id(satir,:) = D_diode_currents.signals.values;
    L=length(Id(satir,:));
    % fsw=1050+(satir-1)*1000;
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

    % if (fsw==51050)
    %     E1=[0 0 0 0 Ecap+Edcond];
    % end

end


%%
% Id=lowersw_current_all;
% P_GaNtop=zeros();
% P_GaNtop_sw=zeros();
% P_Cossbottom=zeros();
% P_reverse_condbottom=zeros();
% Pbottom=zeros();

%%
Esw=0;
Eoff=0;
Eon=0;
Eoss=0;
Econd=0;
Erevcond=0;
% clear
swon=0;
swoff=0;
swrev=0;
cond=0;
revcond=0;

topology_type = 'D';
for (satir=1:50)
        clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff Econd swon n L Pbottom P_reverse_condbottom ...
       P_GaNtop P_GaNbottom P_GaNbottom_sw P_Cossbottom Pbottom Erevcond Esw revcond Eon Ts cond Ecoss Eoss Ts
 
    savename1 = strcat(topology_type,'_lowersw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_lowersw_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
    Id(satir,:) = D_lowersw_currents.signals.values;
    %     Id = Id';
    %     plot(Id)
    %     hold on
    L=length(Id(satir,:));
    %     fsw=1050+(satir-1)*1000;
    Ts=1e-7;
    %     fsw = 2000*satir;
    for la = 1:numel(Id)
        if (Id(la) < 1e-3)&&(Id(la) > -1e-3)
            Id(la) = 0;
        end
    end
%     fsw = satir*2000
    L=length(Id(satir,:));
    swon=0;
swoff=0;
swrev=0;
cond=0;
revcond=0;
    Esw=0;
Eoff=0;
Eon=0;
Eoss=0;
Econd=0;
Erevcond=0;
    
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
            
            
        elseif  (Id(satir,n)<0 && n<L&& n>1) %meaning that diode is on operation
            
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
    
    Eoss=270/400*swon*14.1e-6; %J
    
    P_GaNbottom(satir) = (Econd)*50;       %Total loss per IGBT
    P_reverse_condbottom(satir) = (Erevcond)*50;
    P_GaNbottom_sw(satir)= Esw*50;
    P_Cossbottom(satir)=Eoss*50;
    
    %%Total Loss
    
    Pbottom(satir)=P_GaNbottom(satir)+P_reverse_condbottom(satir)+P_GaNbottom_sw(satir)+P_Cossbottom(satir);
    
    % if (fsw==51050)
    %     E2=[Esw  Econd Eoss Erevcond 0];
    %
    % end
    
end

%
% %%
% Id=uppersw_current_all;
%
% P_GaNtop=zeros();
% P_GaNtop_sw=zeros();
% P_Cosstop=zeros();
% P_reverse_condtop=zeros();
% Ptop=zeros();
%
%
% %%
%
% for (satir=1:100)
%
% L=length(Id(satir,:));
% fsw=1050+(satir-1)*1000;
% Ts=1/(fsw*20);
%
%%
clearvars -except Pbottom P_diode P_GaNbottom P_reverse_condbottom P_GaNbottom_sw P_Cossbottom
topology_type = 'D';
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
for (satir=1:50)
    
    clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff Econd swon n L Pbottom P_reverse_condbottom ...
       P_GaNtop P_GaNbottom P_GaNbottom_sw P_Cossbottom Pbottom Erevcond Esw revcond Eon Ts cond Ptop P_GaNtop P_reverse_condtop P_GaNtop_sw P_Cosstop Ecoss cond  Eoss

    savename1 = strcat(topology_type,'_uppersw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_uppersw_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
    Id(satir,:) = D_uppersw_currents.signals.values;
    %     Id = Id';
    %     plot(Id)
    %     hold on
    L=length(Id(satir,:));
    %     fsw=1050+(satir-1)*1000;
    Ts=1e-7;
    %     fsw = 2000*satir;
    for la = 1:numel(Id)
        if (Id(la) < 1e-3)&&(Id(la) > -1e-3)
            Id(la) = 0;
        end
    end
    fsw = satir*2000;
    L=length(Id(satir,:));
    swon=0;
swoff=0;
swrev=0;
cond=0;
revcond=0;
    Esw=0;
Eoff=0;
Eon=0;
Eoss=0;
Econd=0;
Erevcond=0;

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


    elseif  (Id(satir,n)<0 && n<L&&n>1) %meaning that diode is on operation

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

Eoss=270/400*swon*14.1e-6; %J

P_GaNtop(satir) = (Econd)*50;       %Total loss per IGBT
P_reverse_condtop(satir) = (Erevcond)*50;
P_GaNtop_sw(satir)= Esw*50;
P_Cosstop(satir)=Eoss*50;
Ptop(satir)=P_GaNtop(satir)+P_reverse_condtop(satir)+P_GaNtop_sw(satir)+P_Cosstop(satir);
% 
% if (fsw==51050)
%     E3=[Esw  Econd Eoss Erevcond 0];
% end


end

%%
figure
fsw=2000:2000:100000;
satir=6*Ptop+6*Pbottom+6*P_diode;
satir = satir+8000;
Eload_b=8000./(satir)*100;
plot(fsw/1000,Eload_b,'LineWidth',2)
xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',16,'FontWeight','bold')
title('Efficiency versus fsw for D','FontWeight','bold')
set(gca,'fontsize',12,'FontWeight','bold')
grid on
%% loss components versus power
figure
plot(fsw/1000,P_Cossbottom,'LineWidth',2)
hold on
plot(fsw/1000,P_GaNbottom_sw,'LineWidth',2)
hold on
plot(fsw/1000,P_reverse_condbottom,'LineWidth',2)
hold on
plot(fsw/1000,P_GaNbottom,'LineWidth',2)
hold off
xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus fsw for D lower switch','FontWeight','bold')
legend('P Cossbottom','P GaNbottom sw','Preverse condbottom','Pcondbottom','FontWeight','bold','Location','northwest')
set(gca,'fontsize',12,'FontWeight','bold')
grid on
%%
figure
plot(fsw/1000,P_Cosstop,'LineWidth',2)
hold on
plot(fsw/1000,P_GaNtop_sw,'LineWidth',2)
hold on
plot(fsw/1000,P_reverse_condtop,'LineWidth',2)
hold on
plot(fsw/1000,P_GaNtop,'LineWidth',2)
hold off
xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus fsw for D upper switch','FontWeight','bold')
legend('P Cosstop','P GaNtop sw','Preverse condtop','Pcondtop','FontWeight','bold','Location','northwest')
set(gca,'fontsize',12,'FontWeight','bold')
grid on
%% 
figure
plot(fsw/1000,P_diode,'LineWidth',2)

xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus fsw for D','FontWeight','bold')
legend('P Diode')
set(gca,'fontsize',12,'FontWeight','bold')
grid on





