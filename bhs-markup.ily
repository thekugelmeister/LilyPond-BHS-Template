%% Add a voice crossing mark to a note ('x' placed above it).
voiceCross=#(define-event-function () ()
             #{
             ^\markup { \abs-fontsize #10 { \override #'(font-name . "Arial") x } }
             #}
           )
