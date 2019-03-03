function [XUpper,ZUpper,XLower,ZLower] = readfoildata(airfoil)
%READFOILDATA Parses airfoil coordinate files.
%
%   READFOILDATA(airfoil) reads the coordinate file corresponding to the
%   airfoil named in the argument. The coordinate file can be in a
%   Selig-formatted file or in a Matlab .mat file containing a matrix n
%   with two columns. The argument should simply be the name of the
%   airfoil, without a file extension.
%
%   [XUpper,ZUpper,XLower,ZLower] = readfoildata(airfoil) unpacks the
%   coordinates contained in the file.
%   
%   Note: the file setup.m should contain the path to the library
%   containing the airfoil definiton files.
%
%   Example
%   =======
%   [XUpper,ZUpper,XLower,ZLower] = readfoildata('naca663218')
%   hold on, axis equal, grid on
%   plot(XUpper, ZUpper), plot(XLower, ZLower)
%   xlabel('X'), ylabel('Z')
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------

global SELIGPATH
global MATAIRFOILPATH

setup

afpath2 = SELIGPATH;
afpath1 = MATAIRFOILPATH;

XUpper = []; XLower = [];
ZUpper = []; ZLower = [];

if exist([afpath1,airfoil,'.mat'],'file')
    display('Airfoil description found in .mat file')
    load([afpath1,airfoil,'.mat'])
    l = floor(size(n,1)/2);
    if l==size(n,1)/2
        XUpper = n(1:l,1);
        ZUpper = n(1:l,2);
        XLower = n(l+1:end,1); %#ok<*COLND>
        ZLower = n(l+1:end,2);    
    else
        XUpper = n(1:l+1,1);
        ZUpper = n(1:l+1,2);
        XLower = n(l+1:end,1);
        ZLower = n(l+1:end,2);
        if XUpper(2) > XUpper(3)
            XUpper = XUpper(end:-1:1);
            ZUpper = ZUpper(end:-1:1);
        end
        if XLower(2) > XLower(3)
            XLower = XLower(end:-1:1);
            ZLower = ZLower(end:-1:1);
        end
   end
    
elseif exist([afpath2,airfoil,'.dat'],'file')
    fid = fopen([afpath2,airfoil,'.dat'],'r');
    fgetl(fid);

    coords = [1 1];

    while coords(2) >= 0
        newl = fgetl(fid);
        coords = str2num(newl);
        if coords(2) >= 0
            XUpper = [XUpper,coords(1)]; %#ok<*AGROW>
            ZUpper = [ZUpper,coords(2)];
        else
            XLower = [XLower,coords(1)];
            ZLower = [ZLower,coords(2)];
        end 
    end


    while coords(1) ~= 1
        newl = fgetl(fid);
        coords = str2num(newl); %#ok<*ST2NM>
        XLower = [XLower,coords(1)];
        ZLower = [ZLower,coords(2)];
    end

    if XLower(1)~=0
        XLower = [0,XLower];
        ZLower = [0,ZLower];
    end

    if XUpper(end)~=0
        XUpper = [XUpper,0];
        ZUpper = [ZUpper,0];
    end

    XUpper = XUpper(end:-1:1);
    ZUpper = ZUpper(end:-1:1);
    
else
    display('Airfoil description not found');
    XUpper = []; ZUpper = []; XLower = []; ZLower = [];
    return 
end

% The first few entries in some airfoil descriptions might contain very 
% slightly negative abscissas. This will cause problems when fitting
% explicit (y=f(x)) curves to the data, such as when applying a CST
% transform. Simply comment out the rest of the function if this behaviour
% is not desired.

for i=0:min([10,length(XUpper),length(XLower)])
    if XUpper(end-i)<0
        XUpper(end-i) = [];
        ZUpper(end-i) = [];
    end
    if XLower(i+1)<0
        XLower(i+1) = [];
        ZLower(i+1) = [];
    end
end