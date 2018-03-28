%\version "2.19.22"
%{
JEREMY'S NOTES:
This edited version of staff-tkit.ly was created to allow me to change some hard-coded formatting placed in the
original version of the tkit, e.g. forced all-caps instrument names.
%}
\include "voice-tkit-bhs.ily"


%% Staff-oriented functions

% These assume the following lists have been defined:
%   voice-prefixes  eg "Soprano"
%   voice-postfixes  eg "Music"
%   lyrics-postfixes  eg "Lyrics"
%   lyrics-names  eg "VerseOne"
%   variable-names  eg "Time"
%
% The first three lists are used to generate compound
% names such as "SopranoLyrics" and "SopranoInstrumentName"
% The last two lists of names are used as-is.


bhs-make-one-voice-staff =
#(define-music-function (show-barNums show-instrName show-shortInstrName name clef dynamic-direction)
   ((boolean? #f) (boolean? #t) (boolean? #f) voice-prefix? string? (up-or-down? ""))

   "Make a staff with one voice (no lyrics)
       show-barNums: show bar numbers on this staff?
     show-instrName: show instrument names?
show-shortInstrName: show short instrument names?
               name: the default prefix for instrument name and music
               clef: the clef for this staff
  dynamic-direction: dynamics are up, down or neither"

   (define music (make-id name "Music"))
   (define instrName (make-id name "InstrumentName"))
   (define shortInstrName (make-id name "ShortInstrumentName"))
   (define midiName (make-id name "MidiInstrument"))
   (define dynUp (equal? dynamic-direction "Up"))
   (define dynDown (equal? dynamic-direction "Down"))
   (if music
     #{
       \new Staff = #(string-append name "Staff")
       \with {
         \override BarNumber.break-visibility = #(if show-barNums
                                                  #(#f #t #t)
                                                  #(#f #f #f))
         instrumentName = \markup {
           #(if show-instrName
                (if instrName instrName name)
                "")
         }
         shortInstrumentName = \markup {
           #(if show-shortInstrName
                (cond
                 (shortInstrName shortInstrName)
                 (instrName (substring instrName 0 1))
                 (else (substring name 0 1)))
                "")
         }
         midiInstrument = #(if midiName midiName "voice oohs")
         #(cond
           (dynUp dynamicUp)
           (dynDown dynamicDown)
           (else dynamicNeutral))

       }
       {
         #(if Key Key)
         \clef #clef
         \make-voice-bhs #name
       }
     #}
     (make-music 'SequentialMusic 'void #t)))


bhs-make-two-voice-staff =
#(define-music-function (show-barNums show-instrName show-shortInstrName name clef v1name v2name)
   ((boolean? #f) (boolean? #t) (boolean? #f) voice-prefix? string? voice-prefix? voice-prefix?)

   "Make a vocal staff with two voices
       show-barNums: show bar numbers on this staff?
     show-instrName: show instrument names?
show-shortInstrName: show short instrument names?
               name: the prefix to the staff name
               clef: the clef to use
             v1name: the prefix to the name of voice one
             v2name: the prefix to the name of voice two"

   (define v1music (make-id v1name "Music"))
   (define v2music (make-id v2name "Music"))
   (define instrName (make-id name "InstrumentName"))
   (define v1InstrName (make-id v1name "InstrumentName"))
   (define v2InstrName (make-id v2name "InstrumentName"))
   (define shortInstrName (make-id name "ShortInstrumentName"))
   (define v1ShortInstrName (make-id v1name "ShortInstrumentName"))
   (define v2ShortInstrName (make-id v2name "ShortInstrumentName"))
   (define v1midiName (make-id v1name "MidiInstrument"))
   (define v2midiName (make-id v2name "MidiInstrument"))
   (if (or v1music v2music)
       #{
         <<
           \new Staff = #(string-append name "Staff")
           \with {
             \override BarNumber.break-visibility = #(if show-barNums
                                                      #(#f #t #t)
                                                      #(#f #f #f))
             \remove "Staff_performer"
             instrumentName =
               #(if show-instrName
                 (if instrName
                  #{ \markup #instrName #}
                  #{ \markup \left-column {
                  #(if v1music
                    (if v1InstrName v1InstrName v1name)
                    "")
                  #(if v2music
                    (if v2InstrName v2InstrName v2name)
                    "")
                 } #} )
                 #{ \markup "" #})
             shortInstrumentName =
               #(if show-shortInstrName
                 (if shortInstrName
                  #{ \markup #shortInstrName #}
                  #{ \markup \left-column {
                    #(if v1music
                         (cond
                          (v1ShortInstrName v1ShortInstrName)
                          (v1InstrName (substring v1InstrName 0 1))
                          (else (substring v1name 0 1)))
                         "")
                    #(if v2music
                         (cond
                          (v2ShortInstrName v2ShortInstrName)
                          (v2InstrName (substring v2InstrName 0 1))
                          (else (substring v2name 0 1)))
                         "")
                  } #} )
               #{ \markup "" #})
           }
           <<
             #(if Key Key)
             \clef #clef

             #(if v1music
               #{
                 \new Voice = #(string-append v1name "Voice")
                 \with {
                   \consists "Staff_performer"
                   \dynamicUp
                   midiInstrument =
                     #(if v1midiName v1midiName "voice oohs")
                 }
                 <<
                   #(if KeepAlive KeepAlive)
                   #(if Time Time)
                   #(if v2music voiceOne oneVoice)
                   {\bar ""}
                   {#v1music \bar "|."}
                 >>
               #} )

             #(if v2music
               #{
                 \new Voice = #(string-append v2name "Voice")
                 \with {
                   \consists "Staff_performer"
                   \dynamicDown
                   midiInstrument =
                     #(if v2midiName v2midiName "voice oohs")
                 }
                 <<
                   #(if KeepAlive KeepAlive)
                   #(if Time Time)
                   #(if v1music voiceTwo oneVoice)
                   {\bar ""}
                   {#v2music \bar "|."}
                 >>
               #} )
           >>
         >>
       #}
        (make-music 'SequentialMusic 'void #t)))
