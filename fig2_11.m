% This script generates a fuselage geometry similar to that of the ERJ145,
% as shown in Fig. 2.11. You will need to zoom in on and rotate the
% resulting image to get the same plot as in the book.
% -------------------------------------------------------------------------
% Aircraft Geometry Toolbox v0.1.0, Andras Sobester 2014.
%
% Sobester, A, Forrester, A I J F, "Aircraft Aerodynamic Design - Geometry 
% and Optimization", Wiley, 2014.
% -------------------------------------------------------------------------


CFP = [];

% Baseline value for class function parameters
DoubleLobeParam =...
    [0.5   0.5   0.5   0    0.5  0.5   0.5    1 ]; 
   %[RCAR N1CAR N2CAR CCAR RPAX N1PAX N2PAX CPAX];
   
CFPLabels = {'R^{CAR}', 'N_1^{CAR}','N_2^{CAR}','C^{CAR}',...
    'R^{PAX}', 'N_1^{PAX}','N_2^{PAX}','C^{PAX}'};
   
% Changes at the radome section
%   [ -    -      -     -    -    0.43   -  1.3  ];
% Changing from baseline at station 4.1m to this at 0.7m


axis equal
hold on

FX = [];
FY = [];
FZ = [];

frames = 0;

for x = 0.1:1:27.8

frames = frames + 1;

DoubleLobeParam =...
    [0.5   0.5   0.5   0    0.5  0.5   0.5    1 ]; 
   %[RCAR N1CAR N2CAR CCAR RPAX N1PAX N2PAX CPAX];
   
 
    [Up, Lo] = emb145fvert(x);
    
    if x < 1
        DoubleLobeParam(6) = 0.43;
        DoubleLobeParam(8) = 1.3;
    end
    
    if x >= 1 && x < 4.1
        s1 = [1 4.1]; s2 = [0.43 0.5];
        DoubleLobeParam(6) = interp1(s1,s2,x);
        s1 = [1 4.1]; s2 = [1.3 1];
        DoubleLobeParam(8) = interp1(s1,s2,x);
    end
    
    
    if x > 10 && x < 20.8
        DoubleLobeParam(1) = 0.4;
        DoubleLobeParam(5) = 0.5*(1.5673/(Up-Lo));
        s1 = [1.5673 1.9065]; s2 = [0.4 0.12];
        DoubleLobeParam(2) = interp1(s1,s2,min([Up-Lo,1.9065]));
        DoubleLobeParam(4) = 0.65;
    end
        
    
    CFP = [CFP; [DoubleLobeParam x]]; %#ok<*AGROW>
    
    
    [Y, Z, YCar, YPax, OOB] = ...
        doublelobebasic(fillz(150),DoubleLobeParam,0,0);
       
    z = Z*(Up-Lo)+Lo;
    y = Y*(Up-Lo);
    xx= ones(size(Z))*x;
    
    if floor(frames/5)==frames/5
     plot3(xx,y,z,'w','LineWidth',1.5)
     plot3(xx,-y,z,'w','LineWidth',1.5)
    end
    
    FX = [FX;xx];
    FY = [FY;y];
    FZ = [FZ;z];

end


% Now plot the actual surface of the fuselage, one side at a time
colormap gray
surf(FX,FY,FZ,ones(size(FZ)))
surf(FX,-FY,FZ,ones(size(FZ)))


xlabel('x')
ylabel('y')
zlabel('z')

shading interp

% Remove CARGO parameter values where CCAR=0
for i=1:size(CFP,1)
    if CFP(i,4)==0
        CFP(i,1:3)=NaN; %#ok<*SAGROW>
    end
end


hold on
axis off

symbols = {'-','-.',':','--','-','-.',':','--'};

for i=1:4
    plot3(CFP(:,end),3*i*ones(size(CFP(:,i)))-1, 5*CFP(:,i),symbols{i},'LineWidth',2)
    j=1;while isnan(CFP(j,i)), j = j+1; end

    h = text(CFP(j,end),3*i*ones(size(CFP(j,i)))-1,5*CFP(j,i),CFPLabels{i});
    set(h,'FontWeight','bold')
    
    
    %Find the first not-NaN from the back
    k = size(CFP,1); while isnan(CFP(k,i)) k=k-1; end
    
    h = text(CFP(k,end)+1,3*i*ones(size(CFP(k,i)))-1,5*CFP(k,i),num2str(CFP(k,i)));
    set(h,'FontWeight','bold')
    
    
    
    if i==2
    %Label the minima
    [a,b]=min(CFP(:,i));
    h = text(CFP(b,end),3*i-1,5*a,num2str(a));
    set(h,'FontWeight','bold');
    end
    
    
    if i==4
    %Label the maxima
    [a,b]=max(CFP(:,i));
    h = text(CFP(b,end),3*i-1,5*a,num2str(a));
    set(h,'FontWeight','bold');
    end
    
end




for i=5:8
    plot3(CFP(:,end),-(2*i*ones(size(CFP(:,i)))-2*4)-3, 5*CFP(:,i),symbols{i},'LineWidth',2)
    j=1;while isnan(CFP(j,i)), j = j+1; end

    h = text(CFP(j,end),-(2*i*ones(size(CFP(j,i)))-2*4)-3,5*CFP(j,i),CFPLabels{i});
    set(h,'FontWeight','bold')
    
    
    %Find the first not-NaN from the back
    k = size(CFP,1); while isnan(CFP(k,i)) k=k-1; end
    
    h = text(CFP(k,end)+1,-(2*i*ones(size(CFP(k,i)))-2*4)-3,5*CFP(k,i),num2str(CFP(k,i)));
    set(h,'FontWeight','bold')
    
    if i==5 || i==6
    [a,b]=min(CFP(:,i));
    h = text(CFP(b,end),-(2*i-2*4)-3,5*a,num2str(   round(a*100)/100  ));
    set(h,'FontWeight','bold');
    end
    
    
    if i==8
    [a,b]=max(CFP(:,i));
    h = text(CFP(b,end),-(2*i-2*4)-3,5*a,num2str(   round(a*100)/100  ));
    set(h,'FontWeight','bold');
    end
end

