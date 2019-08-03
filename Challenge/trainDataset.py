import os
import glob
import numpy as np
import re
import scipy.io.wavfile
import torch
import torch.utils.data as data
import torchvision.transforms as transforms
from sklearn.preprocessing import LabelEncoder


class TrainDataset(data.Dataset):
    """Pytorch dataset for instruments
    args:
        root: root dir containing an audio directory with wav files.
        transform (callable, optional): A function/transform that takes in
                a sample and returns a transformed version.
        blacklist_patterns: list of string used to blacklist dataset element.
            If one of the string is present in the audio filename, this sample
            together with its metadata is removed from the dataset.
    """

    def __init__(self, root, transform=None, blacklist_patterns=[]):
        assert(isinstance(root, str))
        assert(isinstance(blacklist_patterns, list))

        self.root = root
        self.filenames = glob.glob(os.path.join(root, "audio/*.wav"))

        for pattern in blacklist_patterns:
            self.filenames = self.blacklist(self.filenames, pattern)
            
        self.labelEncoder = LabelEncoder()
        self.labelEncoder.fit(np.unique(self._instrumentsFamily(self.filenames)))
            
        self.transform = transform
        
    def transformInstrumentsFamilyToString(self, targets=[]):
        return self.labelEncoder.inverse_transform(targets)
                    
    def _instrumentsFamily(self, filenames):
        instruments = np.zeros(len(filenames), dtype=object)
        for i, file_name in enumerate(filenames):
            no_folders = re.compile('\/').split(file_name)[-1]
            instruments[i] = re.compile('_').split(no_folders)[0]
        return instruments
    
    def blacklist(self, filenames, pattern):
        return [filename for filename in filenames if pattern not in filename]

    def __len__(self):
        return len(self.filenames)

    def __getitem__(self, index):
        name = self.filenames[index]
        _, sample = scipy.io.wavfile.read(name)
        
        target = self._instrumentsFamily([name])
        categorical_target = self.labelEncoder.transform(target)[0]
                
        if self.transform is not None:
            sample = self.transform(sample)
        return [sample, categorical_target]
