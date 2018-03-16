%{

Copyright 2014 Jeff Harris
This is distributed under the terms of the GNU General Public License

This file is part of LilyPond Barbershop Template.

LilyPond Barbershop Template is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LilyPond Barbershop Template is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

%}
\version "2.19.49"
\include "BHScss.ily"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Assemble the parts into a score
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                % TODO: This only works on the first note of the part, then reverts back to the default \midiinstrument


%% Lead
\book {
  \bookOutputSuffix "leadpredominant"
  \score {
    \new ChoirStaff \with { midiInstrument = \midiinstrument } <<
      \new Lyrics = "tenors" { s1 }
      \new Staff = topstaff <<
        \global
        \new Voice = "tenors" {
          \voiceOne  << \removeWithTag #'layout \tenorMusic >>
        }
        \new Voice = "leads" {
          \set midiInstrument = #"trumpet"
          \voiceTwo << \removeWithTag #'layout \leadMusic >>
        }
      >>
      \new Lyrics = "leads" { s1 }
      \new Lyrics = "baris" { s1 }
      \new Staff = bottomstaff <<
        \global
        \new Voice = "baris" {
          \voiceOne << \removeWithTag #'layout \bariMusic >>
        }
        \new Voice = "basses" {
          \voiceTwo << \removeWithTag #'layout \bassMusic >>
        }
      >>
      \new Lyrics = basses { s1 }
      \context Lyrics = tenors \lyricsto tenors \tenorWords
      \context Lyrics = leads \lyricsto leads \leadWords
      \context Lyrics = baris \lyricsto baris \bariWords
      \context Lyrics = basses \lyricsto basses \bassWords
    >>
    \midi {
      midiChannelMapping = #'voice
      \context {
        \ChoirStaff
        \remove "Staff_performer"
      }
      \context {
        \Voice
        \consists "Staff_performer"
      }
    }
  }
}

