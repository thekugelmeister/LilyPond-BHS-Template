\version "2.19.25"
                                % TODO: Document available variables better
                                % TODO: Default to TwoVoicesPerStaff = ##t if possible
                                % TODO: Find a way to end lyric extenders when they are followed immediately by lyric skips.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                %%
%%      Accompanied Divided Barbershop Group      %%
%%                                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
This file may be \include'd in a score to provide the
context structure for a score arrangement consisting
of the following staves, although normally only a subset
of these staves would be used in any one score.

Solo Staff (outside Choir grouping)
First and Second Tenor (optionally on two Staves or one Staff)
Tenor and Lead (optionally on two Staves or one Staff)
First and Second Lead (optionally on two Staves or one Staff)
First and Second Bari (optionally on two Staves or one Staff)
Bari and Bass (optionally on two Staves or one Staff)
First and Second Bass (optionally on two Staves or one Staff)
Piano Staff

It is intended primarily to hide the complexity of the context
structure from newcomers to LilyPond, but is also useful as a
shorthand for seasoned users.  It is intended to facilitate the
setting of pieces in which different groupings of voices appear
at different times.  All that is necessary is to populate the
appropriate variables with music for the relevant sections and
with rests elsewhere, with sections separated by line breaks.

Usage:

BHStemplate.ly should be included at the *end* of the input file. Before
it are placed the required music and lyrics by redefining specific
variables, like this:

\paper { ... }
\header { ... }
Key = { ... }
Time = { ... }
Chords = \chordmode { ... }
SoloMusic = \relative { ... }
SoloLyrics = \lyricmode { ... }
TenorOneMusic = \relative { ... }
TenorOneLyrics = \lyricmode { ... }
TenorTwoMusic = \relative { ... }
TenorTwoLyrics = \lyricmode { ... }
LeadOneMusic = \relative { ... }
LeadOneLyrics = \lyricmode { ... }
LeadTwoMusic = \relative { ... }
LeadTwoLyrics = \lyricmode { ... }
BariOneMusic = \relative { ... }
BariOneLyrics = \lyricmode { ... }
BariTwoMusic = \relative { ... }
BariTwoLyrics = \lyricmode { ... }
BassOneMusic = \relative { ... }
BassOneLyrics = \lyricmode { ... }
BassTwoMusic = \relative { ... }
BassTwoLyrics = \lyricmode { ... }
PianoRHMusic = \relative { ... }
PianoDynamics = { ... }
PianoLHMusic = \relative { ... }
TwoVoicesPerStaff = ##t (applies to all staves)
\include "BHStemplate.ly"

In addition, if there are sections in which two or more parts
are in unison, the following variables may also be defined:

TenorMusic = \relative { ... }
TenorLyrics = \lyricmode { ... }
LeadMusic = \relative { ... }
LeadLyrics = \lyricmode { ... }
BariMusic = \relative { ... }
BariLyrics = \lyricmode { ... }
BassMusic = \relative { ... }
BassLyrics = \lyricmode { ... }

All of the definitions are optional. Staves with no music will be
omitted from the output.

If TwoVoicesPerStaff is #f, music of the various voices may be
placed individually on one or two staves according to the
following variables, all of which default to #f:

UpperTwoVoicesPerStaff
TenorTwoVoicesPerStaff
LeadTwoVoicesPerStaff
BariTwoVoicesPerStaff
BassTwoVoicesPerStaff
LowerTwoVoicesPerStaff

Other variables, such as the instrumentName, shortInstrumentName
and MidiInstrument can also be changed by defining variables like
LeadInstrumentName, BassMidiInstrument, etc.  The prefixes for staves
containing two divided voices are UpperDivided and LowerDivided, etc
hence the corresponding variables would be UpperDividedInstrumentName,
etc.

The key is defined in the variable Key, and the structure of time
and repeats in the variable Time, using spacer rests.

A \layout block may be defined in the variable Layout.  There is
no default \header block.

The default \paper block can be modified if desired, but this may
overwrite the BHS notation manual settings. Use extreme caution,
or use another template (i.e. ssaattbb.ly).

Music may be tagged with #'print or #'play to be included only in
the printed score or in the MIDI file respectively.

