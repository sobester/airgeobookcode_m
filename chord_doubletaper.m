function Chord = chord_doubletaper(ChordParameters, Epsilon)
%CHORD_DOUBLETAPER Generate chords for doubly tapered lifting surface.
%   Returns linearly varying chord lengths as needed for two sections of
%   different tapers.
%   INPUTS: ChordParameters - [Taper Ratio 1, Taper Ratio 2, Kink Station ]
%           (e.g., 0.9, 0.3, 0.4; Taper Ratio 1 up to the spanwise station
%           where the kink is, then a different taper ratio.)
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: Chord - vector (same length as Epsilon) of chord lengths.


TaperRatio1 = ChordParameters(1);
TaperRatio2 = ChordParameters(2);
KinkStation = ChordParameters(3);


for i=1:length(Epsilon)
    if Epsilon(i) < KinkStation
        Chord(i) = TaperRatio1 +...
            (1-TaperRatio1)*(KinkStation-Epsilon(i))/KinkStation; %#ok<*AGROW>
    else
            Chord(i) = TaperRatio1*(1-TaperRatio2)*(1-Epsilon(i))/...
                (1-KinkStation) + TaperRatio1*TaperRatio2;
    end
end
            
