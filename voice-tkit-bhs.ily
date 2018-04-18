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
\include "base-tkit.ly"

%{
JEREMY'S NOTE:
This edited version of vocal-tkit.ly was created to allow me to change some hard-coded formatting placed in the
original version of the tkit, e.g. forced all-caps instrument names.
%}

make-voice-bhs =
#(define-music-function (name) (voice-prefix?)
   (define music (make-id name "Music"))
   (if music
       #{
         \new Voice = #(string-append name "Voice") <<
           #(if KeepAlive KeepAlive)
           #(if Time Time )
           {\bar ""}
           {#music \bar "|."}
         >>
       #} ))

