%{
Copyright 2018 Jeremy Marcus
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

\version "2.19.49"
\include "festival.ly"
#(use-modules (ice-9 format))

                                % TODO: Right now you have to run BHStemplate.ily first to initialize everything. Maybe make it stand-alone? Is it worth it?
                                % TODO: sox crashes when only one voice part provided.
                                % TODO: Make FestivalHalfTempo work automatically, instead of requiring user to change tempo globally.
                                % TODO: Should FestivalOctaveDown and FestivalHalfTempo be mutually exclusive options?

%{
FestivalOctaveDown must be used if any part hits a note over 500 Hz (B5 by Festival standards, B4 by most other standards).
This is due to a bug in Festival, in "festival/src/modules/UniSyn/us_prosody.cc" (I am virtually certain). In the
function "f0_to_pitchmarks", there is a hard-coded limit of 500 when checking the frequency track, which attempts to
re-assign any offending frequencies to the frequency of the previous element of the array, without bounds checking.
This is why Festival reproducibly segfaults if the first note is B5 or higher, but changes later too-high notes to B5
and works at other times.

See "speech_tools/sigpr/pda/srpd.h" for more evidence (more hard-coded limits, albeit at different magnitudes).
%}
#(define festival-variable-names
  ;; User-defined options (boolean)
  '("RunFestival"
    "FestivalSyllabify"
    "FestivalOctaveDown"
    "FestivalHalfTempo"
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
  (let ((octave-shift (if FestivalOctaveDown -1 0)))
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
  (if FestivalOctaveDown
   (begin
    (system (format #f "sox -m ~{~a.wav ~} festivalslow.wav"
             festival-voices))
    (display "\nCorrecting speed...")
    (system (format #f "sox festivalslow.wav ~a.wav speed 2"
             (ly:parser-output-name))))
   (system (format #f "sox -m ~{~a.wav ~} ~a.wav"
            festival-voices
            (ly:parser-output-name))))
  (if FestivalHalfTempo
   (begin
    (system (format #f "sox -m ~{~a.wav ~} festivalslow.wav"
             festival-voices))
    (display "\nCorrecting tempo...")
    (system (format #f "sox festivalslow.wav ~a.wav tempo 2"
             (ly:parser-output-name))))
   (system (format #f "sox -m ~{~a.wav ~} ~a.wav"
            festival-voices
            (ly:parser-output-name))))
  (if (not FestivalNoCleanup)
   (begin
    (display "\nCleaning up after Festival processing...")
    (map festival-voicecleanup festival-voices)
    (if (or FestivalOctaveDown FestivalHalfTempo)
     (system "rm festivalslow.wav")))))
