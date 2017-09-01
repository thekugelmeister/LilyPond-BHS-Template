%% voiceCross: Add a voice crossing mark to a note ('x' placed above it).
voiceCross=#(define-event-function () ()
             #{
             ^\markup { \abs-fontsize #10 { \override #'(font-name . "Arial") x } }
             #}
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
