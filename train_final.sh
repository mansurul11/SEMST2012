#!/bin/bash

export CLASSPATH=out/production/SEMST2012:src 

./train_final.groovy

java -d32 -Xmx800m -cp /opt/local/share/java/mallet-2.0.7/dist/mallet.jar:/opt/local/share/java/mallet-2.0.7/dist/mallet-deps.jar cc.mallet.fst.SimpleTagger --train true --model-file data/scope.model --threads 8 data/train.scope.txt 2>data/err.txt >data/out.txt

java -d32 -Xmx800m -cp /opt/local/share/java/mallet-2.0.7/dist/mallet.jar:/opt/local/share/java/mallet-2.0.7/dist/mallet-deps.jar cc.mallet.fst.SimpleTagger --model-file data/scope.model data/train.scope.txt >data/output.train.scope.txt

./convert_scope_to_conll.groovy data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt data/output.train.scope.txt output.training.conll.txt true

#./eval.cd-sco.pl -g data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt -s data/output.training.conll.txt  

java -d32 -Xmx800m -cp /opt/local/share/java/mallet-2.0.7/dist/mallet.jar:/opt/local/share/java/mallet-2.0.7/dist/mallet-deps.jar cc.mallet.fst.SimpleTagger --train true --model-file data/event.model --threads 8 data/train.event.txt 2>data/err.txt >data/out.txt

java -d32 -Xmx800m -cp /opt/local/share/java/mallet-2.0.7/dist/mallet.jar:/opt/local/share/java/mallet-2.0.7/dist/mallet-deps.jar cc.mallet.fst.SimpleTagger --model-file data/event.model data/train.event.txt >data/output.train.event.txt

./convert_event_to_conll.groovy data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt data/output.train.event.txt output.training.conll.txt
  
#./eval.cd-sco.pl -g data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt -s data/output.training.conll.txt  

./cue_finder.groovy data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt data/sys0t.train.conll.txt

./convert_conll_to_mallet.groovy data/sys0t.train.conll.txt true
  
java -d32 -Xmx800m -cp /opt/local/share/java/mallet-2.0.7/dist/mallet.jar:/opt/local/share/java/mallet-2.0.7/dist/mallet-deps.jar cc.mallet.fst.SimpleTagger --model-file data/scope.model data/scope.sys0t.train.conll.txt >data/sys1t.train.scope.txt

./convert_scope_to_conll.groovy data/sys0t.train.conll.txt data/sys1t.train.scope.txt data/sys1t.train.conll.txt true

./convert_conll_to_mallet.groovy data/sys1t.train.conll.txt true
 
java -d32 -Xmx800m -cp /opt/local/share/java/mallet-2.0.7/dist/mallet.jar:/opt/local/share/java/mallet-2.0.7/dist/mallet-deps.jar cc.mallet.fst.SimpleTagger --model-file data/event.model data/event.sys1t.train.conll.txt >data/sys2t.train.event.txt

./convert_event_to_conll.groovy data/sys1t.train.conll.txt data/sys2t.train.event.txt data/syst.train.conll.txt true
  
#./eval.cd-sco.pl -g data/SEM-2012-SharedTask-CD-SCO-09032012b/combined.txt -s data/syst.train.conll.txt  

#./canonicalize_conll.groovy data/syst.train.conll.txt data/systc.train.conll.txt

