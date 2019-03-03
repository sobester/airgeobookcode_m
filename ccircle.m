% Re-create Figure 7.1 by running this script, a parameter sweep over a
% Joukowski aerofoil.
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------

xc = -0.12;
R = 1.125;

for yc = 0.16:-0.04:-0.16
    Af = joukowski(xc, yc, R, 1);
end
