%%  TOPOLOGY 
clear all
% close all
% load('topology_E_loadvariated.mat')
topology_type = 'E';

% fsw=51050;


%% 
P_diode=zeros();

Pper=zeros();
PLE=zeros();

% Id=diode1_current_all;
for (satir=1:50)
    savename1 = strcat(topology_type,'_diode_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_diode_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
    Id(satir,:) = E_diode_currents.signals.values;
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

end
       

%%
% Id=lowersw_current_all;
P_GaNtop=zeros();
P_GaNtop_sw=zeros();
P_Cossbottom=zeros();
P_reverse_condbottom=zeros();
Pbottom=zeros();

%% 

%%
for (satir=1:50)
    clearvars -except satir Id Edcond dcond Ecap P_diode topology_type swoff Econd swon n L Pbottom P_reverse_condbottom ...
       P_GaNtop P_GaNbottom P_GaNbottom_sw P_Cossbottom Pbottom Erevcond Esw revcond Eon Ts cond Ecoss Eoss Ts
   savename1 = strcat(topology_type,'_lowersw_currents_',num2str(satir*2),'000Hz');
    load(savename1);
    savename2 = strcat(topology_type,'_lowersw_voltages_',num2str(satir*2),'000Hz');
    load(savename2);
    Id(satir,:) = E_lowersw_currents.signals.values;
    %     Id = Id';
    %     plot(Id)
    %     hold on
    L=length(Id(satir,:));
    %     fsw=1050+(satir-1)*1000;
%     Ts=1e-7;
    %     fsw = 2000*satir;
    for la = 1:numel(Id)
        if (Id(la) < 1e-3)&&(Id(la) > -1e-3)
            Id(la) = 0;
        end
    end
%     fsw = satir*2000
Ts=1e-7;
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
%         if Id(satir,1) < 0
%             Id(satir,1) = 0;
%         end
%         
        
    elseif  (Id(satir,n)<0 && n<L && (n-1)>0) %meaning that diode is on operation
        
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
end


%%
% Id=uppersw_current_all;
clearvars -except Pbottom P_diode P_GaNbottom P_reverse_condbottom P_GaNbottom_sw P_Cossbottom
topology_type = 'E';
P_GaNtop=zeros();
P_GaNtop_sw=zeros();
P_Cosstop=zeros();
P_reverse_condtop=zeros();
Ptop=zeros();

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
    Id(satir,:) = E_uppersw_currents.signals.values;
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
        
        
    elseif  (Id(satir,n)<0 && n<L&& n>1) %meaning that diode is on operation
        
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

end


%%
figure
fsw=2000:2000:100000;
satir=12*Ptop+12*Pbottom+12*P_diode;
satir = satir+8000;
Eload_b=8000./(satir)*100;
plot(fsw/1000,Eload_b,'LineWidth',2)
xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Efficiency (%)','FontSize',16,'FontWeight','bold')
title('Efficiency versus fsw for E','FontWeight','bold')
grid on
set(gca,'fontsize',12,'FontWeight','bold')
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
xlabel('fsw (kHzW)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus Pout for E lower switch','FontWeight','bold')
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
xlabel('fsw (kHzW)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per GaN versus Pout for E upper switch','FontWeight','bold')
legend('P Cosstop','P GaNtop sw','Preverse condtop','Pcondtop','FontWeight','bold','Location','northwest')
set(gca,'fontsize',12,'FontWeight','bold')
grid on
%% 
figure
plot(fsw/1000,P_diode,'LineWidth',2)

xlabel('fsw (kHz)','FontSize',16,'FontWeight','bold')
ylabel('Losses (W)','FontSize',16,'FontWeight','bold')
title('Losses per diode versus fsw','FontWeight','bold')
legend('P Diode')
set(gca,'fontsize',12,'FontWeight','bold')
grid on


