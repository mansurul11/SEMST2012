#!/bin/bash

MALLET_DIST=/opt/local/share/java/mallet-2.0.7/dist
export MALLET_CLASSPATH=$MALLET_DIST/mallet.jar:$MALLET_DIST/mallet-deps.jar

export CLASSPATH=out/production/SEMST2012:src 

TRAINING_DATA=data/starsem-st-2012-data/cd-sco/corpus/training/SEM-2012-SharedTask-CD-SCO-training-09032012.txt

echo "Converting files..."

./train_final.groovy "$TRAINING_DATA"

echo "Training scope classifier..."

java -d32 -Xmx800m -cp "$MALLET_CLASSPATH" cc.mallet.fst.SimpleTagger --train true --model-file data/scope.model --threads 8 data/train.scope.txt 2>data/err.txt >data/out.txt

java -d32 -Xmx800m -cp "$MALLET_CLASSPATH" cc.mallet.fst.SimpleTagger --model-file data/scope.model data/train.scope.txt >data/output.train.scope.txt

./convert_scope_to_conll.groovy $TRAINING_DATA data/output.train.scope.txt output.training.conll.txt true

#./eval.cd-sco.pl -g data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt -s data/output.training.conll.txt  

echo "Training event classifier..."

java -d32 -Xmx800m -cp "$MALLET_CLASSPATH" cc.mallet.fst.SimpleTagger --train true --model-file data/event.model --threads 8 data/train.event.txt 2>data/err.txt >data/out.txt

java -d32 -Xmx800m -cp "$MALLET_CLASSPATH" cc.mallet.fst.SimpleTagger --model-file data/event.model data/train.event.txt >data/output.train.event.txt

./convert_event_to_conll.groovy "$TRAINING_DATA" data/output.train.event.txt data/output.training.conll.txt true
  
#./eval.cd-sco.pl -g data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt -s data/output.training.conll.txt  
