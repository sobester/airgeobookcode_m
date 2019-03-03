function [Y, Z, YCar, YPax, OOB, CrossSectArea] = ...
    doublelobebasic(Z,DoubleLobeParam,PlotRequired,AlterZ)
% Implementation of the cross section geometry defined by Equation (2.18)


global COMTANON

Z = Z(:)';

% DoubleLobeParam structure: ======================================
% No.       1     2      3      4        5     6     7      8    
% Var.  [  RCar N1Car  N2Car CoeffCar  RPax  N1Pax N2Pax CoeffPax]
% ===============================================================
% Usage examples in fig2_5.m, fig2_6.m, fig2_7.m 

if length(DoubleLobeParam)==3
    % Single lobe fuselage section
    RCar     = 0.5;
    N1Car    = DoubleLobeParam(1);
    N2Car    = DoubleLobeParam(2);
    CoeffCar = DoubleLobeParam(3);
elseif length(DoubleLobeParam)==8
    % Double lobe fuselage section
    RCar     = DoubleLobeParam(1);
    N1Car    = DoubleLobeParam(2);
    N2Car    = DoubleLobeParam(3);
    CoeffCar = DoubleLobeParam(4);
    RPax     = DoubleLobeParam(5);
    N1Pax    = DoubleLobeParam(6);
    N2Pax    = DoubleLobeParam(7);
    CoeffPax = DoubleLobeParam(8);
else
    error('Doublelobebasic requires either 3 or 8 class function parameters');
end
    
    
% Any variables out of bounds?
OOB = 0;

% Cargo lobe range checks
if RCar < 0 || RCar > 0.5
    warning('Cargo lobe radius out of bounds. Resetting to 0.5.'); %#ok<WNTAG>
    RCar = 0.5; OOB = 1;
end
if N1Car < 0 
    warning('N1CAR out of bounds. Resetting to 0.001.'); %#ok<WNTAG>
    N1Car = 0.001;
    OOB = 1;
end
if N2Car < 0 
    warning('N2CAR out of bounds. Resetting to 0.001.'); %#ok<WNTAG>
    N2Car = 0.001;
    OOB = 1;
end

% Passenger lobe range checks
if exist('RPax','var')
    if RPax < 0 || RPax > 0.5
        warning('Passenger lobe radius out of bounds. Resetting to 0.5.'); %#ok<WNTAG>
        RPax = 0.5; OOB = 1;
    end
    if N1Pax < 0 
        warning('N1Pax out of bounds. Resetting to 0.001.'); %#ok<WNTAG>
        N1Pax = 0.001;
        OOB = 1;
    end
    if N2Pax < 0 
        warning('N2Pax out of bounds. Resetting to 0.001.'); %#ok<WNTAG>
        N2Pax = 0.001;
        OOB = 1;
    end
end
        

% The centre of the cargo lobe
% (along the vertical - Z - axis)
CentreCar = RCar;

% The centre of the passenger lobe
% (along the vertical - Z - axis)
if exist('RPax','var')
    CentrePax = 1-RPax;
end


% Locate place of cargo lobe end point along Z and
% make sure it is actually included (move nearest if not)
iCar = 1; while Z(iCar) < 2*RCar, iCar = iCar + 1; end
if AlterZ==1
    if iCar > 1 && Z(iCar)-2*RCar > 2*RCar - Z(iCar-1)
        Z(iCar-1) =  2*RCar;
        iCar = iCar-1;
    else
            Z(iCar) =  2*RCar;
    end
else
    iCar = iCar -1;
end
% iCar is now the index of the endpoint of the cargo lobe

if exist('RPax','var')
    % Locate place of passenger lobe start point along Z and
    % make sure it is actually included (move nearest if not)
    iPax = 1;while Z(iPax) < 1-2*RPax, iPax = iPax + 1; end
    if AlterZ==1
        if iPax > 1 && Z(iPax)-(1-2*RPax) > 1-2*RPax - Z(iCar-1)
            Z(iPax-1) =  1-2*RPax;
            iPax = iPax - 1;
        else
            Z(iPax) =  1-2*RPax;
        end
    end
    % iPax is now the index of the first point of the pax lobe
