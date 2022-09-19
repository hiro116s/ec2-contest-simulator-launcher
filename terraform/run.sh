#!/bin/sh
export PATH="$HOME/.cargo/bin:$PATH"

cd /home/ubuntu/atcoder_library/src/main/java
git checkout ahc14
git pull
javac Main.java
./run.sh 1 # dry run
java -cp /home/ubuntu/heuristics-contest-library-1.0-SNAPSHOT.jar hiro116s.simulator.MarathonCodeSimulator --commandTemplate './run.sh $SEED' --minSeed 0 --maxSeed 499 --s3 --contestName ahc14 --numThreads 30
