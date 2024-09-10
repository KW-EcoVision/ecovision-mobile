import cv2
import numpy as np
from torch.utils.data import Dataset, DataLoader
import torch
from utils import create_label_at_one_xml_path,get_augmentor, split_xml_path
from PIL import Image as image


class Dataset(Dataset):
    def __init__(self,xml_arr,img_dir):
        self.xml_np = xml_arr
        self.img_dir = img_dir
        self.augmentor = get_augmentor()
        self.img = torch.from_numpy(np.zeros(shape=(len(self.xml_np),3,224,224))).float()
        self.label = torch.from_numpy(np.zeros(shape=(len(self.xml_np),7,7,25))).float()
        self.augmentor = get_augmentor()
        cnt = 0
        for i in range(len(self.xml_np)):
            img_path, label=create_label_at_one_xml_path((self.xml_np[i]),self.img_dir)
            img = image.open(img_path)
            img = np.array(img)
            img = cv2.resize(img/224.0,dsize=(224,224))
            self.img[i] = (torch.from_numpy(img)).permute(2,0,1)
            self.label[i]=torch.from_numpy(label).float()
            cnt +=1

        print(cnt)
    def __getitem__(self, idx):

        return self.img[idx],self.label[idx]

    def __len__(self):
        return int(len(self.xml_np))

if __name__ == "__main__":
    COMMON_PATH = '/media/sien/DATA/DATA/dataset/eco/sample'
    IMG_DIR = COMMON_PATH + '/Training/'
    LABEL_DIR = COMMON_PATH + '/Validation/'

    train_path, val_path, test_path, sample_path = split_xml_path(LABEL_DIR)
    sample_ds = Dataset(sample_path, IMG_DIR)
    #sample_loader = DataLoader(sample_ds, batch_size=BATCH_SIZE, shuffle=True)

    test_ds = Dataset(sample_path, IMG_DIR)
    #test_loader = DataLoader(test_ds, batch_size=BATCH_SIZE, shuffle=True)
