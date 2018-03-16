\version "2.19.49"
\include "bhs-markup.ily"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% BHSinit.ily
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The goal of this package is to surround the LilyPond backend with an API of
%% sorts. Wherever possible, it would be preferable for the user to interact
%% with the opaque abstraction defined here.
%%
%% This script initializes the components of this abstraction, effectively
%% making them available for use by the end user.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Define Header Variables
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lilypond will provide default values to any undefined header variables. If
%% one does not want to display one of these header elements, one can assign it
%% the empty string ("").
%%
%% Composer, Lyricist, and Arranger can be the same person. If this is the case,
%% place their name in all relevant fields. Formatting will be handled
%% automatically.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Title of the Song
deftitle = "Title"

%%% Subtitle
%% defsubtitle = "Subtitle"
defsubtitle = ""

%%% Date, if public Domain
%% defdate = "2017"
defdate = ""

%%% Additional Information
%% defadditionalinfo = "as sung by nobody, for no voices, from no known source"
defadditionalinfo = ""

%%% Composer
defcomposer = "Composer Name"

%%% Lyricist(s)
deflyricist = "Lyricist Name"

%%% Arranger
defarranger = "Arranger Name"

%%% Copyright (bottom of first page)
%% defcopyright = "This arrangement © _YEAR_ _ENTITY_. All Rights Reserved. No recording use, public performance for profit use or any other use requiring authorization, or reproduction or sale of copies in any form shall be made of or from this Arrangement unless licensed by the copyright owner or an agent or organization acting on behalf of the copyright owner."
defcopyright = ""

%%% Tagline (bottom of last page)
deftagline = "Questions about the contest suitability of this song/arrangement should be directed to the judging community and measured against current contest rules. Ask before you sing."

%% Performance Notes
defperformancenotes = ""

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Output options
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PDF layout and MIDI output can be controlled in a number of ways. Modify
%% these variables to affect output, or leave as default.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% When true, sizes a single page to fit music. Intended for tags.
tagpage = ##f

%% When true, hides tempo marking at beginning
hidetempomarking = ##t

%% Set the MIDI output instrument (lilypond default: acoustic grand).
%% See http://lilypond.org/doc/Documentation/notation/midi-instruments for a complete list.
midiinstrument = #"voice oohs"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Define global song attributes
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Any global song attributes should be set in this structure. It will be
%% applied to all music at compile time.
%%
%% Examples: key signature, tempo, time signature, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global = {
  \key c \major
  \time 4/4
  \tempo 4=100
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Initialize chord structure
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display of chords is optional, but the way things are set up right now
%% displaying them is always attempted. Therefore, initialize an empty
%% chordmode structure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

displayChords = \chordmode {}
