\version "2.19.49"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Define Header
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lilypond will provide default values to any undefined header variables. If
%% you do not want to display one of these values, assign it the empty string ("").
%%
%% Composer, Lyricist, and Arranger can be the same person. If this is the case,
%% place their name in all relevant fields. Formatting will be handled for you.
%%
%% Any other required text modification will be handled automatically.

%% Title of the Song
deftitle = "Title"

%% Subtitle
defsubtitle = "Subtitle"

%% Date, if public Domain
defdate = "date"

%% Composer
defcomposer = "Composer Name"

%% Lyricist(s)
deflyricist = "Lyricist Name"

%% Arranger
defarranger = "Arranger Name"

%% Copyright
% Bottom of first page. Add date and name, or change as necessary.
defcopyright = "This arrangement © 201_ SOMEONE. All Rights Reserved. No recording use, public performance for profit use or any other use requiring authorization, or reproduction or sale of copies in any form shall be made of or from this Arrangement unless licensed by the copyright owner or an agent or organization acting on behalf of the copyright owner."

%% Tagline
% Appears at the bottom of the last page.
deftagline = "Questions about the contest suitability of this song/arrangement should be directed to the judging community and measured against current contest rules. Ask before you sing."

%% Additional Information
defadditionalinfo = "as sung by nobody, for no voices, from no known source"

%% Performance Notes
defperformancenotes = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed venenatis risus eu fermentum molestie. Aliquam orci felis, convallis et dictum ac, aliquet in justo. Duis rutrum elementum purus sit amet maximus. Pellentesque feugiat convallis velit, ac sodales sem molestie quis. Quisque vitae lectus risus. In hac habitasse platea dictumst. Donec porta consequat mauris, quis consectetur lacus consectetur ut. Sed massa leo, tempus sit amet lorem nec, luctus fermentum risus. Proin mi urna, posuere in purus ut, molestie finibus diam.


Nam laoreet auctor felis eu interdum. Nulla sapien dui, elementum nec nisi consectetur, facilisis auctor purus. Fusce quis turpis massa. Aliquam fermentum dignissim tortor ac molestie. Phasellus lobortis consectetur ligula vel sagittis. Suspendisse id aliquet massa. Suspendisse a est est. Cras ut sapien tempor, dapibus ante fermentum, dictum tortor."

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Define global song attributes
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global = {
  %% Key Signature at the beginning of the piece. If it changes, it will be explicitly changed.
  \key c \major

  %% Time Signature
  \time 4/4
  \tempo 4=100

  %% When false, displays tempo marking at beginning
  \set Score.tempoHideNote = ##f
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Tenor
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tenorMusic = \relative c' {
  |
  \bar "|."
}

tenorWords = \lyricmode {

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Lead
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

leadMusic = \relative c' {
  |
  \bar "|."
}

leadWords = \lyricmode {
  
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Baritone
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bariMusic = \relative c' {
  |
  \bar "|."
}

bariWords = \lyricmode {

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Bass
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bassMusic = \relative c {
  |
  \bar "|."
}

bassWords = \lyricmode {

}

                                % Include formatting file
\include "BHScss.ily"
