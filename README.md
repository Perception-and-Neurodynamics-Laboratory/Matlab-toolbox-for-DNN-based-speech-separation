## Matlab toolbox for DNN-based speech separation
This folder contains Matlab programs for a toolbox for supervised speech separation using deep neural networks (DNNs). This toolbox is composed by Jitong Chen, based on an earlier version written by Yuxuan Wang. The toolbox is further improved by Yuzhou Liu. 

For technical details about DNN-based speech separation see the following paper:

> Wang Y., Narayanan A. and Wang D.L. (2014): [On training targets for supervised speech separation](http://www.cse.ohio-state.edu/~dwang/papers/WNW.taslp14.pdf). IEEE/ACM Transactions on Audio, Speech, and Language Processing, vol. 22, pp. 1849-1858.

The toolbox is provided by the OSU Perception and Neurodynamics Laboratory (PNL).

- - -

### Description of folders and files

**config/**  
Lists of clean utterances for training and test.

**DATA/**  
Mixtures, features, masks and separated speech are stored here.

**dnn/**  
Code for DNN training and test, where dnn/main/ includes key functions for DNN training and test. dnn/pretraining/ includes code for unsupervised DNN pretraining.

**gen_mixture/**  
Code for creating mixtures from noise and clean utterances.

**get_feat/**  
Code for acoustic features and ideal mask calculation.

**premix_data/**  
Sample data including clean speech and factory noise.

**load_config.m**  
It configures feature type, noise type, training utterance list, test utterance list, mixture SNR, mask type, etc.

**RUN.m**  
It loads configurations from load_config.m and runs a speech separation demo.


