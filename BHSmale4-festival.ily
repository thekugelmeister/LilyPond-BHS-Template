\version "2.19.49"

                                % TODO: Putting it in syllabify mode ensures that strange syllables get treated as full valued notes, but a lot of words are pronounced wrong as a result.
                                % TODO: Chipmunk voices are preferable to tempo limiations and pitch issues for tenor. But if we can avoid the chipmunk voices, it would be better...
                                % TODO: Stop printing layout...

\include "festival.ly"
% \festivalsylslow #"filename" { \tempo N = X } { music }
festivalsylslow =
#(define-music-function (filename tempo music)
  (string? ly:music? ly:music?)
  (parameterize ((*syllabify* #t)
                 (*base-octave-shift* -1))
   (output-file music tempo filename))
  music)

\book {
  \bookOutputName "tenorfestival"
  \score {
    \festivalsylslow #"tenor.xml" { \Time } {
      <<
        \Key
        \Time
        \context Voice = tenors {
          \keepWithTag #'play \TenorMusic
        }
        \context Lyrics = tenorlyrics \lyricsto tenors \TenorLyrics
      >>
    }
  }
}

\book {
  \bookOutputName "leadfestival"
  \score {
    \festivalsylslow #"lead.xml" { \Time } {
      <<
        \Key
        \Time
        \context Voice = leads {
          \keepWithTag #'play \LeadMusic
        }
        \context Lyrics = leadlyrics \lyricsto leads \LeadLyrics
      >>
    }
  }
}

\book {
  \bookOutputName "barifestival"
  \score {
    \festivalsylslow #"bari.xml" { \Time } {
      <<
        \Key
        \Time
        \context Voice = baris {
          \keepWithTag #'play \BariMusic
        }
        \context Lyrics = barilyrics \lyricsto baris \BariLyrics
      >>
    }
  }
}

\book {
  \bookOutputName "bassfestival"
  \score {
    \festivalsylslow #"bass.xml" { \Time } {
      <<
        \Key
        \Time
        \context Voice = basss {
          \keepWithTag #'play \BassMusic
        }
        \context Lyrics = basslyrics \lyricsto basss \BassLyrics
      >>
    }
  }
}

%% Run Festival on all files
#(system "text2wave -mode singing tenor.xml -o tenor.wav")
#(system "text2wave -mode singing lead.xml -o lead.wav")
#(system "text2wave -mode singing bari.xml -o bari.wav")
#(system "text2wave -mode singing bass.xml -o bass.wav")

%% Combine parts
#(system "sox -m tenor.wav lead.wav bari.wav bass.wav festivalslow.wav")
#(system (string-append "sox festivalslow.wav " (ly:parser-output-name) ".wav speed 2"))
% #(system (string-append "sox -m tenor.wav lead.wav bari.wav bass.wav " (ly:parser-output-name) ".wav"))

%% Clean up
#(system "rm tenor.xml tenor.wav tenorfestival.pdf lead.xml lead.wav leadfestival.pdf bari.xml bari.wav barifestival.pdf bass.xml bass.wav bassfestival.pdf festivalslow.wav")
