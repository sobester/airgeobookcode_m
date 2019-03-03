function YTan = commontangent(Z, YCar, YPax)
% Generates a common tangent to the lobes YCar and YPax
% and returns its values at the locations defined by Z
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


% Locate the point where the passenger lobe takes over
iCross = 2;
while YCar(iCross) > YPax(iCross), iCross = iCross + 1; end

dmin = 1e10;
for iCar = 2:iCross-1
    for iPax = iCross:length(YPax)-1
        % Putative tangent: 
        % from [Z(iCar) YCar(iCar)]
        %   to [Z(iPax) YPax(iPax)]
        ComTanSlope = (YPax(iPax) - YCar(iCar))/...
                        (Z(iPax) -   Z(iCar));

        CarSlopeUp = (YCar(iCar+1) - YCar(iCar))/...
                       (Z(iCar+1) -   Z(iCar));
        CarSlopeDn = (YCar(iCar) -   YCar(iCar-1))/...
                       (Z(iCar) -   Z(iCar-1));
        CarSlope = 0.5*(CarSlopeUp + CarSlopeDn);
                    
        
        PaxSlopeUp = (YPax(iPax+1) - YPax(iPax))/...
                       (Z(iPax+1) -   Z(iPax));
        PaxSlopeDn = (YPax(iPax) -   YPax(iPax-1))/...
                       (Z(iPax) -   Z(iPax-1));

                   
        PaxSlope = 0.5*(PaxSlopeUp + PaxSlopeDn);
                    
        d = abs(CarSlope - ComTanSlope) + abs(PaxSlope - ComTanSlope);
        
        if d < dmin
            dmin = d;
            iCarMin = iCar;
            iPaxMin = iPax;
        end
    end
end

if exist('iPaxMin','var')
    % Final tangent: 
    % from [Z(iCarMin) YCar(iCarMin)]
    %   to [Z(iPaxMin) YPax(iPaxMin)]
    ComTanSlope = (YPax(iPaxMin) - YCar(iCarMin))/...
               (Z(iPaxMin) -   Z(iCarMin));
    ComTanIntercept =  YCar(iCarMin) - ComTanSlope*Z(iCarMin);        
           
    YTan = zeros(1,iCarMin-1);
    
    for i = iCarMin:iPaxMin
        TanPoint = ComTanSlope*Z(i) + ComTanIntercept;
        YTan = [YTan, TanPoint]; %#ok<AGROW>
    end
    YTan = [YTan,zeros(1,length(Z)-length(YTan))];    
else
    YTan = zeros(size(Z));
end