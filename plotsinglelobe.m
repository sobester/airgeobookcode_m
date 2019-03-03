function plotsinglelobe(N1,N2)
% Generates a plot of a simple fuselage geometry cross section
% via Equation (2.16)

Z = fillz(100);

Y = basicclassfun(Z, N1, N2, 0, 1);

hold on
colormap gray

plot(Y,Z,'k','LineWidth',2)
patch(-Y,Z,[0.95 0.95 0.95])

axis equal
xlabel('Y')
ylabel('Z')
axis([-1 1 0 1])