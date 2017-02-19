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
\version "2.18.2"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Define Header
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                % TODO: Can this be auto-capitalized on title page?
%% Title of the Song
% This should be uppercase on the title page
% title = "_Title_"
title = "Shine On, Harvest Moon"

                                % TODO: Can some of these fields be auto-formatted?

%% Subtitle
% subtitle = "(_Subtitle_)"
subtitle = ""

%% Date, if public Domain
% date = "(_year_)"
date = ""

%% Lyricists, if not the composer
% lyricist = "Words by FIRSTNAME LASTNAME"
lyricist = ""
% secondlyricist = "and FIRSTNAME LASTNAME"
secondlyricist = ""

%% Composer
% composer = "Music by FIRSTNAME LASTNAME"
composer = ""

%% Arranger
% arranger = "Arranged by FIRSTNAME LASTNAME"
arranger = ""

                                % TODO: Can this just take a copyright date and name and fill them in?
%% Copyright
% Bottom of first page. Add date and name.
copyright = "This arrangement © 201_ SOMEONE. All Rights Reserved. No recording use, public performance for profit use or any other use requiring authorization, or reproduction or sale of copies in any form shall be made of or from this Arrangement unless licensed by the copyright owner or an agent or organization acting on behalf of the copyright owner."

%% Tagline
% Appears at the bottom of the last page.
tagline = "Questions about the contest suitability of this song/arrangement should be directed to the judging community and measured against current contest rules. Ask before you sing."

%% Additional information
% assungby = "as sung by _Group_"
% assungby = "from the movie _MovieTitle_"
% assungby = "for _voicepart-specification_"
assungby = ""

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Define global song attributes
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global = {
    %% Key Signature at the beginning of the piece. If it changes, it will be explicitly changed.
    \key bes \major

    %% Time Signature
    \time 2/2

                                % TODO: Can this be moved elsewhere and appended to global attributes later?
%%%% STOP EDITING HERE
    \set Score.tempoHideNote = ##t
    \tempo 4=100
    \override Score.BarNumber.break-visibility = ##(#f #t #t)

  }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Tenor
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tenorMusic = \relative c'' {
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

%%%%%%%%%%%%%%%%%%%%%%%%% Do Not Edit Below This Line %%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Create Header from variables defined by user
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\header {
    title = \title
    subtitle = \subtitle
    subsubtitle = \date
    poet = \lyricist
    composer = \composer
    arranger = \arranger
    copyright = \copyright
    tagline = \tagline
    dedication = ""
    instrument = \assungby
    meter = \secondlyricist
}


%%% Set staff size to BHS Size:
%%% @Section A.1.d.
#(set-global-staff-size 20 )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Utility functions
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allowGrobCallback =
#(define-scheme-function (parser location syms) (symbol-list?)
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
#(define-scheme-function (parser location pt)(number?)
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
%%% Lyricist's Name
%%% @Section 7
                \fill-line {
                    \abs-fontsize #12 {
                        \override #'(font-name . "Times") {
                            \fromproperty #'header:poet
                        }
                    }
                    {
                        \abs-fontsize #10 {
                            \override #'(font-name . "Times Italic") {
                                \italic \fromproperty #'header:instrument
                            }
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
        \abs-fontsize #9 {
            \override #'(font-name . "Times Italic")
            \fromproperty #'header:title
            \on-the-fly #print-page-number-check-first \italic \fromproperty #'page:page-number-string
        }
    }


    %% Needs evenHeaderMarkup
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
            \override Staff.InstrumentName.self-alignment-X = #LEFT
            \set Staff.instrumentName = \markup \left-column {
                "Tenor"
                "Lead"
            }
            \set Staff.shortInstrumentName = #""
            \clef "treble_8"
            \new Voice = "tenors" {
                \voiceOne
                <<
                    \global
                    \set midiInstrument = #"clarinet"
                    \tenorMusic
                >>
            }
            \new Voice = "leads" {
                \voiceTwo
                << \global \leadMusic >>
            }
        >>
        \new Lyrics = "leads" { s1 }
        \new Lyrics = "baris" \with {
            % this is needed for lyrics above a staff
            \override VerticalAxisGroup.staff-affinity = #DOWN
        } { s1 }
        \new Staff = bottomstaff <<
            \override Staff.InstrumentName.self-alignment-X = #LEFT
            \set Staff.instrumentName = \markup \left-column {
                "Bari"
                "Bass"
            }
            \set Staff.shortInstrumentName = #""
            \clef bass
            \new Voice = "baris" {
                \voiceOne
                << \global \bariMusic >>
            }
            \new Voice = "basses" {
                \voiceTwo << \global \bassMusic >>
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
            \Staff
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