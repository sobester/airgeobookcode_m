% A simple illustration of the flexibility of Equation (2.16) 

N1s = [0.001  0.1  0.25 0.5 0.75  1    0.001  0.1  0.25  0.5 0.75 1];
N2s = [0.5    0.5   0.5 0.5  0.5  0.5  1      1    1     1   1   1 ];

for i=1:length(N1s)
    subplot(3,4,i)
    plotsinglelobe(N1s(i),N2s(i))
    title(['N_1=',num2str(N1s(i)),', N_2=',num2str(N2s(i))])
end 