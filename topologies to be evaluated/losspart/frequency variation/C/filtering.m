
load('C_sw_currents_70000Hz.mat');
%plot(C_sw1_cur.signals.values)
mysignal = C_sw1_cur.signals.values;
minval = min(mysignal);
maxval = max(mysignal);
peak = (maxval-minval)/2
dcval = (maxval-peak)
mysignal2 = zeros(1,numel(mysignal));
for k = 1:numel(mysignal)
    if abs(mysignal(k)) > 1e-3
        mysignal2(k) = mysignal(k) - dcval;
    else
        mysignal2(k) = mysignal(k);
    end
end

figure;
hold all;
plot(mysignal)
plot(mysignal2)

%%

load('C_sw_currents_7000_W.mat');
%plot(C_sw1_cur.signals.values)
mysignal = C_sw1_cur.signals.values;
minval = min(mysignal);
maxval = max(mysignal);
peak = (maxval-minval)/2
dcval = abs(maxval-peak)
mysignal2 = zeros(1,numel(mysignal));
for k = 1:numel(mysignal)
    if abs(mysignal(k)) > 1e-3
        mysignal2(k) = mysignal(k) - dcval;
    else
        mysignal2(k) = mysignal(k);
    end
end

figure;
hold all;
plot(mysignal)
plot(mysignal2)
