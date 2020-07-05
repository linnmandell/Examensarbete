%% Plot amount of SLAMS
clc, clear all, close all
sliding_window = 2*[1 2 4 6 8 10 12 14 16];
Date_20020111 = [3 22 38 29 32 32 31 29 28]; 
Date_20020203 = [43 46 52 61 65 60 61 59 61];
Date_20020204 = [1 1 1 1 1 1 1 1 1]; 
Date_20020206 = [10 19 19 21 20 18 25 28 26]; 
Date_20020220 = [1 14 28 23 23 18 14 14 14];
Date_20020318 = [7 9 8 5 6 12 15 18 18];
Date_20020327 = [8 18 23 27 26 26 32 35 31];
Date_20020402 = [11 8 8 11 13 16 16 20 21];

figure
plot(sliding_window, Date_20020111, '-o', 'LineWidth',2)
hold on
plot(sliding_window, Date_20020203, '-o', 'LineWidth',2)
plot(sliding_window, Date_20020204, '-o', 'LineWidth',2)
plot(sliding_window, Date_20020206, '-o', 'LineWidth',2)
plot(sliding_window, Date_20020220, '-o', 'LineWidth',2)
plot(sliding_window, Date_20020318, '-o', 'LineWidth',2)
plot(sliding_window, Date_20020327, '-o', 'LineWidth',2)
plot(sliding_window, Date_20020402, '-o', 'LineWidth',2)
xlabel('Sliding window [min]','FontSize',15)
ylabel('Number of SLAMS','FontSize',15)
legend('2002-01-11', '2002-02-03', '2002-02-04', '2002-02-06', '2002-02-20', '2002-03-18', '2002-03-27', '2002-04-02')
hold off
