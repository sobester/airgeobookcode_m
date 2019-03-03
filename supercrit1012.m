function Airfoil = supercrit1012(CL,TC,Fidelity,NP)
% SUPERCRIT1012 Supercritical airfoils with given CL (in [10,12] and t/c
% (in [0.4 0.7). For the background and details of the mathematical 
% formulation, see Sobester, Andras and Powell, Stephen (2013) "Design space
% dimensionality reduction through physics-based geometry re-parameterization", 
% Optimization and Engineering, 14, (1), 37-59. (doi:10.1007/s11081-012-9189-z).
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


load supercrit1012.mat

if CL < ml || CL > Ml+0.01 || TC < mt || TC > Mt
    warning(['CL or t/c out of range for parametric supercritical airfoil,'...
        '- using nearest existing SC(2) airfoil instead']); %#ok<WNTAG>
    Airfoil = nearestsc2(CL,TC, Fidelity, NP);
else
    % FOR A GIVEN T/C ONLY THE CAMBER LINE CHANGES
    % [v0 v1 ..... vLE]
    % Simply scale up linearly to the required thickness
    half_thickness_coeffs = half_thickness_coeffs10 + (half_thickness_coeffs12-half_thickness_coeffs10)*((TC-mt)/(Mt-mt));
    
    % NOW PREDICT CAMBER LINE
    % Predict vector C = [camber_coeffs, zTElower]
    for i=1:length(ModelInfos)
        ModelInfo = ModelInfos(i);
        ModelInfo.Option='Pred';
        to_predict_cl = (CL-ml)/(Ml-ml);
        to_predict_tc = (TC-mt)/(Mt-mt);
        C(i) = MinY(i)+regpredictor([to_predict_cl, to_predict_tc])*(MaxY(i)-MinY(i)); %#ok<AGROW>
    end
    camber_coeffs = C(1:end-1);
    
    % **** FINAL COEFFICIENTS **************************
    upper_coeffs = camber_coeffs + half_thickness_coeffs;
    lower_coeffs = camber_coeffs - half_thickness_coeffs;
    LEtermu = upper_coeffs(end);
    upper_coeffs(end)=[];
    LEterml = lower_coeffs(end);
    lower_coeffs(end)=[];
    
    % ALL UPPER TRAILING EDGES ZERO
    zTEupper = 0;
    zTElower = C(end);
    
    Airfoil = airfoilgen('cst', Fidelity, NP, [upper_coeffs(:)', zTEupper, LEtermu],...
        [lower_coeffs(:)', zTElower, LEterml], 1);
    
end