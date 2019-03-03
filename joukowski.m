function Af = joukowski(xc, yc, R, PlotReq)
%JOUKOWSKI Parametric airfoil based on the Joukowski complex mapping
%
%   JOUKOWSKI(xc, yc, R, PlotReq) Airfoil resulting from applying the 
%   Joukowski transform to a circle of radius R, centered on (xc,yc). Set
%   PlotReq to 1 to plot the airfoil.
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


C = xc + 1i*yc;
t = (0:0.01:2*pi);

Circle = R*exp(1i*t) + C;

Af = Circle + 1./Circle;

if PlotReq
    subplot(1,3,1)
    hold on, daspect([1 1 1])
    grid on
    plot(Circle,'LineWidth',2)
    
    % C broken up in case one part is 0
    plot(real(C), imag(C),'mx', 'MarkerSize',30)
    
    % Coordinate axes
    xlim([xc-R*1.25 xc+R*1.25])
    ylim([yc-R*1.25 yc+R*1.25])
    
    plot([xc-R*1.25 xc+R*1.25],[0 0],'k')
    plot([0 0],[yc-R*1.25 yc+R*1.25],'k')
    
    subplot(1,3,2:3)
    hold on, daspect([1 1 1])
    grid on
    Chord = max(real(Af)) - min(real(Af));
    Height = max(imag(Af)) - min(imag(Af));
    xlim([min(real(Af))-0.1*Chord max(real(Af))+0.1*Chord])
    ylim([min(imag(Af))-0.1*Height max(imag(Af))+0.1*Height])
    
    plot(Af,'LineWidth',2)
end