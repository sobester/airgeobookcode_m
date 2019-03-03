function [Airfoil, Camber, RLE] = ...
                naca5(DesignLiftCoefficient,...
                      MaxCamberLocFracChord,...
                      MaxThicknessPercChord,...
                      Fidelity,...
                      N,...
                      PlotReq)
                  
%NACA5 Generates (and plots) a NACA 5-digit airfoil coordinate set.
%
%   NACA5(DesignLiftCoefficient,...
%         MaxCamberLocFracChord,...
%         MaxThicknessPercChord,...
%         Fidelity, N, PlotReq)
%   generates a NACA 5-digit airfoil, following the standard Jacobs and
%   Pinkerton formulation, as discussed in Sct.6.2 of Sobester & Forrester
%   (2014). The first three inputs are c_l^design, x_mc and t_max. These 
%   should be followed by:
%       Fidelity - can be 'Low' or 'High'. If 'Low', the abscissa is
%                  sampled uniformly, if 'High', an optimization algorithm
%                  re-distributes the points such that the airfoil curve
%                  itself is sampled uniformly. This takes longer, but
%                  yields a much nicer data set.
%       N - number of points required.
%       PlotReq - is the airfoil to be plotted? Set to 0 if not, set to 1
%       if a simple diagram is required (like Figure 6.7 in the book
%       referenced below).
%
%   Example
%   =======
%   This will generate Figure 6.7 from Sobester and Forrester (2014), 
%   depicting NACA23012:
%   naca5(0.3, 0.15, 12, 'High', 100, 1)
%   
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------
           
if strcmpi(Fidelity, 'Low')
    % The quick way - uniform sampling of x
    x = (0:1/(N-1):1);
    t = naca4halfthickness(x); % Same thickness as the 4-digit
else
    % The uniform way: uniform sampling of the thickness curve
    % as the basis for the final airfoil coordinates
    % (same as the NACA 4-digit).
    [x,t] = divideexplicit(@naca4halfthickness, 0, 1, N);
end

[zcam,Th] = naca5cambercurve(x);

xu =    x(:) - t(:).*sin(Th(:));
zu = zcam(:) + t(:).*cos(Th(:));
xl =    x(:) + t(:).*sin(Th(:));
zl = zcam(:) - t(:).*cos(Th(:));

RLE = 1.1019*(MaxThicknessPercChord/100)^2;


% Scale the airfoil to unit chord to eliminate any tiny stretching that may
% have occured as a result of cambering the uniformly sampled curves
ScaleFactor_u = 1/xu(end);
xu = xu*ScaleFactor_u;
zu = zu*ScaleFactor_u;
ScaleFactor_l = 1/xl(end);
xl = xl*ScaleFactor_l;
zl = zl*ScaleFactor_l;


if PlotReq, plotnaca5, end

Airfoil{1} = xu;
Airfoil{2} = zu;
Airfoil{3} = xl;
Airfoil{4} = zl;
Camber{1}  = x;
Camber{2}  = zcam;




    function t = naca4halfthickness(x)
        % Internal function.
        % Given  a set of abscissas and  a  maximum thickness value
        % (expressed in units of chord) it computes the NACA 4-digit
        % half-thickness distribution.  The abscissas must be in the
        % range [0,1].
        
        if max(x)>1 || min(x)<0
            error('Ordinates out of range.')
        end
        
        % Max thickness in units of chord
        tmax = MaxThicknessPercChord / 100;
        
        % Half-thickness polynomial
        t = tmax*(1.4845*x.^(1/2)...
            - 0.63*x ...
            - 1.758*x.^2 ...
            + 1.4215*x.^3 ...
            - 0.5075*x.^4);
    
    end % function naca4halfthickness



    function [zcam, Theta] = naca5cambercurve(x)
        % Internal function.
        % Given a set of abscissas,   a design lift coefficient and a max
        % camber location  (expressed in units of chord)  computes the 
        % NACA 5-digit camber curve. The abscissas must be in the range [0,1].
        
        if max(x)>1 || min(x)<0
            error('Ordinates out of range.')
        end
        
        % The abscissa of the maximum camber point
        xmc     = MaxCamberLocFracChord;
               
        % Determine the transition point m that separates the polynomial
        % forward section from the linear aft section
        C = [1 -3 6*xmc -3*xmc^2];
        R = roots(C); m = R(2);
        
        % Locate maximum camber ordinate in x vector
        i=1; while x(i) < m, i=i+1; end, i = i-1; 

        
        % As per equation (A-13) in Bill Mason's Geometry for
        % Aerodynamicists
        QQ=(3*m-7*m^2+8*m^3-4*m^4) / (sqrt(m*(1-m))) - 3/2*(1-2*m)*...
            (pi/2-asin(1-2*m));
        
        k1=6*DesignLiftCoefficient/QQ;
        
        % The two sections of the camber curve
        zcam(1:i)   = (1/6)*k1*(x(1:i).^3 - 3*m*x(1:i).^2 + m^2*(3-m)*x(1:i));
        zcam(i+1:N) = (1/6)*k1*m^3*(1-x(i+1:N)); 
               
        
        % The slope of the camber curve
        dzcamdx(1:i)   = (1/6)*k1*(3*x(1:i).^2-6*m*x(1:i)+m^2*(3-m));
        dzcamdx(i+1:N) = -(1/6)*m^3;
        
        Theta = atan(dzcamdx);
        
        zcam = zcam(:);
        Theta = Theta(:);

    end % function naca5cambercurve




    function plotnaca5
        plot(x,zcam,'-.','LineWidth',3,'Color',[0.65 0.65 0.65])
        hold on
        plot(xu,zu,'k-','LineWidth',1.5,'Color',[0 0 0])
        plot(xl,zl,'k-','LineWidth',1.5,'Color',[0.5 0.5 0.5])
        plot([0 1],[0 0],'k-')
        legend('Camber curve','Upper surface','Lower surface','Chord')
        set(gca,'FontSize',12)
        xlabel('x')
        ylabel('z')
        axis equal
        % The five digits     
        
        d1 = num2str((2/3)*DesignLiftCoefficient*10);
        d2 = num2str(2*MaxCamberLocFracChord*10);
        d3 = '0';
        d4 = num2str(MaxThicknessPercChord);
        if length(d1)==1 && length(d2)==1 && length(d3)==1  && length(d4)==2
            title(['NACA ',d1,d2,d3,d4])
        else
            title(['NACA5: ',...
                     'c_l^{design} = ', num2str(DesignLiftCoefficient),...
                   '  x_{mc} = '      , num2str(MaxCamberLocFracChord),...
                   '  t_{max} = '     , num2str(MaxThicknessPercChord),'%']);
        end
    end % function plotnaca5


end % function naca5