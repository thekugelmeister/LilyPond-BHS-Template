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

%\version "2.19.22"
\include "lyrics-tkit.ly"
\include "staff-tkit-bhs.ily"

%{
JEREMY'S NOTE:
This edited version of vocal-tkit.ly was created to allow me to change some hard-coded formatting placed in the
original version of the tkit, e.g. forced all-caps instrument names.
%}

bhs-make-one-voice-vocal-staff =
#(define-music-function (show-barNums name clef)
   ((boolean? #t) voice-prefix? string?)

  "Make a staff with one voice and lyrics beneath
show-barNums: show bar numbers on this staff?
        name: the default prefix for instrument name and music
        clef: the clef for this staff "
  (if (make-id name "Music")
      (make-simultaneous-music
       (list
        (bhs-make-one-voice-staff show-barNums name clef "Up")
        (make-simultaneous-music
          (reverse (map
            (lambda (lyrics-postfix)
              (make-one-stanza "Below" name name lyrics-postfix))
              lyrics-postfixes)))))
      (make-music 'SequentialMusic 'void #t)))

bhs-make-two-voice-vocal-staff =
#(define-music-function (show-barNums name clef v1name v2name)
   ((boolean? #f) voice-prefix? string? voice-prefix? voice-prefix?)

  "Make a vocal staff with two voices and lyrics above and below
show-barNums: show bar numbers on this staff?
        name: the prefix to the staff name
        clef: the clef to use
      v1name: the prefix to the name of voice one
      v2name: the prefix to the name of voice two "

  (define v1music (make-id v1name "Music"))
  (define v2music (make-id v2name "Music"))

  (make-simultaneous-music
   (delq! #f
    (list
     (bhs-make-two-voice-staff show-barNums name clef v1name v2name)
     (and v1music
          (make-simultaneous-music
           (map
            (lambda (lyrics-postfix)
              (make-one-stanza "Above" name v1name lyrics-postfix))
            lyrics-postfixes)))

     (and v2music
          (make-simultaneous-music
           (reverse
            (map
             (lambda (lyrics-postfix)
               (make-one-stanza "Below" name v2name lyrics-postfix))
             lyrics-postfixes))))))))

make-two-vocal-staves-with-stanzas =
#(define-music-function
  (show-barNums upperName upperClef lowerName lowerClef
    v1name v2name v3name v4name verses)
  ((boolean? #f) voice-prefix? string? voice-prefix? string?
    voice-prefix? voice-prefix? voice-prefix? voice-prefix? list?)

  "Make two two-voice vocal staves with several stanzas between them.
The number of stanzas is determined by the number of populated verse names.
show-barNums: show bar numbers on this staff?
   upperName: the prefix to the upper staff name
   upperClef: the clef to use on the upper staff
   lowerName: the prefix to the lower staff name
   lowerClef: the clef to use on the lower staff
      vxname: the prefix to the name of voice x, x = 1..4
      verses: the list of verse names containing the stanzas"

  (make-simultaneous-music
   (list
    (bhs-make-two-voice-vocal-staff
     show-barNums upperName upperClef v1name v2name)
    (make-simultaneous-music
     (map
      (lambda (verse-name)
        (make-one-stanza
         upperName v1name v2name verse-name))
        verses))
    (bhs-make-two-voice-vocal-staff
     show-barNums lowerName lowerClef v3name v4name))))

