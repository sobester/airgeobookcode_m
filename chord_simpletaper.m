function Chord = chord_simpletaper(ChordParameters, Epsilon)
%CHORD_SIMPLETAPER Generate chords for simply tapered wing.
%   Returns linearly varying chord lengths as needed for a simple taper.
%   INPUTS: ChordParameters - [Taper Ratio]
%           Epsilon - vector of spanwise stations (along the
%           non-dimensional spanwise variable Epsilon).
%   OUTPUT: Chord - vector (same length as Epsilon) of chord lengths.

TaperRatio = ChordParameters(1);

Chord = 1- Epsilon*(1-TaperRatio);