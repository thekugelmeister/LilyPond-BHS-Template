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

                                % TODO: Variable part numbers?
                                % TODO: Variable part names/labels?
                                % TODO: Properly display voice splits on a single staff
                                % TODO: Variable display of piano reduction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Assemble the parts into a score
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MIDI SCORE
\score
{
  \new ChoirStaff \with { midiInstrument = \midiinstrument } <<
    \new Lyrics = "sopranos" { s1 }
    \new Staff = topstaff <<
      \global
      \set Staff.instrumentName = \markup \left-column {
        "Soprano"
        "Alto"
      }
      \set Staff.shortInstrumentName = #""
      \new Voice = "sopranos" {
        \voiceOne << \removeWithTag #'layout \sopMusic >>
      }
      \new Voice = "altos" {
        \voiceTwo << \removeWithTag #'layout \altoMusic >>
      }
    >>
    \new Lyrics = "altos" { s1 }
    \new Lyrics = "tenors" { s1 }
    \new Staff = bottomstaff <<
      \global
      \set Staff.instrumentName = \markup \left-column {
        "Tenor"
        "Bass"
      }
      \set Staff.shortInstrumentName = #""
      \new Voice = "tenors" {
        \voiceOne << \removeWithTag #'layout \tenorMusic >>
      }
      \new Voice = "basses" {
        \voiceTwo << \removeWithTag #'layout \bassMusic >>
      }
    >>
    \new Lyrics = basses { s1 }
    \context Lyrics = sopranos \lyricsto sopranos \sopWords
    \context Lyrics = altos \lyricsto altos \altoWords
    \context Lyrics = tenors \lyricsto tenors \tenorWords
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

%% LAYOUT SCORE
\score
{
  <<
    \new ChoirStaff <<
      \new Staff = staffa <<
        \global
        \set Staff.instrumentName = \markup \left-column {
          "Soprano"
        }
        \set Staff.shortInstrumentName = #""
        \new Voice = "sopranos" {
          \voiceOne << {\bar ""} \removeWithTag #'midi \sopMusic >>
        }
      >>
      \new Lyrics = "sopranos" { s1 }
      \new Staff = staffb <<
        \global
        \override Staff.BarNumber.break-visibility = ##(#f #f #f)
        \set Staff.instrumentName = \markup \left-column {
          "Alto"
        }
        \set Staff.shortInstrumentName = #""
        \new Voice = "altos" {
          \voiceOne << {\bar ""} \removeWithTag #'midi \altoMusic >>
        }
      >>
      \new Lyrics = "altos" { s1 }
      \new Staff = staffc <<
        \global
        \override Staff.BarNumber.break-visibility = ##(#f #f #f)
        \set Staff.instrumentName = \markup \left-column {
          "Tenor"
        }
        \set Staff.shortInstrumentName = #""
        \new Voice = "tenors" {
          \voiceOne << {\bar ""} \removeWithTag #'midi \tenorMusic >>
        }
      >>
      \new Lyrics = "tenors" { s1 }
      \new Staff = staffd <<
        \global
        \override Staff.BarNumber.break-visibility = ##(#f #f #f)
        \set Staff.instrumentName = \markup \left-column {
          "Bass"
        }
        \set Staff.shortInstrumentName = #""
        \new Voice = "basses" {
          \voiceOne << {\bar ""} \removeWithTag #'midi \bassMusic >>
        }
      >>
      \new Lyrics = basses { s1 }
      \context Lyrics = sopranos \lyricsto sopranos \sopWords
      \context Lyrics = altos \lyricsto altos \altoWords
      \context Lyrics = tenors \lyricsto tenors \tenorWords
      \context Lyrics = basses \lyricsto basses \bassWords
    >>
    \new PianoStaff \with { printPartCombineTexts = ##f } <<
      \new Staff <<
        \global
        \partcombine
        << {\bar ""} \removeWithTag #'midi \sopMusic >>
        << {\bar ""} \removeWithTag #'midi \altoMusic >>
      >>
      \new Staff <<
        \global
        \override Staff.BarNumber.break-visibility = ##(#f #f #f)
        \partcombine
        << {\bar ""} \removeWithTag #'midi \tenorMusic >>
        << {\bar ""} \removeWithTag #'midi \bassMusic >>
      >>
    >>
  >>
  \layout {
    \context {
      \Score
      \scoreattributes
      \remove Bar_number_engraver
    }
    \context {
      \Staff
      \consists Bar_number_engraver
    }
    \context {
      \Lyrics
      \override LyricSpace.minimum-distance = #2.0
      \override LyricText.font-size = \absFontSize #11
    }
  }
}

\perfnotes
