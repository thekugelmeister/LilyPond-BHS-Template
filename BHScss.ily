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

%%%%%%%%%%%%%%%%%%%%%%%%% Do Not Edit Below This Line %%%%%%%%%%%%%%%%%%%%%%%%%%

\pointAndClickOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Create Header from variables defined by user
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\header {
                                % TODO: Currently, \caps does not seem to work for \fromproperty #'header:songtitle.
                                % TODO: \caps is small-caps; want full caps.

  %% Title
  songtitle = \deftitle
  title= \markup {
    \caps { \deftitle }
  }
  %% Subtitle
  subtitle = #(if (string=? defsubtitle "")
               ""
               #{ \markup { \concat { ( \caps { \defsubtitle } ) } } #})
  %% Date
  subsubtitle = #(if (string=? defdate "")
                  ""
                  #{ \markup { \concat { ( \defdate ) } } #})

  %% Composer, Lyricist, and Arranger
  #(begin
    (if (string=? defcomposer "")
     (begin
      (define composer "")
      (if (string=? deflyricist "")
       (define poet "")
       (define poet #{ \markup { Words by \caps { \deflyricist } } #}))
      (if (string=? defarranger "")
       (define arranger "")
       (define arranger #{ \markup { Arrangement by \caps { \defarranger } } #})))
     (if (string=? defcomposer deflyricist defarranger)
      (begin
       (define composer "Words, Music, and Arrangement")
       (define arranger #{ \markup { by \caps { \defcomposer } } #})
       (define poet ""))
      (if (string=? defcomposer deflyricist)
       (begin
        (define arranger "")
        (define poet #{ \markup { Words and Music by \caps { \defcomposer } } #})
        (if (string=? defarranger "")
         (define composer "")
         (define composer #{ \markup { Arrangement by \caps { \defarranger } } #})))
       (begin
        (define composer #{ \markup { Music by \caps { \defcomposer } } #})
        (if (string=? deflyricist "")
         (define poet "")
         (define poet #{ \markup { Words by \caps { \deflyricist } } #}))
        (if (string=? defarranger "")
         (define arranger "")
         (define arranger #{ \markup { Arrangement by \caps { \defarranger } } #})))))))

  %% Everything else
  copyright = \defcopyright
  tagline = \deftagline
  instrument = \defadditionalinfo
}

%%% Set staff size to BHS Size:
%%% @Section A.1.d.
#(set-global-staff-size 20 )

%%% Set score attributes
scoreattributes = {
  %%% Number every measure
  %%% @Section A.12.a
  \override Staff.BarNumber.self-alignment-X = #LEFT
  \override Staff.BarNumber.break-align-symbols = #'(key-signature)
  \override Staff.BarNumber.extra-spacing-width = #'(0 . 1)
                                % TODO: When displaying tempo marking, force display of the measure number.
                                % TODO: Make sure measure numbers are in 10-point fixed Times New Roman

  %%% Format rehearsal marks
  %%% @Section A.11.a
  \override Score.RehearsalMark.self-alignment-X = #LEFT
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Utility functions
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allowGrobCallback =
#(define-scheme-function (syms) (symbol-list?)
  (let ((interface (car syms))
        (sym (cadr syms)))
   #{
   \with {
   \consists #(lambda (context)
               `((acknowledgers .
                  ((,interface . ,(lambda (engraver grob source-engraver)
                                   (let ((prop (ly:grob-property grob sym)))
                                    (if (procedure? prop) (ly:grob-set-property! grob sym (prop grob)))
                                  ))))
                ))
             )
 }
   #}))

absFontSize =
#(define-scheme-function (pt)(number?)
  (lambda (grob)
   (let* ((layout (ly:grob-layout grob))
          (ref-size (ly:output-def-lookup (ly:grob-layout grob) 'text-font-size 12)))
    (magnification->font-size (/ pt ref-size))
  )
 )
)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Paper Block
%%%
%%% Sets paper size to letter; sets margins and line width.
%%% Defines header information as required by BHS
%%%
%%% @Section 2
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\paper {
  #(set-paper-size "letter")
  bottom-margin   = 0.50\in
  top-margin      = 0.50\in
  inner-margin     = 0.50\in
  outer-margin	= 0.625\in % 5/8 inch
  line-width      = 7.375\in % 8.5 inch page width - ( inner-margin + outer-margin )
  last-bottom-spacing = 0.5\in
  ragged-last-bottom = ##t
  markup-system-spacing.padding = #1
  system-system-spacing.padding = #4
  top-system-spacing.padding = #3
  max-systems-per-page = 5

  bookTitleMarkup = \markup {
    \override #'(baseline-skip . 3.5)

    \column {
      \fill-line {
        \fromproperty #'header:dedication
      }
%%% Title in 22 pt Arial Bold
%%% @Section A.4.a
      \override #'(baseline-skip . 3.5)
      \column {
        \fill-line {
          \abs-fontsize #22 {
            \override #'(font-name . "Arial Bold") {
              \fromproperty #'header:title
            }
          }
        }
%%% Subtitle in 12 pt Arial Bold
%%% @Section A.4.b
        \fill-line {
          \abs-fontsize #12 {
            \override #'(font-name . "Arial Bold") {
              \fromproperty #'header:subtitle
            }
          }
        }
%%% Date if in public Domain
%%% @Section 5
        \fill-line {
          \abs-fontsize #12 {
            \override #'(font-name . "Arial Bold") {
              \fromproperty #'header:subsubtitle
            }
          }
        }
        \fill-line {
          \abs-fontsize #10 {
            \override #'(font-name . "Times Italic") {
              \italic \fromproperty #'header:instrument
            }
          }
        }
        \strut
        \strut
%%% Lyricist's Name
%%% @Section 7
        \fill-line {
          \abs-fontsize #12 {
            \override #'(font-name . "Times") {
              \fromproperty #'header:poet
            }
          } \abs-fontsize #12 {
            \override #'(font-name . "Times") {
              \fromproperty #'header:composer
            }
          }
        }
        \fill-line {
          \fromproperty #'header:meter
          \fromproperty #'header:arranger
        }
      }
    }
  }

                                % TODO: Center copyright
                                % TODO: Why does oddFooterMarkup work for even pages too?
  oddFooterMarkup = \markup {
    \column {
      \fill-line {
        \column {
          " "
          %% Copyright header field only on first page in each bookpart.
          \on-the-fly #part-first-page
          \abs-fontsize #9 {
            \override #'(line-width . 110)
            \override #'(font-name . "Times")
            \wordwrap-field #'header:copyright
          }
        }
      }
      \fill-line {
        %% Tagline header field only on last page in the book.
        \on-the-fly #last-page
        \abs-fontsize #9 {
          \override #'(line-width . 110)
          \override #'(font-name . "Times")
          \wordwrap-field #'header:tagline
        }
      }
    }
  }

  oddHeaderMarkup = \markup

  \fill-line {
    %% force the header to take some space, otherwise the
    %% page layout becomes a complete mess.
    " "
    \on-the-fly #not-part-first-page
    \abs-fontsize #12 {
      \override #'(font-name . "Times Italic")
      \fromproperty #'header:songtitle
      \on-the-fly #print-page-number-check-first \italic \fromproperty #'page:page-number-string
    }
  }


  evenHeaderMarkup = \markup

  \fill-line {
    \on-the-fly #not-part-first-page
    \abs-fontsize #12 {
      \on-the-fly #print-page-number-check-first \italic \fromproperty #'page:page-number-string
      \override #'(font-name . "Times Italic")
      \fromproperty #'header:songtitle
    }
    %% force the header to take some space, otherwise the
    %% page layout becomes a complete mess.
    " "
  }
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Helper markups
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xVoice = \markup { \smaller \sans { x } } % print this by using '\xVoice'



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Assemble the parts into a score
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        \voiceOne << \global \scoreattributes \tenorMusic >>
      }
      \new Voice = "leads" {
        \voiceTwo << \global \scoreattributes \leadMusic >>
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
        \voiceOne << \global \scoreattributes \bariMusic >>
      }
      \new Voice = "basses" {
        \voiceTwo << \global \scoreattributes \bassMusic >>
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
