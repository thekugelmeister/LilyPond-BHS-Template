% Here we find the lead music to Shine On, Harvest Moon.
% Minimal documentation is provided here, because if you found this template,
% You probably already know how to code for LilyPond. If someone told you about this,
% you will get enough information to make music.

% Notes are defined as the lower case note name.
% Rests are usually 'r' instead of a note.

% duration is indicated by a number corresponding to the denominator of the value
% whole note is 1, half is 2, quarter is 4, etc. Dot the value to dot the value.
% Durations inherit from the previous note, so 4 quarter notes can be c4 d e f

% Sharps are noted by adding 's' or 'sharp' to the note name.
% Double sharps are noted by adding 'ss' or 'x' or 'doublesharp'
% Flats are 'f' or 'flat'
% Double flat is, you guessed it, 'ff' or 'doubleflat'

% Horizontal bars are bar lines. They are optional, but inserting them will alert you if a bar has an incorrect duration

% Tie a c to another c like this: C~ C
% Slurs are c ( c ) and the note always comes first.
% Phrasing marks are indicated by \( and \): d \( cs b cs d \)

leadMusic = \relative c' {
    % dynamic marking is only for Midi track and should be removed before printing
    \set midiInstrument = #"trombone"
    d1~\(-\omit\f | % D tied to the next D and starting a phrasing mark
    d1 |
    df  |
    c2. \) b4\rest| \bar "||" % End the phrasing mark, add a thin double bar line to the end.
    % b4\rest places a quarter (4) note rest (\rest) centered over where a b would be.
    % In the tenor part, we will not have a rest, but a quarter note space, or silence.
    % We do this here because both parts have the same rest. If they had different rests,
    % we would just write them in and let LilyPond put them away from each other (or if one voice
    % is hanging before the other comes in)

    % measure 5
    % I put each bar on its own line with a vertical space every 4 bars.
    % Lines end a the end of the line, so you could split bars or combine on a text line.
    bf8. b16\rest bf8. b16\rest bf8. b16\rest bf8. b16\rest bf8. b16\rest bf8. b16\rest bf4 b\rest bf bf g4. b8\rest b4\rest gs a b4\rest |

    % measure 9
    bf8. b16\rest bf8. b16\rest bf8. b16\rest bf8. b16\rest |
    bf8. b16\rest bf8. b16\rest bf2 |
    b4\rest bf bf bf |
    bf2( a4) b4\rest |
    % This was easier to read, right?

    % 13
    % if the interval between one note and the next is less than a 5th, LilyPond assumes that
    % you want the closest one.
    ef8. d16 ef8. d16 ef8. d16 ef8. d16 |
    ef8 c4 g8~ g4 a |
bf2 b8\rest f bf8. d16 |
f1^\xVoice | % above the staff (^) indicate a crossed voice (\xVoice)
    \bar "|." % final bar line

}