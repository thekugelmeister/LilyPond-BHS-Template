\version "2.19.49"
\include "festival.ly"
#(use-modules (ice-9 format))

                                % TODO: Right now you have to run BHStemplate.ily first to initialize everything. Maybe make it stand-alone? Is it worth it?
                                % TODO: Document available versions of processing (syl/slow,etc.) and when to use them.

#(define festival-variable-names
  ;; User-defined options (boolean)
  '("RunFestival"
    "FestivalSyllabify"
    "FestivalSlow"
    "FestivalNoCleanup"))

#(define-missing-variables! festival-variable-names)

                                % TODO: This relies on the staff-order variable defined in BHStemplate.ily. Not bad for being generic for future templates, but this should be documented or changed.
#(define festival-voices (filter (lambda (vp)
                                  (and
                                   (make-id vp "Music")
                                   (make-id vp "Lyrics")))
                          staff-order))

%% \festivalsylslow #"filename" { \tempo N = X } { music }
%% Standard festival output, adjusted to half speed (1 octave down, half as fast) and syllabified if desired.
festivalsylslow =
#(define-music-function
  (filename tempo music)
  (string? ly:music? ly:music?)
  (let ((octave-shift (if FestivalSlow -1 0)))
   (parameterize ((*syllabify* FestivalSyllabify)
                  (*base-octave-shift* octave-shift))
    (output-file music tempo filename)))
  music)

%% Make a single festival book (to output festival xml file) and run festival on output
festivalsylslow-voicebook =
#(define-void-function
  (voicename)
  (voice-prefix?)
  #{
  \book {
    \bookOutputName #(string-append voicename "festival")
    \score {
      \festivalsylslow #(string-append voicename ".xml") { \Time } {
        \bhs-make-one-voice-vocal-staff ##f #voicename "treble"
      }
    }
  }
  #}
  (format #t "\nProcessing Festival XML file ~a.xml..."
   voicename)
  (system (format #f "text2wave -mode singing ~a.xml -o ~a.wav" 
           voicename
           voicename)))

%% Clean up after festival processing for a single voice
festival-voicecleanup =
#(define-void-function
  (voicename)
  (voice-prefix?)
  (system (format #f "rm ~a.xml ~a.wav"
           voicename
           voicename)))

bhs-festival =
#(define-void-function
  ()
  ()
  (format #t "\nRunning Festival for the following voices: ~a" festival-voices)
  (map festivalsylslow-voicebook festival-voices)
  (display "\nCombining parts...")
  (if FestivalSlow
   (begin
    (system (format #f "sox -m ~{~a.wav ~} festivalslow.wav"
             festival-voices))
    (display "\nCorrecting speed...")
    (system (format #f "sox festivalslow.wav ~a.wav speed 2"
             (ly:parser-output-name))))
   (system (format #f "sox -m ~{~a.wav ~} ~a.wav"
            festival-voices
            (ly:parser-output-name))))
  (if (not FestivalNoCleanup)
   (begin
    (display "\nCleaning up after Festival processing...")
    (map festival-voicecleanup festival-voices)
    (if FestivalSlow
     (system "rm festivalslow.wav")))))
