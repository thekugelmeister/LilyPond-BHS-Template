tenorMusic = \relative c'' {
  % dynamic marking is only for Midi track and should be removed before printing
  \set midiInstrument = #"clarinet"
  g2 \(-\omit\p^\markup \bold  "Intro"  fs |
  g1~ |
  g1 |
  fs2. \) s4 |

}