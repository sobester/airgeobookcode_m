% Script for generating Figure 3.13, an illustration of the curve shape
% control achievable in a Ferguson spline.
r0 = [ 1 2 ];
r1 = [ 4 1.5 ];
dr_by_du1 = [ 1 0 ];
divisions = 50;
PlotReq = 1;

for i = (0.5:1:4.5)
    dr_by_du0 = [ 1  0.1 ]*i;
    r = hermite(r0, r1, dr_by_du0, dr_by_du1, divisions, PlotReq);
end