\version "2.19.49"

                                % TODO: This requires that the user includes two sets of lyrics for each part. If I can avoid that, I should...

%% FESTIVAL
\include "festival.ly"
\festival #"tenor.xml" { \Time } {
  <<
    \Key
    \Time
    \context Voice = tenors {
      \removeWithTag #'layout \TenorMusic
    }
    \context Lyrics = tenorlyrics \lyricsto tenors \tenorFestival
  >>
}

\festival #"lead.xml" { \Time } {
  <<
    \Key
    \Time
    \context Voice = leads {
      \removeWithTag #'layout \LeadMusic
    }
    \context Lyrics = leadlyrics \lyricsto leads \leadFestival
  >>
}

\festival #"bari.xml" { \Time } {
  <<
    \Key
    \Time
    \context Voice = baris {
      \removeWithTag #'layout \BariMusic
    }
    \context Lyrics = barilyrics \lyricsto baris \bariFestival
  >>
}

\festival #"bass.xml" { \Time } {
  <<
    \Key
    \Time
    \context Voice = basses {
      \removeWithTag #'layout \BassMusic
    }
    \context Lyrics = basslyrics \lyricsto basses \bassFestival
  >>
}

%% Run Festival on all files
#(system "text2wave -mode singing tenor.xml -o tenor.wav")
#(system "text2wave -mode singing lead.xml -o lead.wav")
#(system "text2wave -mode singing bari.xml -o bari.wav")
#(system "text2wave -mode singing bass.xml -o bass.wav")

%% Combine parts
#(system (string-append "sox -m tenor.wav lead.wav bari.wav bass.wav " (ly:parser-output-name) ".wav"))

%% Clean up
#(system "rm tenor.xml tenor.wav lead.xml lead.wav bari.xml bari.wav bass.xml bass.wav")
