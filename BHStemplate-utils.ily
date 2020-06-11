%{
Copyright 2014, 2018 Jeff Harris, Jeremy Marcus
This is distributed under the terms of the GNU General Public License.

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
along with LilyPond Barbershop Template.  If not, see <http://www.gnu.org/licenses/>.
%}

\version "2.20"
                                % TODO: Check whether there are any issues with these includes being redundant or anything...
#(ly:load "lily-library.scm")
#(ly:load "define-markup-commands.scm")
#(use-modules (ice-9 regex))
#(use-modules (srfi srfi-1))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Utility functions from BHScss.ily (Copyright 2014 Jeff Harris)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% These functions may or may not be necessary, but I haven't gone back to
%%% test them yet. Including copyright statement from that file just in case.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                % TODO: See notes above.
                                % TODO: Document these better if they are necessary
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

                                % TODO: Do I need this re-definition of general-column? Seems redundant to me. A very similar definition exists in define-markup-commands.scm...
#(define (general-column align-dir baseline mols)
  (let* ((aligned-mols (map (lambda (x) (ly:stencil-aligned-to x X align-dir)) mols)))
   (stack-lines -1 0.0 baseline aligned-mols)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Bar number visibility function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Enables display of first measure bar number and suppresses parenthesization
%%% of bar numbers for partial measures.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(define-public (first-bar-number-visible-and-no-parenthesized-bar-numbers barnum mp)
  (= (ly:moment-main-numerator mp) 0))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Staff bar number display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Functions for determining which staves should show bar numbers.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                % TODO: define-scheme-function vs define?
                                % TODO: I don't like that "ShowBarNumbers" is hard-coded here
#(define (set-show-bar-num-top-staff! voice-list)
  "Finds the first voice which has defined music in an ordered list of voices
from top to bottom on the page. Sets the ShowBarNumbers option for that voice
to true. If no music is found, nothing happens."
  (let* ((top-voice (find (lambda (vp)
                           (make-id vp "Music"))
                     voice-list)))
   (if (and top-voice (not (make-id top-voice "ShowBarNumbers")))
    (ly:parser-define!
     (string->symbol (string-append top-voice "ShowBarNumbers"))
     #t))))

#(define (divided-staff-show-bar-nums? voice1 voice2)
  "Convenience function for checking whether either voice on a given divided
staff has ShowBarNumbers == true."
  (or (make-id voice1 "ShowBarNumbers") (make-id voice2 "ShowBarNumbers")))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LilyPond property string formatting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Extend LilyPond property functionality to format strings before returning.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                % TODO: String checking?
                                % TODO: Are These overkill? Maybe, but it's a known fix for a known bug that I don't feel like addressing.
#(define-markup-command (capsfromproperty layout props symbol)
  (symbol?)
  "Read the @var{symbol} from property settings, and produce a stencil
from the markup contained within.  If @var{symbol} is not defined, it
returns an empty markup.

Capitalizes the string returned from evaluating symbol."
  (let ((m (chain-assoc-get symbol props)))
   (if (markup? m)
    ;; prevent infinite loops by clearing the interpreted property:
    (interpret-markup layout (cons (list (cons symbol `(,property-recursive-markup ,symbol))) props) (string-upcase m))
    empty-stencil)))

#(define-markup-command (concapsfromproperty layout props symbol before after)
  (symbol? string? string?)
  "Read the @var{symbol} from property settings, and produce a stencil
from the markup contained within.  If @var{symbol} is not defined, it
returns an empty markup.

Capitalizes the string returned from evaluating symbol, and concatenates
together before, the capitalized string, and after."
  (let ((m (chain-assoc-get symbol props)))
   (if (markup? m)
    ;; prevent infinite loops by clearing the interpreted property:
    (interpret-markup layout (cons (list (cons symbol `(,property-recursive-markup ,symbol))) props) (string-append before (string-upcase m) after))
    empty-stencil)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Extended wordwrap functionality
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Wordwrap functions providing additional formatting and layout options.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#(define-markup-command (wordwrap-string-centered layout props arg)
  (string?)
  #:properties ((baseline-skip))
  "Wordwrap a string. Paragraphs may be separated with double newlines.
Places the resulting lines in a centered column."
  (general-column CENTER baseline-skip
   (wordwrap-string-internal-markup-list layout props #f arg)))

                                % TODO: There has to be a more elegant solution than just adding a line between each paragraph that includes a single whitespace character. But it just works so well.
#(define-markup-list-command (wordwrap-pstring-internal layout props justify arg)
  (boolean? string?)
  #:properties ((line-width)
                (word-space)
                (text-direction RIGHT))
  "Internal markup list command used to define @code{\\wordwrap-pstring}."
  (let* ((para-strings (regexp-split
                        (string-regexp-substitute
                         "\r" "\n"
                         (string-regexp-substitute "\r\n" "\n" arg))
                        "\n[ \t\n]*\n[ \t\n]*"))
         (list-para-words (map (lambda (str)
                                (regexp-split str "[ \t\n]+"))
                           para-strings))
         (list-para-words-pspace (apply append (map (lambda (p)
                                                     (list p '(" ")))
                                                list-para-words)))
         (para-lines (map (lambda (words)
                           (let* ((stencils
                                   (map (lambda (x)
                                         (interpret-markup layout props x))
                                    words)))
                            (wordwrap-stencils stencils
                             justify word-space
                             line-width text-direction)))
                      list-para-words-pspace)))
   (concatenate para-lines)))

#(define-markup-command (wordwrap-pstring layout props arg)
  (string?)
  #:category align
  #:properties ((baseline-skip)
                wordwrap-string-internal-markup-list)
  "Wordwrap a string.  Paragraphs may be separated with double newlines.
Skips lines between paragraphs.

@lilypond[verbatim,quote]
\\markup {
  \\override #'(line-width . 40)
  \\wordwrap-pstring #\"Lorem ipsum dolor sit amet, consectetur
      adipisicing elit, sed do eiusmod tempor incididunt ut labore
      et dolore magna aliqua.


      Ut enim ad minim veniam, quis nostrud exercitation ullamco
      laboris nisi ut aliquip ex ea commodo consequat.


      Excepteur sint occaecat cupidatat non proident, sunt in culpa
      qui officia deserunt mollit anim id est laborum\"
}
@end lilypond"
  (stack-lines DOWN 0.0 baseline-skip
   (wordwrap-pstring-internal-markup-list layout props #f arg)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lyricist, Composer, Arranger Logic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
TODO: For lack of a better option, I'm doing this in a redundant manner. If I can figure out how to improve this, I should do so.

TODO: I'm pretty sure that this relies on the user only setting these header variables as strings, not as other valid markups. This is undesirable. Refactor to allow arbitrary markup if possible.

These functions are designed to provide the logic for displaying the lyricist, composer, and arranger name sections
correctly based on their inclusion in the header block. See sections A.6-8 in the BHS Notation Manual for further
documentation.

This information is displayed on a maximum of two lines, each with a left-aligned component and a right-aligned
component, making a total of four "quadrants" to fill. Defined below are four markup commands, one for each
quadrant. Each one passes the three relevant header properties to the lycoar base function, which returns an integer
describing the layout required for the current configuration. The quadrants are numbered left->right, top->bottom.

Taking "unset" variables into account leads to redundancy in the mapping for no good reason. Therefore, the mappings
are defined assuming that any unset variables are already set to the placeholder "UNKNOWN" value. This leaves us with
only five cases to consider.

NOTE: Some of these cases are not explicitly covered in the manual, so I made an educated guess...
The integer mapping is as follows:
0: All three are the same
1: Lyricist and Composer are the same
2: Lyricist and Arranger are the same (NOT COVERED)
3: Composer and Arranger are the same (NOT COVERED)
4: All three are different
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lycoar =
#(define-scheme-function (lyricist composer arranger)
  (string? string? string?)
  "Checks uniqueness of lyricist, composer, and arranger names. Returns integer
describing which case we are observing. See comment above for more detail."
  (let ((lyco (string-ci= lyricist composer))
        (lyar (string-ci= lyricist arranger))
        (coar (string-ci= composer arranger)))
   (cond
    ((and lyco coar) 0)
    (lyco 1)
    (lyar 2)
    (coar 3)
    (else 4))))

                                % TODO: I don't like that the default name value "Unknown" is hard-coded in this out-of-the-way place.
lycoar-check-set =
#(define-scheme-function (val)
  (scheme?)
  "If given a string, returns that string. Else returns default name value."
  (if (string? val)
   val
   "Unknown")
)

#(define-markup-command (ly-co-ar-qone layout props lysym cosym arsym)
  (symbol? symbol? symbol?)
  "Lyricist, Composer, Arranger logic for quadrant one."
  (let* ((lyricist (lycoar-check-set (chain-assoc-get lysym props)))
         (composer (lycoar-check-set (chain-assoc-get cosym props)))
         (arranger (lycoar-check-set (chain-assoc-get arsym props)))
         (lycoar-var (lycoar lyricist composer arranger)))
   (case lycoar-var
    ((0) empty-stencil)
    ((1) (interpret-markup layout props (string-append "Words and Music by " (string-upcase lyricist))))
    ((2) (interpret-markup layout props (string-append "Music by " (string-upcase composer))))
    (else (interpret-markup layout props (string-append "Words by " (string-upcase lyricist))))
  )))

#(define-markup-command (ly-co-ar-qtwo layout props lysym cosym arsym)
  (symbol? symbol? symbol?)
  "Lyricist, Composer, Arranger logic for quadrant two."
  (let* ((lyricist (lycoar-check-set (chain-assoc-get lysym props)))
         (composer (lycoar-check-set (chain-assoc-get cosym props)))
         (arranger (lycoar-check-set (chain-assoc-get arsym props)))
         (lycoar-var (lycoar lyricist composer arranger)))
   (case lycoar-var
    ((0) (interpret-markup layout props "Words, Music, and Arrangement by"))
    ((1) (interpret-markup layout props (string-append "Arrangement by " (string-upcase arranger))))
    ((2) (interpret-markup layout props (string-append "Words and Arrangement by " (string-upcase arranger))))
    ((3) (interpret-markup layout props (string-append "Music and Arrangement by " (string-upcase arranger))))
    (else (interpret-markup layout props (string-append "Music by " (string-upcase composer))))
  )))

                                % TODO: Verify whether this really should always return an empty stencil
#(define-markup-command (ly-co-ar-qthree layout props lysym cosym arsym)
  (symbol? symbol? symbol?)
  "Lyricist, Composer, Arranger logic for quadrant three."
  empty-stencil)

#(define-markup-command (ly-co-ar-qfour layout props lysym cosym arsym)
  (symbol? symbol? symbol?)
  "Lyricist, Composer, Arranger logic for quadrant four."
  (let* ((lyricist (lycoar-check-set (chain-assoc-get lysym props)))
         (composer (lycoar-check-set (chain-assoc-get cosym props)))
         (arranger (lycoar-check-set (chain-assoc-get arsym props)))
         (lycoar-var (lycoar lyricist composer arranger)))
   (case lycoar-var
    ((0) (interpret-markup layout props (string-upcase arranger)))
    ((4) (interpret-markup layout props (string-append "Arrangement by " (string-upcase arranger))))
    (else empty-stencil)
  )))
