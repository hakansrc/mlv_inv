energy = [250 252 255 264 284 300 306 301 287 268];
force = [48 113 412 1713 2052 1270 118 972 1912 1580];
inductance = [0.05 0.054 0.056 0.06 0.14 0.17 0.18 0.15 0.12 0.015];
position = [ 1 2 3 4 5 6 7 8 9 10];

plot(fliplr(position),fliplr(inductance));
xlabel('Position')
ylabel('Inductance')