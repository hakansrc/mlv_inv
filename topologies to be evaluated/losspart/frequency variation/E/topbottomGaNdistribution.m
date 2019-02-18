figure;
k=20;
subplot(1,2,1)
pie([P_GaNbottom(k) P_reverse_condbottom(k) P_GaNbottom_sw(k) P_Cossbottom(k)]);
title('bottom');
subplot(1,2,2)

pie([P_GaNtop(k) P_reverse_condtop(k) P_GaNtop_sw(k) P_Cosstop(k)]);
title('top');

legend('con', 'revcn', 'sw', 'C');