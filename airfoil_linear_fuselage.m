function Airfoils = airfoil_linear_fuselage(AirfoilParameters, Epsilon, NP, Fidelity)
%AIRFOIL_LINEAR Generate airfoils linearly varying from root to tip.
%   Returns the airfoil corresponding to a linear variation of airfoil
%   shape between a given root and tip airfoil. Use this as a template for
%   user-defined dihedral functions.
%   INPUTS: AirfoilParameters - cell array, containing airfoil type and the
%           parameters describing that particular type.
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%           NP - number of points defining the shape of the airfoil
%           Fidelity - the calculation fidelity required (typically defines
%           the way in which points defining an airfoil are re-distributed)
%   OUTPUT: Airfoil - cell array (same length as Epsilon) of lifting surface
%           sections, each of the form {xu, xu, xl, zl}


if length(AirfoilParameters)>=6
    RootFilletRatio = AirfoilParameters{5};
    RootFilletMax = AirfoilParameters{6};
elseif length(AirfoilParameters)==2
    AirfoilParameters{3} = AirfoilParameters{1};
    AirfoilParameters{4} = AirfoilParameters{2};
elseif length(AirfoilParameters)~=4
    warning('Failed to generate airfoils - insuficient number of parameters') %#ok<WNTAG>
    Airfoils = {};
end


if strcmpi(Fidelity,'low')
    % Test the airfoil functions with a low fidelity run. This is to make sure
    % that we find out if the low fidelity version of the function is only able
    % to produce a specific number of points
    RootAirfoil = airfoilgen(AirfoilParameters{1}, 'Low', NP, AirfoilParameters(2));
    xuRoot = cell2mat(RootAirfoil(1));
    NRoot = length(xuRoot);
    TipAirfoil  = airfoilgen(AirfoilParameters{3}, 'Low', NP, AirfoilParameters(4));
    xuTip  = cell2mat(TipAirfoil(1));
    NTip = length(xuTip);
    
    if NTip == NRoot
        % They both respond with the same number of points when asked for
        % NP (though this may not necessarily be NP)
        RootAirfoil = airfoilgen(AirfoilParameters{1}, Fidelity, NP, AirfoilParameters(2));
        TipAirfoil  = airfoilgen(AirfoilParameters{3}, Fidelity, NP, AirfoilParameters(4));
    else
        if (NRoot ~= NP) && (NTip == NP)
            % Looks like the root airfoil cannot do NP, so the tip airfoil
            % will have to do whatever number the root airfoil can do
            RootAirfoil = airfoilgen(AirfoilParameters{1}, Fidelity, NRoot, AirfoilParameters(2));
            TipAirfoil  = airfoilgen(AirfoilParameters{3}, Fidelity, NRoot, AirfoilParameters(4));
        elseif (NTip ~= NP) && (NRoot == NP)
            % Looks like the tip airfoil cannot do NP, so the root airfoil
            % will have to do whatever number the tip airfoil can do
            RootAirfoil = airfoilgen(AirfoilParameters{1}, Fidelity, NTip, AirfoilParameters(2));
            TipAirfoil  = airfoilgen(AirfoilParameters{3}, Fidelity, NTip, AirfoilParameters(4));
        else
            % Neither airfoil can do NP and they respond with different
            % numbers of points - the only solution is to switch to high
            % fidelity - this might be expensive though
            warning(['Airfoil function(s) unable to return required number of points ',...
                'Using high fidelity (potentially expensive) airfoil computation instead']); %#ok<WNTAG>
            RootAirfoil = airfoilgen(AirfoilParameters{1}, 'High', NP, AirfoilParameters(2));
            TipAirfoil  = airfoilgen(AirfoilParameters{3}, 'High', NP, AirfoilParameters(4));
        end
    end
else
    
    
    RootAirfoil = airfoilgen(AirfoilParameters{1}, 'High', NP, AirfoilParameters(2));
    TipAirfoil  = airfoilgen(AirfoilParameters{3}, 'High', NP, AirfoilParameters(4));
    
end

xuRoot = cell2mat(RootAirfoil(1));
zuRoot = cell2mat(RootAirfoil(2));
xlRoot = cell2mat(RootAirfoil(3));
zlRoot = cell2mat(RootAirfoil(4));

xuTip  = cell2mat(TipAirfoil(1));
zuTip  = cell2mat(TipAirfoil(2));
xlTip  = cell2mat(TipAirfoil(3));
zlTip  = cell2mat(TipAirfoil(4));


if length(xuRoot)==length(xuTip)
    
    if exist('RootFilletRatio','var') && RootFilletRatio > 0
    ko = 0.06; ki = 0.003;
    zuRFRmax = max((1-RootFilletRatio)*zuRoot + RootFilletRatio*zuTip);
    zuRFRmaxko = max((1-RootFilletRatio-ko)*zuRoot + (RootFilletRatio-ko)*zuTip);
    zuRootmax = max(zuRoot);
    zuRFRmaxki = max((1-ki)*zuRoot + ki*zuTip);
    end
    
    for i=1:length(Epsilon)
        
        xu = (1-Epsilon(i))*xuRoot + Epsilon(i)*xuTip;
        zu = (1-Epsilon(i))*zuRoot + Epsilon(i)*zuTip;
        xl = (1-Epsilon(i))*xlRoot + Epsilon(i)*xlTip;
        zl = (1-Epsilon(i))*zlRoot + Epsilon(i)*zlTip;
        
        
        % If a root blend is required, scale the airfoils near the root in the z direction
        if exist('RootFilletRatio','var') && RootFilletRatio > 0
            if Epsilon(i) < RootFilletRatio
                
                zs = [zuRootmax + RootFilletMax, zuRFRmaxki + RootFilletMax, zuRFRmaxko, zuRFRmax];
                epsilons = [0 ki RootFilletRatio-ko RootFilletRatio];
                
                TargetMaxz = pchip(epsilons, zs, Epsilon(i));
                
                %AddThickness = 1+((RootFilletRatio - Epsilon(i))/RootFilletRatio).^2*RootFilletMax;
                
                zm = max(zu);
                
                zu = zu*TargetMaxz/zm;
                
                %zl = zl*AddThickness;
                
            end
        end
        % ===== end of root blend =============================
        
        
        Airfoils{i} = {xu zu xl zl}; %#ok<AGROW>
    end
    
else
    warning('Failed to generate airfoils with matching number of root and tip points.') %#ok<WNTAG>
    Airfoils = {};
end