%}

\include "BHStemplate-utils.ily"
\include "vocal-tkit-bhs.ily"
\include "piano-tkit.ly"

\pointAndClickOff

#(define footer-variable-names
  ;; These are the user-defined variables for bottom-of-page information
  '("Copyright"
    "PerformanceNotes"))

#(define option-variable-names
  ;; User-defined options (boolean)
  '("TagPage"
    "ShowTempoMarking"))

#(define-missing-variables! footer-variable-names)
#(define-missing-variables! option-variable-names)

%%% Set staff size to BHS Size:
%%% @Section A.1.d.
#(set-global-staff-size 20 )

                                % TODO: It would be nice if this could be included as a paper variable setting instead of as its own stand-alone component.
                                % TODO: I feel like I shouldn't have to override the font to get italics to work...
                                % TODO: I don't like the contest suitability line being hard-coded
                                % TODO: The way in which this was set up, there is a much smaller ammount of blank space between the end of the user-defined notes and the beginning of the contest suitiability line. Figure out how to equalize those spaces.
%%% Performance Notes
%%% @Section C.5
perfnotes = #(if PerformanceNotes
              #{
\markup {
  \override #'(line-width . 110)
  \left-column {
    \draw-hline
    \abs-fontsize #18 {
      \override #'(font-name . "Times Bold Italic") {
        \italic "Performance Notes"
      }
    }
    \abs-fontsize #10 {
      \override #'(font-name . "Times")
      \wordwrap-pstring #PerformanceNotes
    }
    \abs-fontsize #10 {
      \override #'(font-name . "Times")
      \wordwrap {
        As a final note: Questions about the contest suitability of this song/arrangement should be directed to the judging community and measured against current contest rules. Ask \override #'(font-name . "Times Italic") before you sing.
      }
    }
  }
}
              #}
              "")

\paper {
  page-breaking = #(if TagPage
                    ly:one-page-breaking
                    ly:optimal-breaking)

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
  % min-systems-per-page = 4
  max-systems-per-page = 5
                                % TODO: Code a solution to specifying max systems for first page
                                % Long story short, the optimal-breaking algorithm has to apply to every page. First page can have 3-4 systems. Other pages can have 4-5 systems. Leaving this out for now because it becomes unreadable sometimes otherwise.
  % max-systems-first-page = 4
  % min-systems-first-page = 3

  bookTitleMarkup = \markup {
    \override #'(baseline-skip . 3.5)
    \column {
      \override #'(baseline-skip . 3.5)
      \column {
%%% Title in 22 pt Arial Bold, all caps
%%% @Section A.4.a
        \fill-line {
          \abs-fontsize #22 {
            \override #'(font-name . "Arial Bold") {
              \capsfromproperty #'header:title
            }
          }
        }
%%% Subtitle in 12 pt Arial Bold, all caps, parentheses
%%% @Section A.4.b
        \fill-line {
          \abs-fontsize #12 {
            \override #'(font-name . "Arial Bold") {
              \concapsfromproperty #'header:subtitle #"(" #")"
            }
          }
        }
%%% Date if in public Domain, parentheses
%%% @Section A.5
        \fill-line {
          \abs-fontsize #12 {
            \override #'(font-name . "Arial Bold") {
              \concapsfromproperty #'header:date #"(" #")"
            }
          }
        }
