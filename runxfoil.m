function [cd,cl,alpha]=runxfoil(x,cl,v,L,nu,filePath,xfoilPath)
% RUNXFOIL runs xfoil
%   [CD,CL,ALPHA]=RUNXFOIL(X,CL,V,L,NU,FILEPATH,XFOILPATH) returns the
%   drag coefficient (CD), lift coefficient (CL) and angle of attack
%   (ALPHA) of an aerofoil defined by X, a two column vector of
%   x,y coordinates of the aerofoil surface, starting at the trailing edge
%   (1,?), working along lower surface to the leading edge (0,?), and back
%   along upper surface to trailing edge. The CL input is the target lift
%   coefficient, V the velocity, L the chord of the aerofoil (X coordinates
%   are unit-chord and then scaled by L), NU the viscosity, FILEPATH the
%   local path where results are to be stored and XFOILPATH the path of the
%   Xfoil executable.
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

fid=fopen('aerofoil.dat','w');
for i=1:length(x)
    fprintf(fid,'%f %f\n',x(i,1),x(i,2));
end
fclose(fid);


a=340.3; %speed of sound
M=v/a; %Mach number
Re=(L*v)/nu; % Reynolds number

fid=fopen('commands.in','w');
fprintf(fid,'load %saerofoil.dat\n',filePath);
fprintf(fid,'MyFoil\n');
fprintf(fid,'panel\n');
fprintf(fid,'plop\nG\n\n');
fprintf(fid,'oper\n');
fprintf(fid,'visc %f\n',Re);
fprintf(fid,'M %f\n',M);
fprintf(fid,'type 1\n');
fprintf(fid,'pacc\n');
fprintf(fid,'%spolar.dat\n',filePath);
fprintf(fid,'\n');
fprintf(fid,'iter 250\n');
fprintf(fid,'cl %f\n',cl);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'quit\n');
fclose(fid);

run_xfoil_command=[xfoilPath 'xfoil < ' filePath 'commands.in > dump.out' ];
setenv('GFORTRAN_STDIN_UNIT','5');
setenv('GFORTRAN_STDOUT_UNIT','6');
setenv('GFORTRAN_STDERR_UNIT','0');
try
    system(run_xfoil_command);
    fid=fopen('polar.dat');
    for i=1:13
        tline = fgetl(fid);
    end
    fclose(fid);
    cl=str2num(tline(12:17));
    cd=str2num(tline(20:28));
    alpha=str2num(tline(3:8));
catch me
    cl=777;
    cd=777;
    alpha=777;
end
setenv('GFORTRAN_STDIN_UNIT','-1');
setenv('GFORTRAN_STDOUT_UNIT','-1');
setenv('GFORTRAN_STDERR_UNIT','-1');
!rm polar.dat



