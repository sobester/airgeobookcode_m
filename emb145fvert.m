function [Upper, Lower] = emb145fvert(x)
% Upper and lower fuselage line of an airliner similat to the ERJ145
% (in the vertical plane). True scale in meters (fuselage 28m long)

if max(x) > 28 || min(x) < 0
    error('Lengthwise station out of bounds');
end

UpperPoints1 = ...
[0    3.5
 7.137e-001               3.82835820895522e+000
 1.40638791286015e+000    4.02985074626866e+000
 2.01512297962052e+000    4.17377398720682e+000
 2.46                     4.27];
 
 UpperPoints2 = ...
 [3.086                   4.58
 3.58943780744905e+000    4.74946695095949e+000
 4.11                     4.82];

UpperPoints3 = ...
 [22.7                    4.82
 2.57977723120169e+001    4.69189765458422e+000
 2.67843429374561e+001    4.59115138592751e+000
 2.78338861560084e+001    4.46162046908316e+000];


for i=1:length(x)
    if x(i)<2.46
        Upper(i) = spline(UpperPoints1(:,1),UpperPoints1(:,2),x(i)); %#ok<*AGROW>
    elseif x(i)<3.086
        % Windscreen line from   (2.46,4.27) to (3.086,4.58)
        px = [2.46 3.086]; py = [4.27 4.58];
        Upper(i) = interp1(px,py,x(i));
    elseif x(i)<4.11
        Upper(i) = spline(UpperPoints2(:,1),UpperPoints2(:,2),x(i));
    elseif x(i)<22.7
        Upper(i) = 4.82;
    else
        Upper(i) = spline(UpperPoints3(:,1),UpperPoints3(:,2),x(i));
    end
end



LowerPoints1 = ...
 [ 0.00000000000000e+000    3.5
 7.13689388615601e-001    3.33901918976546e+000
 1.42737877723120e+000    3.28144989339019e+000
 1.78422347153900e+000    3.26705756929638e+000
 2.41                      3.2527];

LowerPoints2 = ...
 [10.41	3.2527
11.8202	3.0959
13.0353	2.9776
14.5443	2.9216
16.9466	2.9504
18.367	3.0656
19.8364	3.2095
20.51	3.2527];

LowerPoints3 = ...
[22.35	3.2527
23.6987	3.3246
24.3704	3.411
25.231	3.5549
26.0916	3.742
26.9523	3.9723
27.9178	4.2745];

for i=1:length(x)
    if x(i)<2.41
        Lower(i) = spline(LowerPoints1(:,1),LowerPoints1(:,2),x(i));
    elseif x(i)<10.41
        Lower(i) = 3.2527;
    elseif x(i)<20.51
        Lower(i) = spline(LowerPoints2(:,1),LowerPoints2(:,2),x(i));
    elseif x(i)<22.35
        Lower(i) = 3.2527;
    else
        Lower(i) = spline(LowerPoints3(:,1),LowerPoints3(:,2),x(i));
    end
end