end    
    
    
% The cargo lobe curve ==========================================
YCar = CoeffCar*...
    basicclassfun(Z(1:iCar), N1Car, N2Car, 0, 2*CentreCar);
YCar = real([YCar, zeros(1,length(Z)-iCar)]);

% The pax lobe curve =============================================
if exist('RPax','var')
    YPax = CoeffPax*...
        basicclassfun(Z(iPax:end), N1Pax, N2Pax, 2*CentrePax-1, 1);
    YPax = real([zeros(1,iPax-1), YPax]);
else
    YPax = zeros(size(YCar));
end


% The tangent ====================================================
YTan = zeros(size(YCar));
if exist('RPax','var') && ~isempty(COMTANON) && COMTANON==1
    YTan = commontangent(Z, YCar, YPax);
end
% ================================================================

% The complete class function
Y = max([YCar;YPax;YTan]);


% Computing the cross-sectional area of the section
CrossSectArea = trapz(Z,Y);


% Plot
if PlotRequired==1
    h = axes;set(h,'FontSize',12);
    hold on
    plot(YCar,Z,'k--','LineWidth',2);
    plot(YPax,Z,'k:','LineWidth',2);
    
    if COMTANON~=0
        ZShort = Z; YTanShort = YTan;
        while YTanShort(1)==0
            YTanShort(1)=[]; ZShort(1)=[];
        end
        i=1;
        while YTanShort(i)~=0, i=i+1; end
        YTanShort(i:end)=[];
        ZShort(i:end)=[];
        plot(YTanShort, ZShort,'k-.','LineWidth',2)
    end
    
    
    plot(0,CentreCar,'ko','MarkerSize',10,'LineWidth',2)
    if exist('RPax','var')
        plot(0,CentrePax,'k+','MarkerSize',10,'LineWidth',2)
    end
    plot(-Y,Z,'k','LineWidth',2)
    
    if ~isempty(COMTANON) && COMTANON==1
        h=legend('Cargo lobe','Passenger lobe','Common tangent',...
             'Cargo Lobe Center',...
        'Passenger Lobe Center', 'Combined section');
    else
        h=legend('Cargo lobe','Passenger lobe','Cargo Lobe Center',...
        'Passenger Lobe Center', 'Combined section');
    end
    
    set(h,'FontSize',12)
    axis equal
    colormap gray
    patch(-Y,Z,[0.9 0.9 0.9]);    
    
    plot(0,CentreCar,'ko','MarkerSize',10,'LineWidth',2)
    
    if exist('RPax','var')
        plot(0,CentrePax,'k+','MarkerSize',10,'LineWidth',2)
    end
    
    plot(-Y,Z,'k','LineWidth',2)
    ylabel('Z'), xlabel('Y')
    
    [a,b] = max(YCar);
    
    text(a,Z(b),['  N_1^{CAR}=',num2str(N1Car)],'FontSize',12)
    text(a,Z(b)-0.07,['  N_2^{CAR}=',num2str(N2Car)],'FontSize',12)
    text(a,Z(b)-0.12,['  C^{CAR}=',num2str(CoeffCar)],'FontSize',12)
    
    [a,b] = max(YPax);
    
    text(a,Z(b),['  N_1^{PAX}=',num2str(N1Pax)],'FontSize',12)
    text(a,Z(b)-0.07,['  N_2^{PAX}=',num2str(N2Pax)],'FontSize',12)
    text(a,Z(b)-0.12,['  C^{PAX}=',num2str(CoeffPax)],'FontSize',12)
    
    annotation('doublearrow', [0.497 0.497],[0.11+0.815*CentrePax 1-0.075])
    annotation('doublearrow', [0.497 0.497],[0.11 0.11+0.815*CentreCar])
    
    line([-0.05 0],[CentreCar CentreCar])
    line([-0.05 0],[CentrePax CentrePax])
    
    text(-0.075,CentreCar/2-0.075,['R^{CAR}=',num2str(CentreCar)],...
        'Rotation',90,'FontSize',12);
    text(-0.075,CentrePax+RPax/2-0.075,['R^{PAX}=',num2str(RPax)],...
        'Rotation',90,'FontSize',12);
end
