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



This is a project to create a template for LilyPond to make engraved scores match the Barbershop Notation Manual. The Barbershop Notation Manual may be found at http://barbershop.org/document-center/category/18-arrangement-notation-forms.html

Using the 2013-07-11 revision.

LilyPond does a very nice job of producing scores correctly notated, but the Barbershop Harmony Society has requirements for publication to maintain a consistent appearance across arrangements.

This repository is designed to allow the Barbershop arranger to worry more about the correct words and notes than whether the page looks right.

As an example, this template comes with Shine On, Harvest Moon. The goal of this template is to make LilyPond's output of Shine On, Harvest Moon match that of Shine On Harvest Moon as shown in the Barbershop Notation Manual.

For the arranger, modify title.ly. Update the key and time signatures and the song data. Update the words and music found in each part's folder. Optionally, change the name of score.ly to <<Name Of Song>>.ly and run score.ly through LilyPond.

PREREQUISITES
You need LilyPond from lilypond.org
Optionally, use Frescobaldi from http://frescobaldi.org/

LILYPOND
LilyPond is a cross-platform music engraving program, devoted to producing the highest-quality sheet music possible. It brings the aesthetics of traditionally engraved music to computer printouts. LilyPond is free software and part of the GNU Project. LilyPond compiles simple plain text files to output PDF and MIDI files, among other output formats. See http://www.lilypond.org/doc/v2.18/Documentation/learning/entering-input

The current version of LilyPond, for which this template is designed is 2.18.2

This example shows a simple input file:

    \version "2.18.2"
    {
      c' e' g' e'
    }


FRESCOBALDI
Frescobaldi is a cross-platform LilyPond sheet music text editor. It aims to be powerful, yet lightweight and easy to use.

LilyPond, Frescobaldi, and this template are published under the GNU General Public License (http://www.gnu.org/licenses/gpl.html)