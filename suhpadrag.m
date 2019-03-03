function D=suhpadrag(x,plotfoil)
% SUHPADRAG estimates drag od aircraft wing
%   D=SUPHADRAG(X,PLOTFOIL) returns the drag, D, of the SUHPA human powered
%   aircraft wing with span and aerofoil sections defined by X. Setting 
%   PLOTFOIL=1 produces plots of the aerfoils at four spanwise locations, 
%   along with their coefficient of pressure profiles. These profiles are 
%   calculated by PANEL. The first three elements of the X imput vector are
%   the span [m] and the root and tip thickness to chord ratio,
%   respectively.
%
%   If wingParameters.foil='naca44xx', no further inputs are required
%
%   If wingParameters.foil='nacaxxxx', the 4th and 5th elements of X are
%   the maximum camber and its location (as per the first two-digits of the
%   NACA 4-digit definition.
%
%   If wingParameters.foil='hermite', X may have either 9 elements (with
%   X(4:9) being the hermite foil definition of a constant aerofoil
%   throughout the span) or 27 elements (with X(4:9), X(10:15), X(16:21)
%   and X(22:27) being the hermite foil defintion at the root, b/6, b/3 and
%   b/2 locations along span b - with linear variation between aerofoils).
%   The six hermite foil variables are (suggested ranges in brackets):
%    1  tension_upper_nose [0.1,0.4] |T_A^upper|
%    2  tension_lower_nose [0.1,0.4] |T_A^lower|
%    3  tension_upper_tail [0.1,2] |T_B^upper|
%    4  tension_lower_tail [0.1,2] |T_B^lower|
%    5  angle_lower_tail (deg) [-15,15] alpha_c
%    6  angle_tail (deg) [1,30] alpha_b
%
%   Further global variables need to be set before calling SUHPADRAG, as
%   per the example below.
%
%   CALLS: FMINSEARCH, GETCHORDS, NACA4 or HERMITE_AIRFOIL, RUNXFOIL, PANEL
%   
%   Example
%   =======
%   This is based on Listing 12.1 in Sobester and Forrester (2014):
%
% % set global parameters
% global wingParameters constants
% % constants
% constants.g=9.81; % accelration due to gravity [ms^-2]
% constants.rho=1.2; % density of air [kgm^-3]
% constants.nu=1.461e-5; % kinematic viscosity of air [m^2s^-1]
% constants.V=12.5; % flight speed [ms^-1]
% constants.xfoil_path='...'; % file path
% constants.file_path='...'; % Xfoil path
% % wing parameters
% wingParameters.loading=75; % wing loading [Nm^-2]
% wingParameters.e=0.85;% Oswald efficiency (estimate!)
% wingParameters.wSpar=50; % width of spar [mm]
% wingParameters.tCap=2.0; % thickness of carbon pulstrusion [mm]
% wingParameters.weight=850; % weight of aircraft minus wing [N]
% wingParameters.deflection=600; % maximum deflection at tip [mm]
% wingParameters.foil='naca44xx'; % airfoil defintion type
% % call SUHPADRAG
% SUHPADRAG([20 100 30],1)
%
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------
%
% Copyright 2014 A I J Forrester
%
% This program is free software: you can redistribute it and/or modify  it
% under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or any
% later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License and GNU
% Lesser General Public License along with this program. If not, see
% <http://www.gnu.org/licenses/>.

global wingParameters constants

if exist('plotfoil','var')==0
    plotfoil=0;
end
if plotfoil==1
    figure
    ax=axes;
    hold on
    bx=axes;
    hold on
end

b=x(1);  % WING SPAN [m]
wingParameters.b=b;
rootThick=x(2)/1000; % SPAR THICKNESS AT ROOT [mm]
tipThick=x(3)/1000; % SPAR THICKNESS AT TIP [mm]
TR=(rootThick-tipThick)/(b/2);

L=wingParameters.weight+wingweight(b);
L0=L/((pi/4)*b); % lift at root
S=L/wingParameters.loading;

[chords,error]=fminsearch(@getchords,[0.8 0.6 0.5]);

sectionLength=b/6;

area0=(chords(1)+chords(2))*sectionLength/2;
area1=(chords(2)+chords(3))*sectionLength/2;
area2=S/2-area0-area1;
chords(4)=(2*area2/sectionLength)-chords(3);

stations=4;
y=0:sectionLength:b/2;
for i=1:stations
    cl(i)=(2*L0/(constants.rho*constants.V^2))*sqrt(1-(2*y(i)/b).^2)./chords(i);
    t=rootThick-TR.*y(i);
    tc=t/chords(i);
    Re=constants.V*chords(i)/constants.nu;
    npoints=101;
    if strcmp(wingParameters.foil,'naca44xx')==1 || strcmp(wingParameters.foil,'nacaxxxx')==1
        if strcmp(wingParameters.foil,'nacaxxxx')==1
            [Airfoil, Camber, RLE] = naca4(x(5),x(4),tc*100,'Low',npoints,0);
            
        elseif strcmp(wingParameters.foil,'naca44xx')==1
            [Airfoil, Camber, RLE] = naca4(4,4,tc*100,'Low',npoints,0);
        end
        xu=Airfoil{1};
        yu=Airfoil{2};
        xl=Airfoil{3}(end:-1:2);
        yl=Airfoil{4}(end:-1:2);
        points=[xl' xu'; yl' yu']';
        
    elseif strcmp(wingParameters.foil,'hermite')
        if length(x)==9
            [upper,lower,req_depth] = hermite_airfoil(x(4),x(5),x(6),x(7),x(8),x(9));
        else
            [upper,lower,req_depth] = hermite_airfoil(x(4+(i-1)*6),x(5+(i-1)*6),x(6+(i-1)*6),x(7+(i-1)*6),x(8+(i-1)*6),x(9+(i-1)*6));
        end
        points=[lower(end:-1:2,:);upper];
    else
        error('airfoil type not supported')
    end
    [cd(i),cl,alpha]=runxfoil(points,cl(i),constants.V,chords(i),constants.nu,constants.file_path,constants.xfoil_path);
    [cl,cp,ux,uy,v,ds,xc,yc,theta,dy]=panel(points,alpha,Re,0);
    
    if plotfoil==1
        plotpoints=points.*chords(i);
        xcplot=xc.*chords(i);
        if i==1
            axes(ax)
            plot(plotpoints(:,1),plotpoints(:,2),'k');
            axes(bx)
            plot(xcplot,-cp,'k')
        elseif i==2
            axes(ax)
            plot(plotpoints(:,1),plotpoints(:,2),'k--');
            axes(bx)
            plot(xcplot,-cp,'k--')
        elseif i==3
            axes(ax)
            plot(plotpoints(:,1),plotpoints(:,2),'k-.');
            axes(bx)
            plot(xcplot,-cp,'k-.')
        elseif i==4
            axes(ax)
            plot(plotpoints(:,1),plotpoints(:,2),'k:');
            axes(bx)
            plot(xcplot,-cp,'k:')
        end
        axes(ax)
        h=legend('$$y=0$$','$$b/6$$','$$b/3$$','$$b/2$$');
        set(h,'Interpreter','latex');
        
        
        xlabel('$$x$$ [m]','Interpreter','Latex');
        ylabel('$$z$$ [m]','Interpreter','Latex');
        axes(bx)
        ylabel('$$c_p$$','Interpreter','Latex');
        set(bx,'Color','none')
        set(bx,'YAxisLocation','right');
        
        set(bx,'Ylim',[-2 2])
        set(ax,'Ylim',[-0.05 0.5])
        
        set(ax,'Xlim',[-0.05 0.9])
        set(bx,'Xlim',[-0.05 0.9])
        
        set(bx,'XTickLabel',[])
        set(bx,'YTickLabel',[2 1.5 1 0.5 -0.5 -1 -1.5 -2 -2.5])
    end
end

Dv=2*sum(0.5*constants.rho*constants.V^2.*((chords(1:end-1)+chords(2:end)).*sectionLength/2).*((cd(1:end-1)+cd(2:end))./2));
AR=b^2/S;
CL3d=L/(0.5*constants.rho*constants.V^2*S);
CDi=CL3d^2/(pi*AR*wingParameters.e);
Di=0.5*constants.rho*constants.V^2*S*CDi;
D=Dv+Di;