%%% Additional Info in 10 pt Times New Roman Italic
%%% @Section A.10
        \fill-line {
          \abs-fontsize #10 {
            \override #'(font-name . "Times Italic") {
              \italic \fromproperty #'header:addinfo
            }
          }
        }
        \strut
        \strut
        \fill-line {
%%% Lyricist, Composer, and Arranger
%%% @Section A.6-8
          \abs-fontsize #12 {
            \override #'(font-name . "Times") {
              \ly-co-ar-qone #'header:lyricist #'header:composer #'header:arranger
            }
          }
          \abs-fontsize #12 {
            \override #'(font-name . "Times") {
              \ly-co-ar-qtwo #'header:lyricist #'header:composer #'header:arranger
            }
          }
        }
        \fill-line {
          \abs-fontsize #12 {
            \override #'(font-name . "Times") {
              \ly-co-ar-qthree #'header:lyricist #'header:composer #'header:arranger
            }
          }
          \abs-fontsize #12 {
            \override #'(font-name . "Times") {
              \ly-co-ar-qfour #'header:lyricist #'header:composer #'header:arranger
            }
          }
        }
        \strut
      }
    }
  }

  oddFooterMarkup = \markup {
    \column {
      \fill-line {
        \column {
          " "
%%% Copyright in 9 pt Times New Roman, on first page in each bookpart
%%% @Section A.14
          \on-the-fly #part-first-page
          \abs-fontsize #9 {
            \override #'(line-width . 110)
            \override #'(font-name . "Times")
            \wordwrap-string-centered #(if Copyright Copyright "")
          }
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
      \fromproperty #'header:title
      \on-the-fly #print-page-number-check-first \italic \fromproperty #'page:page-number-string
    }
  }


  evenHeaderMarkup = \markup

  \fill-line {
    \on-the-fly #not-part-first-page
    \abs-fontsize #12 {
      \on-the-fly #print-page-number-check-first \italic \fromproperty #'page:page-number-string
      \override #'(font-name . "Times Italic")
      \fromproperty #'header:title
    }
    %% force the header to take some space, otherwise the
    %% page layout becomes a complete mess.
    " "
  }
}

#(define BHStemplate-voice-prefixes
  ;; These define the permitted prefixes to various names.
  ;; They are combined with a fixed set of postfixes to form
  ;; names such as LeadMusic, BassInstrumentName, etc.
  ;; These names may be redefined.
  '("Lead"
    "LeadOne"
    "LeadTwo"
    "LeadDivided"
    "Bass"
    "BassOne"
    "BassTwo"
    "BassDivided"
    "LowerDivided"
    "Piano"
    "PianoLH"
    "PianoRH"
    "Solo"
    "Tenor"
    "TenorOne"
    "TenorTwo"
    "TenorDivided"
    "Bari"
    "BariOne"
    "BariTwo"
    "BariDivided"
    "UpperDivided"))

#(define BHStemplate-lyrics-postfixes
  ;; These define the permitted postfixes to the names of lyrics.
  ;; They are combined with the prefixes to form names like
  ;; LeadLyrics, etc.
  ;; These names may be redefined or extended.
  '("Lyrics"
    "LyricsOne"
    "LyricsTwo"
    "LyricsThree"
    "LyricsFour"))

#(define BHStemplate-lyrics-variable-names
  ;; These define the names which may be used to specify stanzas
  ;; which go between the two two-voice staves when TwoVoicesPerStaff
  ;; is set to #t.  They may be redefined or extended.
  '("VerseOne"
    "VerseTwo"
    "VerseThree"
    "VerseFour"
    "VerseFive"
    "VerseSix"
    "VerseSeven"
    "VerseEight"
    "VerseNine"))

%% make the above definitions available
#(set-music-definitions!
  BHStemplate-voice-prefixes
  BHStemplate-lyrics-postfixes
  BHStemplate-lyrics-variable-names)

#(define BHStemplate-variable-names
  ; Define names which are in addition to the base variable names
  ; of Time, Layout, Key, PianoDynamics and TwoVoicesPerStaff
  '("LeadTwoVoicesPerStaff"
    "BassTwoVoicesPerStaff"
    "LowerTwoVoicesPerStaff"
    "TenorTwoVoicesPerStaff"
    "BariTwoVoicesPerStaff"
    "UpperTwoVoicesPerStaff"
    "LeadShowBarNumbers"
    "LeadOneShowBarNumbers"
    "LeadTwoShowBarNumbers"
    "BassShowBarNumbers"
    "BassOneShowBarNumbers"
    "BassTwoShowBarNumbers"
    "TenorShowBarNumbers"
    "TenorOneShowBarNumbers"
    "TenorTwoShowBarNumbers"
    "BariShowBarNumbers"
    "BariOneShowBarNumbers"
    "BariTwoShowBarNumbers"
    "SoloClef"
    "Chords"))

%% and make them available
#(define-missing-variables! BHStemplate-variable-names)

