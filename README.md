jample
======

Jample lets a muscian rapidly discover and improvise samples from huge harddrives of music.


Jample slices every mp3 on your hardrive in advance, so you can instantly shuffle across huge music libraries searching for dopeness by ear. Samples always load on a beat or note. Once you find a dope sample, you can freeze it and continue to shuffly the remaining pads.







## INSTALL Rails Server for MAC

1) Install Xcode

2) Install homebrew using instructions here: http://brew.sh/

In terminal run the following commands:

2) `brew tap mongodb/brew`

2.5) `brew install mongodb-community`

3) `ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents`

4) `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist`

5) `cd ~/Documents/`

6) `git clone git@github.com:famulus/jample.git`

7) `cd jample/jample`

8) `sudo gem install bundler`

9) `bundle install`

10) `brew install aubio --with-python`

11) `brew install ffmpeg`

12) `brew install MP3SPLT`

12.5) `brew install youtube-dl`

13) `rake import_tracks`

14) `rake init`

15) `rails server`

16) download and install pure data extended: https://puredata.info/downloads/pd-extended

TODO: fix hardcoded paths in jample.pd

17) open pure data and setup midi and audio settings

18) Is you midi hardware showing up in pure data?

19) Are you able to hear sound coming from pure data?

20) JAMPLE!


## React Client

In terminal run the following commands:

1) `cd jample_react`

2) `npm start`

3) open a brower window, visit http://localhost:3001/



