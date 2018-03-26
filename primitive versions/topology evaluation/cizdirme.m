    
figure;
plot(freq_all(7,:),LLca1_voltages_spectrum_abs_all(7,:),'b -','Linewidth',3);
% hold on
% plot(ar_xaxis,ar_np_miron(2,:),'k -','Linewidth',3);
% hold on;
% plot(ar_xaxis,ar_np_miron(3,:),'r -','Linewidth',3);
% hold on;
% plot(ar_xaxis,ar_np_miron(4,:),'g -','Linewidth',3);
% hold off;
grid on;
set(gca,'FontSize',16);
%legend('Qs=12','Qs=18','Qs=24','Qs=30','Qs=36','Qs=42','Qs=48');
%legend('1 parallel','2 parallel','3 parallel','4 parallel');
%title('w = 2, ns = 2');
%xlabel('Aspect ratio','FontSize',16,'FontWeight','Bold')
%ylabel('Core iron mass (kg)','FontSize',16,'FontWeight','Bold')
%ylim([5 10]);
xlim([0 20e4])


%%
[X,Y] = meshgrid(1:2:10,1:18);
Z = sin(X) + cos(Y);
surf(X,Y,Z)
xlabel('bura X','FontSize',16,'FontWeight','Bold')
ylabel('bura Y','FontSize',16,'FontWeight','Bold')
zlabel('bu da Z','FontSize',16,'FontWeight','Bold')


%%
X = freq_all;
Y = ones(numel(freq_all(:,1)),numel(freq_all(1,:)));
for k = 1:numel(freq_all(:,1))
    Y(k,:) = k;
end
Z = LLab1_voltages_spectrum_abs_all;
%[X,Y] = meshgrid(1:0.5:10,1:20);
% for k=1:numel(X)
%     Z(k,:) = DCLINK_cap1_current_spectrum_abs_all(k,:);
% end


surf(Y,X,Z)
xlabel('bura X-','FontSize',16,'FontWeight','Bold')
ylabel('bura Y','FontSize',16,'FontWeight','Bold')
zlabel('bu da Z','FontSize',16,'FontWeight','Bold')
ylim([99 100000])
%zlim([0 0.2])


%%

figure;
plot(sw_frequencies,THD_Ia1_all,'b -','Linewidth',3);
hold on
%plot(sw_frequencies,THD_Ia3_all*20,'r -','Linewidth',3);
hold on;
%plot(sw_frequencies,THD_Vab1_all,'k -','Linewidth',3);
hold on
%plot(sw_frequencies,THD_Vab3_all,'g -','Linewidth',3);
% hold on;
% plot(ar_xaxis,ar_np_miron(3,:),'r -','Linewidth',3);
% hold on;
% plot(ar_xaxis,ar_np_miron(4,:),'g -','Linewidth',3);
hold off;
grid on;
set(gca,'FontSize',16);
%legend('Qs=12','Qs=18','Qs=24','Qs=30','Qs=36','Qs=42','Qs=48');
%legend('1 parallel','2 parallel','3 parallel','4 parallel');
%title('w = 2, ns = 2');
%xlabel('Aspect ratio','FontSize',16,'FontWeight','Bold')
%ylabel('Core iron mass (kg)','FontSize',16,'FontWeight','Bold')
%ylim([5 10]);
%xlim([0 20e4])


%%
figure;
plot(sw_frequencies,ripple1percent_all,'b -','Linewidth',3);
hold on
plot(sw_frequencies,ripple1vector_all,'r -','Linewidth',3);
hold on;
plot(sw_frequencies,ripple2percent_all,'k -','Linewidth',3);
hold on
plot(sw_frequencies,ripple2vector_all,'g -','Linewidth',3);
hold off;
grid on;
set(gca,'FontSize',16);
%legend('Qs=12','Qs=18','Qs=24','Qs=30','Qs=36','Qs=42','Qs=48');
%legend('1 parallel','2 parallel','3 parallel','4 parallel');
%title('w = 2, ns = 2');
%xlabel('Aspect ratio','FontSize',16,'FontWeight','Bold')
%ylabel('Core iron mass (kg)','FontSize',16,'FontWeight','Bold')
%ylim([5 10]);
%xlim([0 20e4])

%%
figure;

plot(sw_frequencies/1000,Capacitor_all*1e6,'b -','Linewidth',3);
title('2 level IGBT');
xlabel('Switching Frequency (kHz)');
ylabel('Total capacitance needed (µF)');
ylim([0 2500])
hold on
%plot(sw_frequencies,DCLINK_Ic2rms_all,'r -','Linewidth',3);
hold off;
grid on;
set(gca,'FontSize',16);
ylim([0 100]);