#(if TwoVoicesPerStaff
  ; Set all staves to contain two voices
  (begin
   (set! LeadTwoVoicesPerStaff #t)
   (set! BassTwoVoicesPerStaff #t)
   (set! LowerTwoVoicesPerStaff #t)
   (set! TenorTwoVoicesPerStaff #t)
   (set! BariTwoVoicesPerStaff #t)
   (set! UpperTwoVoicesPerStaff #t)))

%% SoloClef defaults to "treble_8"
#(if (not SoloClef)
  (set! SoloClef "treble_8"))

%% Set up to force bar-number display for top divided staff if not specified otherwise by the user
#(define staff-order '("TenorOne" "TenorTwo" "Tenor" "Lead" "LeadOne" "LeadTwo" "BariOne" "BariTwo" "Bari" "Bass" "BassOne" "BassTwo"))
#(set-show-bar-num-top-staff! staff-order)
% #(display (map (lambda (v) (make-id v "ShowBarNumbers")) staff-order))

#(define (set-default-instr-names! voice)
  ; If the several instrument names and short instrument
  ; names have not been defined by the user, set them to
  ; the defaults "Tenor 1" and "S 1" etc with the same names
  ; in a column for the divided staves"
   (define (make-sym str1 str2)
     (string->symbol (string-append str1 str2)))

   (if (not (make-id voice "OneInstrumentName"))
       (ly:parser-define!
         (make-sym voice "OneInstrumentName")
          (string-append voice " 1")))
   (if (not (make-id voice "TwoInstrumentName"))
       (ly:parser-define!
         (make-sym voice "TwoInstrumentName")
          (string-append voice " 2")))
   (if (not (make-id voice "DividedInstrumentName"))
       (ly:parser-define!
         (make-sym voice "DividedInstrumentName")
         #{ \markup \right-column {
           #(if (make-id voice "OneMusic")
                  (make-id voice "OneInstrumentName") "")
           #(if (make-id voice "TwoMusic")
                (make-id voice "TwoInstrumentName") "") } #} ))
   (if (not (make-id voice "OneShortInstrumentName"))
       (ly:parser-define!
         (make-sym voice "OneShortInstrumentName")
         " "))
   (if (not (make-id voice "TwoShortInstrumentName"))
       (ly:parser-define!
         (make-sym voice "TwoShortInstrumentName")
         " "))
   (if (not (make-id voice "DividedShortInstrumentName"))
       (ly:parser-define!
         (make-sym voice "DividedShortInstrumentName")
         #{ \markup \right-column {
           #(if (make-id voice "OneMusic")
                (make-id voice "OneShortInstrumentName") "")
           #(if (make-id voice "TwoMusic")
                (make-id voice "TwoShortInstrumentName") "") } #} )))

#(set-default-instr-names! "Tenor")
#(set-default-instr-names! "Lead")
#(set-default-instr-names! "Bari")
#(set-default-instr-names! "Bass")

% TODO: I feel as if either a) the divided-staff-show-bar-nums? nonsense should go inside the staff creation function or b) this is just kind of silly how I'm doing it. Revisit this. But for now it works quite well actually.
BHSTEMPLATE =
<<
  #(if Chords
       #{ \new ChordNames { #Chords } #})
  \bhs-make-one-voice-vocal-staff "Solo" #SoloClef
  \new ChoirStaff
  <<
    #(if TenorTwoVoicesPerStaff
         #{ \bhs-make-two-voice-vocal-staff #(divided-staff-show-bar-nums? "TenorOne" "TenorTwo") "TenorDivided" "treble_8" "TenorOne" "TenorTwo" #}
         #{ << \bhs-make-one-voice-vocal-staff "TenorOne" "treble_8"
               \bhs-make-one-voice-vocal-staff "TenorTwo" "treble_8" >> #} )
    #(if UpperTwoVoicesPerStaff
         #{ \bhs-make-two-voice-vocal-staff #(divided-staff-show-bar-nums? "Tenor" "Lead") "UpperDivided" "treble_8" "Tenor" "Lead" #}
         #{ << \bhs-make-one-voice-vocal-staff "Tenor" "treble_8"
               \bhs-make-one-voice-vocal-staff "Lead" "treble_8" >> #} )
    #(if LeadTwoVoicesPerStaff
         #{ \bhs-make-two-voice-vocal-staff #(divided-staff-show-bar-nums? "LeadOne" "LeadTwo") "LeadDivided" "treble_8" "LeadOne" "LeadTwo" #}
         #{ << \bhs-make-one-voice-vocal-staff "LeadOne" "treble_8"
               \bhs-make-one-voice-vocal-staff "LeadTwo" "treble_8" >> #} )
    #(if BariTwoVoicesPerStaff
         #{ \bhs-make-two-voice-vocal-staff #(divided-staff-show-bar-nums? "BariOne" "BariTwo") "BariDivided" "bass" "BariOne" "BariTwo" #}
         #{ << \bhs-make-one-voice-vocal-staff "BariOne" "bass"
               \bhs-make-one-voice-vocal-staff "BariTwo" "bass" >> #} )
    #(if LowerTwoVoicesPerStaff
         #{ \bhs-make-two-voice-vocal-staff #(divided-staff-show-bar-nums? "Bari" "Bass") "LowerDivided" "bass" "Bari" "Bass" #}
         #{ << \bhs-make-one-voice-vocal-staff "Bari" "bass"
               \bhs-make-one-voice-vocal-staff "Bass" "bass" >> #} )
    #(if BassTwoVoicesPerStaff
         #{ \bhs-make-two-voice-vocal-staff #(divided-staff-show-bar-nums? "BassOne" "BassTwo") "BassDivided" "bass" "BassOne" "BassTwo" #}
         #{ << \bhs-make-one-voice-vocal-staff "BassOne" "bass"
               \bhs-make-one-voice-vocal-staff "BassTwo" "bass" >> #} )
  >>
>>

Piano = \make-pianostaff

\tagGroup #'(print play)

%%% Set global score attributes
\layout {
  \context {
    \Score
    %%% Number every measure
    %%% @Section A.12
    \override BarNumber.self-alignment-X = #LEFT
    \override TimeSignature.break-align-anchor-alignment = #RIGHT
    \override BarNumber.break-align-symbols = #'(time-signature key-signature)
    \override BarNumber.extra-spacing-width = #'(0 . 1)
    \override BarNumber.font-name = "Times"
    \override BarNumber.font-size = \absFontSize #10
    \override BarNumber.break-visibility = ##(#f #f #f)
    barNumberVisibility = #all-bar-numbers-visible

    %%% Format rehearsal marks
    %%% @Section A.11.a
    \override RehearsalMark.self-alignment-X = #LEFT

    %%% Set glissando style
    %%% @Section B.17 (assumed from example; section not actually included)
    \override Glissando.style = #'trill

    %%% Align instrument name correctly
    %%% @Section A.1.b
    \override InstrumentName.self-alignment-X = #LEFT

    %%% Optionally display tempo marking based on user specification
    tempoHideNote = #(not ShowTempoMarking)

    \remove Bar_number_engraver
  }
  \context {
    \Staff
    \override VerticalAxisGroup.remove-empty = ##t
    \override VerticalAxisGroup.remove-first = ##t
    \consists Bar_number_engraver
  }
  \context {
    \Lyrics
    \override LyricSpace.minimum-distance = #2.0
    \override LyricText.font-size = \absFontSize #11
  }
}

\book {
  \score {
    \keepWithTag #'print
    #(if have-music
         #{ << \BHSTEMPLATE \Piano >> #}
         #{ { } #} )
    \layout { $(if Layout Layout) }
  }
  \perfnotes
}

% TODO: Setting midiChannelMapping to "instrument" leads to dropped notes for some reason. Setting it to "staff" doesn't drop notes for a four-part arrangement, and continues to allow specification of midi instrument, but might result in running out of channels according to the documentation. Setting it to "voice" is what I had before, and it worked, but didn't allow me to change the midi instrument for individual voices. Investigate whether the current settings work for arrangements with more parts.
\book {
  \bookOutputSuffix "fullmix"
  \score {
    \keepWithTag #'play
    #(if have-music
         #{ << \BHSTEMPLATE \Piano >> #}
         #{ { } #} )
    \midi {
      \context {
        \Score
        % midiChannelMapping = #'instrument
        midiChannelMapping = #'staff
      }
    }
  }
}
