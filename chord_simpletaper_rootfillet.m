function Chord = chord_simpletaper_rootfillet(ChordParameters, Epsilon)
%CHORD_SIMPLETAPER Generate chords for simply tapered wing.
%   Returns linearly varying chord lengths as needed for a simple taper.
%   INPUTS: ChordParameters - [Taper Ratio]
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: Chord - vector (same length as Epsilon) of chord lengths.

TaperRatio = ChordParameters(1);
RootAftFilletRatio = ChordParameters(2);
RootAftFilletAmplitude = ChordParameters(3);

BaselineChord = 1- Epsilon*(1-TaperRatio);


% Baseline chord
Chord = BaselineChord;
BaseEpsilon =  Epsilon;


%Root fillet

if RootAftFilletRatio > 0
 
    Epsilon = BaseEpsilon;
    
    AddChord = ((RootAftFilletRatio - Epsilon)/RootAftFilletRatio).^2*RootAftFilletAmplitude;
    
    AddChord(Epsilon > RootAftFilletRatio) = 0;
    
    Chord = Chord + AddChord;
    
end
