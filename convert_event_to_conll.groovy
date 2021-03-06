#!/usr/bin/env groovy

// This should be more properly called "merge_event_with_conll.groovy".
// It takes three arguments:
//    0) Path to source CoNLL file,
//    1) Path to MALLET format file with event classifier outputs,
//    2) Path to destination CoNLL file which will be the source CoNLL file with the event judgements merged in.

data_dir = new File('data')
scope_dir = new File(data_dir, 'SEM-2012-SharedTask-CD-SCO-09032012b')

train_file = args.size() < 3 ? new File(scope_dir, 'SEM-2012-SharedTask-CD-SCO-training-09032012.txt') : new File(args[0])
dev_file = new File(scope_dir, 'SEM-2012-SharedTask-CD-SCO-dev-09032012.txt')

train_event_output = args.size() < 3 ? new File(data_dir, "output.train.event.txt") : new File(args[1])
dev_event_output = new File(data_dir, "output.dev.event.txt")

sys_train_file = args.size() < 3 ? new File(data_dir, "output.training.conll.txt") : new File(args[2])
sys_dev_file = new File(data_dir, "output.dev.conll.txt")

def decoder = new CoNLLDecode()

//println "convert_event_to_conll($train_event_output, $train_file, $sys_train_file)"

decoder.convert_event_to_conll((args.size() < 3 || (args[3] as Boolean)), train_event_output, train_file, sys_train_file)
if (args.size() < 3) decoder.convert_event_to_conll(false, dev_event_output, dev_file, sys_dev_file)
