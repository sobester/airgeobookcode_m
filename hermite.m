function r = hermite(r0, r1, dr_by_du0, dr_by_du1, divisions, PlotReq)
%HERMITE Hermite cubic connecting two points. Required to build a Hermite
%(a.k.a. Ferguson) airfoil.
%
% INPUTS:
%       r0 - vector of two components, the x and y coordinates of the
%       starting point
%       r1 - vector of two components, the x and y coordinates of the
%       end point
%       dr_by_du0 - the x and y components of the tangent vector at the
%       starting point
%       dr_by_du1 - the x and y components of the tangent vector at the
%       end point
%       divisions - number of points to make up the curve
%       PlotReq - if a plot of the curve is required, this should be
%       non-zero.
% OUTPUT
%       r - matrix containing the coordinates of the points that make up
%       the curve (first column: x, second column: y).
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------




% Hermite basis function matrix
C = [1 0 0 0; 0 0 1 0; -3 3 -2 -1; 2 -2 1 1];

S = [       r0(:)'; 
            r1(:)'; 
     dr_by_du0(:)';
     dr_by_du1(:)' ]; 

u = (0:1/divisions:1);

for i=1:length(u)
    U = [1 u(i) u(i)^2 u(i)^3];
    r(i,:) = (U*C)*S;
end

% Plot the curve and its tangents, if needed
if PlotReq
    hold on
    xlabel('x'), ylabel('y')
    grid on
    quiver(r0(1), r0(2), dr_by_du0(1), dr_by_du0(2), 0, 'LineWidth',1)
    quiver(r1(1), r1(2), dr_by_du1(1), dr_by_du1(2), 0, 'LineWidth',1)
    plot(r(:,1),r(:,2));
end