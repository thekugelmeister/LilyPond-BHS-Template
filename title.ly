%{

Copyright 2014 Jeff Harris
This is distributed under the terms of the GNU General Public License

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
along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

%}
\version "2.18.2"

% Title of the Song
% title = "Christmas Song"
title = "Shine On, Harvest Moon" % This should be uppercase on the title page

% subtitle
% subtitle = "(Chestnuts Roasing on an Open Fire)"
subtitle = ""

% Date, if public Domain
date = "(1908)"

% Lyricists, if not the composer
% lyricist = "Words by FRANK DAVID"
lyricist = "Words by JACK NORWORTH"

% secondlyricist = "and HARRY TOBIAS"
secondlyricist = ""

% Composer
composer = "Music by NORA BAYES-NORWORTH"

% Arranger
arranger = "Arranged by VAL HICKS and EARL MOON"

% Copyright. Bottom of first page
copyright = "This arrangement © 201_ SOMEONE. All Rights Reserved. No recording use, public performance for profit use or any other use requiring authorization, or reproduction or sale of copies in any form shall be made of or from this Arrangement unless licensed by the copyright owner or an agent or organization acting on behalf of the copyright owner."

% tagline appears at the bottom of the last page
tagline = "Questions about the contest suitability of this song/arrangement should be directed to the judging community and measured against current contest rules. Ask before you sing."

% Additional information
% assungby = "as sung by Bascom Avenue 4"
% assungby = "from the movie Awesome Movie"
% assungby = "for female voices"
assungby = "" % as sung by, from the movie, for female voices


global = {
    %% Key Signature at the beginning of the piece. If it changes, it will be explicity changed.
    \key bf \major

    %% Time Signature
    \time 2/2

%%%% STOP EDITING HERE
    \set Score.tempoHideNote = ##t
    \tempo 4=100
    \override Score.BarNumber.break-visibility = ##(#f #t #t)

}

