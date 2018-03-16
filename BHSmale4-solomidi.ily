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


%% Tenor
\book {
  \bookOutputSuffix "solotenor"
  \score {
    \new Staff \with { midiInstrument = \midiinstrument } <<
      \global
      \new Voice = "tenors" {
        \voiceOne << \removeWithTag #'layout \tenorMusic >>
      }
      \new Lyrics = "tenors" { s1 }
      \context Lyrics = tenors \lyricsto tenors \tenorWords
    >>
    \midi {}
  }
}


%% Lead
\book {
  \bookOutputSuffix "sololead"
  \score {
    \new Staff \with { midiInstrument = \midiinstrument } <<
      \global
      \new Voice = "leads" {
        \voiceOne << \removeWithTag #'layout \leadMusic >>
      }
      \new Lyrics = "leads" { s1 }
      \context Lyrics = leads \lyricsto leads \leadWords
    >>
    \midi {}
  }
}


%% Bari
\book {
  \bookOutputSuffix "solobari"
  \score {
    \new Staff \with { midiInstrument = \midiinstrument } <<
      \global
      \new Voice = "baris" {
        \voiceOne << \removeWithTag #'layout \bariMusic >>
      }
      \new Lyrics = "baris" { s1 }
      \context Lyrics = baris \lyricsto baris \bariWords
    >>
    \midi {}
  }
}


%% Bass
\book {
  \bookOutputSuffix "solobass"
  \score {
    \new Staff \with { midiInstrument = \midiinstrument } <<
      \global
      \new Voice = "basses" {
        \voiceOne << \removeWithTag #'layout \bassMusic >>
      }
      \new Lyrics = "basses" { s1 }
      \context Lyrics = basses \lyricsto basses \bassWords
    >>
    \midi {}
  }
}

