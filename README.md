# Lilypond-BHS-Template
LilyPond does a very nice job of producing scores correctly notated, but the Barbershop Harmony Society has requirements for publication to maintain a consistent appearance across arrangements. The goal of this project is to allow the Barbershop arranger to worry more about the correct words and notes than whether the page looks right.

This repository specifies a template for LilyPond to make engraved scores that match the specifications in the [Barbershop Notation Manual][1]. The current implementation reflects the 2015-11-03 revision of the manual.

<!-- TODO: Copy over the source code for Shine On, Harvest Moon and include it as an example. Be sure to assign credit to Jeff Harris for the majority of the work. -->
<!-- As an example, this template comes with Shine On, Harvest Moon. The goal of this template is to make LilyPond's output of Shine On, Harvest Moon match that of Shine On Harvest Moon as shown in the Barbershop Notation Manual. -->

## License
Copyright 2014, 2018 Jeff Harris, Jeremy Marcus

See [LICENSE.txt][2] for details.

LilyPond, Frescobaldi, and this template are published under the GNU General Public License (http://www.gnu.org/licenses/gpl.html)

## Description/History of the Project
This project is based heavily upon two sources: the original LilyPond-BHS-Template project started by Jeff Harris, and the `ssaattbb.ly` template file and other `tkit.ly` utilities provided with installations of LilyPond. The former supplied a number of helpful layout functions and modifications to produce the correct layout (e.g. moving grobs, paper block, etc.). The latter provided a flexible, extensible, easy-to-use template structure that made the template code much more reusable.

Also included are a number of useful markup functions for common BHS markup (e.g. voice crossing, denoting sections of music, etc.).

<!-- TODO: Come back and update this once the example and tutorial documentation is in place. -->
<!-- For details on how to use this template, see REDACTED or REDACTED. -->

## Prerequisites
| Software | Version | Description |
| -------- | ------- | ----------- |
| [LilyPond][3] | 2.19+ | LilyPond is a cross-platform music engraving program, devoted to producing the highest-quality sheet music possible. It brings the aesthetics of traditionally engraved music to computer printouts. LilyPond is free software and part of the GNU Project. LilyPond compiles simple plain text files to output PDF and MIDI files, among other output formats. See http://www.lilypond.org/doc/v2.19/Documentation/learning/entering-input |

## Optional
| Software | Version | Description |
| -------- | ------- | ----------- |
| [Festival][4] | 2.5+ | University of Edinburgh's Festival Speech Synthesis Systems is a free software multi-lingual speech synthesis workbench that runs on multiple-platforms offering black box text to speech, as well as an open architecture for research in speech synthesis. It designed as a component of large speech technology systems. |
| [Frescobaldi][5] | any | Frescobaldi is a cross-platform LilyPond sheet music text editor. It aims to be powerful, yet lightweight and easy to use. |

## Changes From Original Version
* Slight adjustments to layout to reflect updated notation guidelines
* Complete re-structuring of template

[1]: www.barbershop.org/files/documents/getandmakemusic/Barbershop%20Notation%20Manual.pdf
[2]: ./blob/master/LICENSE.txt
[3]: lilypond.org
[4]: festvox.org/festival/
[5]: frescobaldi.org
