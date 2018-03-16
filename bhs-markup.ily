%% voiceCross: Add a voice crossing mark to a note ('x' placed above it).
voiceCross=#(define-event-function () ()
             #{
             ^\markup { \abs-fontsize #10 { \override #'(font-name . "Arial") x } }
             #}
           )

%% voiceCrosses: Mark the given set notes as crossed.
voiceCrosses =
#(define-music-function
  (parser location music)
  (ly:music?)
  (map-some-music voiceCross music)
)


%% newSection: Demarcate new section with a double bar line and a label
newSection =
#(define-music-function
  (parser location text)
  (markup?)
  #{
  \bar "||" \mark \markup { \abs-fontsize #12 { \override #'(font-name . "Times Bold") #text } }
  #}
)

%% http://lsr.di.unimi.it/LSR/Item?id=538
%% optionalNotes: Given a chord, makes the first note normal size and the remaining notes a smaller size.
optionalNotes =
#(define-music-function (parser location x) (ly:music?)
  (music-map (lambda (x)
              (if (eq? (ly:music-property x 'name) 'EventChord)
               (let ((copy (ly:music-deep-copy x)))
                (let ((elements (cdr (ly:music-property copy 'elements))))
                 (while (pair? elements)
                  (ly:music-set-property! (first elements) 'tweaks
                   (acons 'font-size -3 (ly:music-property (car elements)
                                         'tweaks)))
                  (set! elements (cdr elements))))
                copy) x))
   x))

%% skips: Insert a given number of lyric skips
skips =
#(define-music-function
  (parser location nskips)
  (integer?)
  #{
  \repeat unfold #nskips { \skip 1 }
  #}
)