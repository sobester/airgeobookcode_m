function [cl,cp,ux,uy,v,ds,xc,yc,theta,dy]=panel(aerofoilPoints,alpha,Re,plotting)
% PANEL - Vortex panel method
%
%   [cl,cp,ux,uy,v,ds,xc,yc,theta,dy]=PANEL(aerofoilPoints,alpha,Re,plotting)
%
%   INPUTS
%   aerofoilPoints: two column vector of x,y coordinates of unit-chord 
%   aerofoil surface, starting at trailing edge (1,?), working along lower 
%   surface to leading edge (0,?), and back along upper surface to trailing
%   edge
%   alpha: angle of attack in degrees
%   Re: Reynolds number
%   plotting: 0 = no plot, 1 = quiver plot of aerfoloil and surface 
%   velocities
%
%   OUTPUTS
%   cl: lift coeficient
%   cp: pressure coefficient on surface
%   ux: horizontal component of surface velocity
%   uy: vertical component of surface velocity
%   v: magnitude of surface velocity
%   ds: panel lengths
%   xc: x-location of panel centres
%   yc: y-location of panel centres
%   theta: angle of panels
%   dy: vertical distance between panel end-points
%
%
% EXAMPLE
% =======
%
% Calls PANEL to calculate the pressure over a NACA0012 aerfoil at 10
% degrees angle of attack and compares to experimental data.
%
% alpha=10;
% Re=2.88e6;
% npoints=201;
% % calculate aerofoil coordinates
% A=naca4(0,0,12,'Low',npoints,0);
% % format to pass to panel()
% xu=A{1};
% yu=A{2};
% xl=A{3}(end:-1:2);
% yl=A{4}(end:-1:2);
% aerofoilPoints=[xl' xu'; yl' yu']';
% % call panel()
% [cl,cp,ux,uy,v,ds,xc,yc,theta,dy]=panel(aerofoilPoints,alpha,Re,1);
% 
% % Validation data (NACA0012 @ 10deg upper surface cp 
% %- Gregory & O'Reilly, NASA R&M 3726, Jan 1970)
% upperCp=[0 -3.66423
%     0.00218341 -5.04375
%     0.00873362 -5.24068
%     0.0131004 -4.67125
%     0.0174672 -4.32079
%     0.0480349 -2.74347
%     0.0742358 -2.26115
%     0.0982533 -1.95405
%     0.124454 -1.7345
%     0.146288 -1.55884
%     0.176856 -1.36109
%     0.28821 -1.00829
%     0.320961 -0.941877
%     0.384279 -0.787206
%     0.447598 -0.654432
%     0.515284 -0.543461
%     0.576419 -0.432633
%     0.637555 -0.343703
%     0.700873 -0.254725
%     0.766376 -0.1657
%     0.831878 -0.098572
%     0.893013 -0.00964205
%     0.958515 0.0793835
%     1 0.124088];
% 
% % plot Cp
% figure
% plot(xc(npoints:-1:1),cp(npoints:-1:1),'b');
% hold on
% plot(xc(npoints:(npoints-1)*2),cp(npoints:(npoints-1)*2),'r');
% plot(upperCp(:,1),upperCp(:,2),'go')
% titletext=['cl=',num2str(cl)];
% title(titletext)
% legend('lower','upper','experiment','Location','SouthEast')
% xlabel('x/c')
% ylabel('c_p')
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

xb=aerofoilPoints(1:end,1);
yb=aerofoilPoints(1:end,2);
npanel=length(xb)-1;

xc=zeros(npanel,1);
yc=zeros(npanel,1);
ds=zeros(npanel,1);
dx=zeros(npanel,1);
dy=zeros(npanel,1);
theta=zeros(npanel,1);
InfluenceMat=zeros(npanel+1,npanel+1);
TangentialMat=zeros(npanel,npanel+1);

rho=1.2;
mu=1.8e-5;
nu=mu/rho;
U=Re*nu;
alpha=alpha*pi/180;

for i=1:npanel
    xc(i)=(xb(i)+xb(i+1))/2.0;
    yc(i)=(yb(i)+yb(i+1))/2.0;
    ds(i)=sqrt((xb(i+1)-xb(i))^2+(yb(i+1)-yb(i))^2);
    dx(i)=xb(i+1)-xb(i);
    dy(i)=yb(i+1)-yb(i);
    %if yc(i)<0
    if xc(i)<xb(i)
        theta(i)=-asin((yb(i+1)-yb(i))/(ds(i)/1));
    else
        theta(i)=asin((yb(i+1)-yb(i))/(ds(i)/1))-pi;
    end
end
for i=1:npanel
    for j=1:npanel
        
        sinij=sin(theta(i)-theta(j));
        cosij=cos(theta(i)-theta(j));
        sinji=sin(theta(j)-theta(i));
        cosji=cos(theta(j)-theta(i));
        
        % work in panel frame of ref
        % collocation point to panel j
        xt=xc(i)-xb(j);
        yt=yc(i)-yb(j);
        % rotate
        xpc=xt*cos(theta(j))+yt*sin(theta(j));
        ypc=-xt*sin(theta(j))+yt*cos(theta(j));
        % collocation point to panel j+1
        xt=xb(j+1)-xb(j);
        yt=yb(j+1)-yb(j);
        % rotate
        xpc2=xt*cos(theta(j))+yt*sin(theta(j));
        
        % distance to panel
        R1=sqrt(xpc^2+ypc^2);
        R2=sqrt((xpc-xpc2)^2+ypc^2);
        
        if isreal(ypc)==0 || isreal(xpc)==0 
        keyboard
        end
        % angle between collocation point and panel
        B1=atan2(ypc,xpc);
        B2=atan2(ypc,(xpc-xpc2));
        B=B2-B1;
        
        Ustar=-log(R2/R1)*(1/(2*pi));
        Vstar=B*(1/(2*pi));
        Ustar_v=Vstar;
        Vstar_v=-Ustar;
        if i==j
            Ustar=0;
            Vstar=0.5;
            Ustar_v=0.5;
            Vstar_v=0;
        end
        InfluenceMat(i,j)=-sinij*Ustar+cosij*Vstar;
        InfluenceMat(i,npanel+1)=InfluenceMat(i,npanel+1)-sinij*Ustar_v+cosij*Vstar_v;
        if i==npanel || i==1
            InfluenceMat(npanel+1,j)=InfluenceMat(npanel+1,j)+cosji*Ustar-sinji*Vstar;
            InfluenceMat(npanel+1,npanel+1)=InfluenceMat(npanel+1,npanel+1)+cosji*Ustar_v-sinji*Vstar_v;
        end       
        TangentialMat(i,j)=cosji*Ustar-sinji*Vstar;
        TangentialMat(i,npanel+1)=TangentialMat(i,npanel+1)+cosji*Ustar_v-sinji*Vstar_v;        
    end
end

R=[(U*sin(theta-alpha));-U*cos(theta(1)-alpha) - U*cos(theta(npanel)-alpha)];

q=InfluenceMat\R;
v=(U*cos(theta-alpha))+TangentialMat*q;
u=(-U*sin(theta-alpha))+InfluenceMat(1:npanel,:)*q;
ux=v.*cos(theta)-u.*sin(theta);
uy=v.*sin(theta)+u.*cos(theta);

cp=1-(v./U).^2;
cl=-2*q(end)*sum(ds)/U;

if plotting==1
figure
plot(xb,yb,'k')
hold on
plot(xc,yc,'r.')
quiver(xc,yc,ux,uy)
axis equal
end

