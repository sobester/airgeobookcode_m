function Z = fillz(n)
% Projections of n points sampling a semicircle
Theta = (pi:-pi/(n-1):0);
Z = 0.5*cos(Theta)+0.5;