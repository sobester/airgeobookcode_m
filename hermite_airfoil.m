function [upper,lower,req_depth] =...
     hermite_airfoil(tension_upper_nose, tension_lower_nose,...
                        tension_upper_tail, tension_lower_tail,...
                        angle_lower_tail, angle_tail)
%HERMITE_AIRFOIL Parametric airfoil made up of two Ferguson curves.
%
% The INPUTS are the six design variables (suggested ranges in brackets):
% 1  tension_upper_nose [0.1,0.4] |T_A^upper|
% 2  tension_lower_nose [0.1,0.4] |T_A^lower|
% 3  tension_upper_tail [0.1,2] |T_B^upper|
% 4  tension_lower_tail [0.1,2] |T_B^lower|
% 5  angle_lower_tail (deg) [-15,15] alpha_c
% 6  angle_tail (deg) [1,30] alpha_b
%           
% If needed, the two Epsilons could also be added as additional variables.
%
% The OUTPUTS
% upper,lower,camber - vectors containing the upper and lower surfaces of
% the aerofoil and its camber line.
% maxdepth - the maximum depth (thickness) of the aerofoil
%
% EXAMPLE
% =======
%
% Generate a sharp leading edge 'clone' of NACA5410 (see Table 7.1)
%
% tension_upper_nose = 0.1584;
% tension_lower_nose = 0.1565;
% tension_upper_tail = 2.1241;
% tension_lower_tail = 1.8255;
% angle_lower_tail   = 3.827;
% angle_tail         = 11.6983;
% 
% [upper,lower,req_depth] =...
%      hermite_airfoil(tension_upper_nose, tension_lower_nose,...
%                         tension_upper_tail, tension_lower_tail,...
%                         angle_lower_tail, angle_tail);
%                     
% hold on, axis equal                    
% plot(upper(:,1),upper(:,2))
% plot(lower(:,1),lower(:,2))
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------

                    
epsilon_l = 0;
epsilon_u = 0;          

points = 50;

perc_chord_depth_reqd = 25;

divisions = points - 1;

% Make sure all tensions are positive
tension_upper_nose = abs(tension_upper_nose);
tension_lower_nose = abs(tension_lower_nose);
tension_upper_tail = abs(tension_upper_tail);
tension_lower_tail = abs(tension_lower_tail);

% No fishtail condition
if epsilon_l > epsilon_u
    s = epsilon_l;
    epsilon_l = epsilon_u;
    epsilon_u = s;
end


% The components of the tangent of the lower surface at the tail
t_l_x = tension_lower_tail*cos(-angle_lower_tail*pi/180);
t_l_y = tension_lower_tail*sin(-angle_lower_tail*pi/180);


% We make this more dense than the other so that the interpolation
% will be more accurate
lower = hermite([0 0], [1 epsilon_l], tension_lower_nose*[0 -1], [t_l_x,t_l_y], 5*divisions, 0);


% The components of the tangent of the upper surface at the tail
t_u_x = tension_upper_tail*cos((-angle_lower_tail-angle_tail)*pi/180);
t_u_y = tension_upper_tail*sin((-angle_lower_tail-angle_tail)*pi/180);

upper = hermite([0 0], [1 epsilon_u], tension_upper_nose*[0 1], [t_u_x,t_u_y], divisions, 0);


% Now we need to replace the lower surface with a series of points
% with the same abscissas as the ones in the top surface
% via interpolating between known points

for i=2:size(upper,1)-1
	if lower(5*i,1) < upper(i,1)
		j=5*i;
		while lower(j,1)<=upper(i,1)
			j = j+1;
		end
		new_lower(i) = 0.5*(lower(j,2)+lower(j-1,2)); %#ok<AGROW>
	else
		j=5*i;
		while lower(j,1)>=upper(i,1)
			j = j-1;
		end
		new_lower(i) = 0.5*(lower(j,2)+lower(j+1,2)); %#ok<AGROW>
	end
end

new_lower(size(upper,1))=0;

lower=upper;
lower(:,2)=new_lower';

i=1; while upper(i,1) < 0.01*perc_chord_depth_reqd, i=i+1; end
    
req_depth = upper(i,2)-lower(i,2);