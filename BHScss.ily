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
  %% Title
  songtitle = \deftitle
  title= \markup {
    #(string-upcase deftitle)
  }
  %% Subtitle
  subtitle = #(if (string=? defsubtitle "")
               ""
               (let ((capsub (string-upcase defsubtitle)))
                #{ \markup { \concat { ( #capsub ) } } #}
              ))
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
       (define poet #{ \markup {Words by #(string-upcase deflyricist)} #}))
      (if (string=? defarranger "")
       (define arranger "")
       (define arranger #{ \markup {Arrangement by #} #(string-upcase defarranger)})))
     (if (string=? defcomposer deflyricist defarranger)
      (begin
       (define composer "Words, Music, and Arrangement")
       (define arranger #{ \markup {by #(string-upcase defcomposer)} #})
       (define poet ""))
      (if (string=? defcomposer deflyricist)
       (begin
        (define arranger "")
        (define poet #{ \markup {Words and Music by #(string-upcase defcomposer)} #})
        (if (string=? defarranger "")
         (define composer "")
         (define composer #{ \markup {Arrangement by #(string-upcase defarranger)} #})))
       (begin
        (define composer #{ \markup {Music by #(string-upcase defcomposer)} #})
        (if (string=? deflyricist "")
         (define poet "")
         (define poet #{ \markup {Words by #(string-upcase deflyricist)} #}))
        (if (string=? defarranger "")
         (define arranger "")
         (define arranger #{ \markup {Arrangement by #(string-upcase defarranger)} #})))))))

  %% Everything else
  copyright = \defcopyright
  tagline = \deftagline
  instrument = \defadditionalinfo
}

%%% Performance Notes
%%% @Section C.5
perfnotes = #(if (string=? defperformancenotes "")
             ""
              #{
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
              #})

%%% Set staff size to BHS Size:
%%% @Section A.1.d.
#(set-global-staff-size 20 )


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

%% Following functions modified from souce to accept strings from fields:
%% http://lsr.di.unimi.it/LSR/Item?id=765
%% see also http://lilypond.org/doc/v2.18/Documentation/notation/formatting-text
%% see also http://lilypond.org/doc/v2.18/Documentation/snippets/text
                                % Defines right-aligned and centered long text with the possibility to set the baseline-skip as required.
                                % Code is taken from ./scm/define-mark-up-commands.scm and just slightly modified.
                                % Author: harm6 from the german lilypondforum

#(define (general-column align-dir baseline mols)
  (let* ((aligned-mols (map (lambda (x) (ly:stencil-aligned-to x X align-dir)) mols)))
   (stack-lines -1 0.0 baseline aligned-mols)))

#(define-markup-command (textCenter layout props symbol)(symbol?)
  #:properties ((baseline-skip))
  (let* ((m (chain-assoc-get symbol props)))
   (if (string? m)
    (general-column CENTER baseline-skip (wordwrap-string-internal-markup-list layout props #f m))
    empty-stencil)))

%%% Define new bar number translation function with desired functionality
#(define-public (first-bar-number-visible-and-no-parenthesized-bar-numbers barnum mp)
  (= (ly:moment-main-numerator mp) 0))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Score Attributes
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Set score attributes
scoreattributes = {
  %%% Number every measure
  %%% @Section A.12
  \override Score.BarNumber.self-alignment-X = #LEFT
  \override Score.TimeSignature.break-align-anchor-alignment = #RIGHT
  \override Score.BarNumber.break-align-symbols = #'(time-signature key-signature)
  \override Score.BarNumber.extra-spacing-width = #'(0 . 1)
  \override Score.BarNumber.font-name = "Times"
  \override Score.BarNumber.font-size = \absFontSize #10
  \override Score.BarNumber.break-visibility = ##(#f #t #t)
  \set Score.barNumberVisibility = #first-bar-number-visible-and-no-parenthesized-bar-numbers

  %%% Format rehearsal marks
  %%% @Section A.11.a
  \override Score.RehearsalMark.self-alignment-X = #LEFT

  %%% Set glissando style
  %%% @Section B.17 (assumed from example; section not actually included)
  \override Score.Glissando.style = #'trill

  %%% Align instrument name correctly
  %%% @Section A.1.b
  \override Score.InstrumentName.self-alignment-X = #LEFT
}

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
                                % TODO: Code a solution to specifying min systems for first page
                                % Long story short, the optimal-breaking algorithm has to apply to every page. First page can have 3-4 systems. Other pages can have 4-5 systems. Leaving this out for now because it becomes unreadable sometimes otherwise.
  % min-systems-per-page = 4

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
            \textCenter #'header:copyright
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
