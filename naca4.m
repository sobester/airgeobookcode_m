function [Airfoil, Camber, RLE] = ...
                naca4(MaxCamberPercChord,...
                      MaxCamberLocTenthChord,...
                      MaxThicknessPercChord,...
                      Fidelity,...
                      N,...
                      PlotReq)

%NACA4 Generates (and plots) a NACA 4-digit airfoil coordinate set.
%
%   NACA4(MaxCamberPercChord,...
%         MaxCamberLocTenthChord,...
%         MaxThicknessPercChord,...
%         Fidelity, N, PlotReq)
%   generates a NACA 4-digit airfoil, following the standard Jacobs et al
%   formulation, as discussed in Ch.6 of Sobester and Forrester (2014).
%   The first three inputs are basically the NACA digits. These should be
%   followed by:
%       Fidelity - can be 'Low' or 'High'. If 'Low', the abscissa is
%                  sampled uniformly, if 'High', an optimization algorithm
%                  re-distributes the points such that the airfoil curve
%                  itself is sampled uniformly. This takes longer, but
%                  yields a much nicer data set.
%       N - number of points required.
%       PlotReq - is the airfoil to be plotted? Set to 0 if not, set to 1
%       if a simple diagram is required and set to 2 if you would like a
%       slightly more elaborate plot, like Figure 6.1 in the book
%       referenced below.
%
%   Example
%   =======
%   This will generate Figure 6.1 from Sobester and Forrester (2014):
%   naca4(6, 5, 21, 'High', 100, 2)
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
    t = naca4halfthickness(x);
else
    % The uniform way: uniform sampling of the thickness curve
    % as the basis for the final airfoil coordinates
    [x,t] = divideexplicit(@naca4halfthickness, 0, 1, N);
end

[zcam,Th] = naca4cambercurve(x);

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


if PlotReq, plotnaca4, end

Airfoil{1} = xu;
Airfoil{2} = zu;
Airfoil{3} = xl;
Airfoil{4} = zl;
Camber{1}  = x;
Camber{2}  = zcam;




    function t = naca4halfthickness(x)
        % Internal function.
        % Given  a set of ordinates  and  a  maximum thickness value
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



    function [zcam, Theta] = naca4cambercurve(x)
        % Internal function.
        % Given a set of ordinates,  a maximum camber value and a max
        % camber location  (expressed in units of chord) computes the camber 
        % curve (mean line) of a NACA 4-digit airfoil. The abscissas must
        % be in the range [0,1].
        
        if max(x)>1 || min(x)<0
            error('Ordinates out of range.')
        end
        
        % Using the original notation of Jacobs et al.(1933)...
        xmc     = MaxCamberLocTenthChord/10;
        zcammax = MaxCamberPercChord   /100;
        
        % Locate maximum camber ordinate in x vector
        i=1; while x(i)<xmc,i=i+1; end, i = i-1; 
        
        zcam(1:i)   = (zcammax/xmc^2)    *(2*xmc*x(1:i) - x(1:i).^2);
        zcam(i+1:N) = (zcammax/(1-xmc)^2)*(1-2*xmc+2*xmc*x(i+1:N)-x(i+1:N).^2);   
        
        % The slope of the camber curve
        dzcamdx(1:i)   = (zcammax/xmc^2)    *(2*xmc - 2*x(1:i));
        dzcamdx(i+1:N) = (zcammax/(1-xmc)^2)*(2*xmc - 2*x(i+1:N));
        
        Theta = atan(dzcamdx);
        
        zcam = zcam(:);
        Theta = Theta(:);

    end % function naca4cambercurve




    function plotnaca4
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
        % The four digits
        d1 = num2str(MaxCamberPercChord);
        d2 = num2str(MaxCamberLocTenthChord);
        d3 = num2str(MaxThicknessPercChord);
        if length(d1)==1 && length(d2)==1 && length(d3)==2
            title(['NACA ',d1,d2,d3])
        else
            title(['Max. camber: ',d1,'% chord   Max. camber loc.: ',d2,...
                '/10 chord   Max. thickness: ',d3,'% chord'])
        end
        if PlotReq==2
            % To generate a sketch like Figure 6.1 from Sobester and Forrester
            % (2014)
            % A normal to the chord
            NormPoint = round(0.3*N);
            TextPoint = round(0.5*N);
            plot([x(NormPoint)  xu(NormPoint)],   [zcam(NormPoint) zu(NormPoint)],'k:','LineWidth',3)
            plot(x(NormPoint),zcam(NormPoint),'ko','MarkerSize',5)
            plot(xu(NormPoint),zu(NormPoint),'ko','MarkerSize',5)
            plot(xl(NormPoint),zl(NormPoint),'ko','MarkerSize',5)
            text(xu(NormPoint)-0.08,zu(NormPoint)+0.04,'[ x^u(x), z^u(x) ]','FontSize',12)
            text(xl(NormPoint)-0.07,zl(NormPoint)-0.04,'[ x^l(x), z^l(x) ]','FontSize',12)
            plot([x(NormPoint)  xl(NormPoint)],   [zcam(NormPoint) zl(NormPoint)],':','Color',[0.5 0.5 0.5],'LineWidth',3)
            text(x(NormPoint)+0.012,zcam(NormPoint)+0.06,'t(x)','FontSize',14,'Rotation',6)
            text(x(NormPoint)+0.027,zcam(NormPoint)-0.043,'-t(x)','FontSize',14,'Color',[0.5 0.5 0.5],'Rotation',6,'BackgroundColor',[1 1 1])
            plot([x(NormPoint) x(NormPoint)],[zcam(NormPoint) 0],'k')
            text(x(NormPoint)-0.015,-0.015,'x','FontSize',12)
            axis([0 1 -0.2 0.4])
            text(x(TextPoint),zcam(TextPoint)+0.025,'z_{cam}','FontSize',12,'Color',[0.5 0.5 0.5])
        end
        
    end % function plotnaca4


end % function naca4