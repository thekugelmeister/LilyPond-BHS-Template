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

%% MIDI SCORE
\score
{
  \new ChoirStaff <<
    \new Lyrics = "tenors" \with {
                                % this is needed for lyrics above a staff
      \override VerticalAxisGroup.staff-affinity = #DOWN
    }{ s1 }
    \new Staff = topstaff <<
      \override Staff.BarNumber.break-visibility = ##(#f #t #t)
      \override Staff.InstrumentName.self-alignment-X = #LEFT
      \set Staff.instrumentName = \markup \left-column {
        "Tenor"
        "Lead"
      }
      \set Staff.shortInstrumentName = #""
      \clef "treble_8"
      \new Voice = "tenors" {
        \voiceOne << \global \scoreattributes \removeWithTag #'layout \tenorMusic >>
      }
      \new Voice = "leads" {
        \voiceTwo << \global \scoreattributes \removeWithTag #'layout \leadMusic >>
      }
    >>
    \new Lyrics = "leads" { s1 }
    \new Lyrics = "baris" \with {
                                % this is needed for lyrics above a staff
      \override VerticalAxisGroup.staff-affinity = #DOWN
    } { s1 }
    \new Staff = bottomstaff <<
      \override Staff.BarNumber.break-visibility = ##(#f #f #f)
      \override Staff.InstrumentName.self-alignment-X = #LEFT
      \set Staff.instrumentName = \markup \left-column {
        "Bari"
        "Bass"
      }
      \set Staff.shortInstrumentName = #""
      \clef bass
      \new Voice = "baris" {
        \voiceOne << \global \scoreattributes \removeWithTag #'layout \bariMusic >>
      }
      \new Voice = "basses" {
        \voiceTwo << \global \scoreattributes \removeWithTag #'layout \bassMusic >>
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

%% LAYOUT SCORE
\score
{
  \new ChoirStaff <<
    \new Lyrics = "tenors" \with {
                                % this is needed for lyrics above a staff
      \override VerticalAxisGroup.staff-affinity = #DOWN
    }{ s1 }
    \new Staff = topstaff <<
      \override Staff.BarNumber.break-visibility = ##(#f #t #t)
      \override Staff.InstrumentName.self-alignment-X = #LEFT
      \set Staff.instrumentName = \markup \left-column {
        "Tenor"
        "Lead"
      }
      \set Staff.shortInstrumentName = #""
      \clef "treble_8"
      \new Voice = "tenors" {
        \voiceOne << \global \scoreattributes \removeWithTag #'midi \tenorMusic >>
      }
      \new Voice = "leads" {
        \voiceTwo << \global \scoreattributes \removeWithTag #'midi \leadMusic >>
      }
    >>
    \new Lyrics = "leads" { s1 }
    \new Lyrics = "baris" \with {
                                % this is needed for lyrics above a staff
      \override VerticalAxisGroup.staff-affinity = #DOWN
    } { s1 }
    \new Staff = bottomstaff <<
      \override Staff.BarNumber.break-visibility = ##(#f #f #f)
      \override Staff.InstrumentName.self-alignment-X = #LEFT
      \set Staff.instrumentName = \markup \left-column {
        "Bari"
        "Bass"
      }
      \set Staff.shortInstrumentName = #""
      \clef bass
      \new Voice = "baris" {
        \voiceOne << \global \scoreattributes \removeWithTag #'midi \bariMusic >>
      }
      \new Voice = "basses" {
        \voiceTwo << \global \scoreattributes \removeWithTag #'midi \bassMusic >>
      }
    >>
    \new Lyrics = basses { s1 }
    \context Lyrics = tenors \lyricsto tenors \tenorWords
    \context Lyrics = leads \lyricsto leads \leadWords
    \context Lyrics = baris \lyricsto baris \bariWords
    \context Lyrics = basses \lyricsto basses \bassWords
  >>
  \layout {
    \context {
      \Score
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

%%% Performance Notes
%%% @Section C.5
\markup {
  \override #'(line-width . 110)
  \column {
    \draw-hline
    \abs-fontsize #18 {
      \override #'(font-name . "Times Bold Italic") {
        \italic "Performance Notes"
      }
    }
    \fill-line {
      \abs-fontsize #10 {
        \override #'(font-name . "Times")
        \wordwrap-string \defperformancenotes
      }
    }
  }
}
