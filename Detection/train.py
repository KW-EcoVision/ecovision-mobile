import os
import random

import cv2
import numpy as np
import cv2 as cv
import torch
from model import YOLO
from testmodel import Yolov1 as YOLO_DARK
from utils import split_xml_path, decoding_label,non_max_suppression,draw,get_person
from dataset import Dataset
from tqdm import tqdm
from torch.utils.data import DataLoader
from field import field
import matplotlib.pyplot as plt
from transformer_back_based_detertor import VIT as trans_yolo


BACK = 'RES'
torch.manual_seed(100)
torch.cuda.manual_seed(100)
np.random.seed(100)
random.seed(100)
LEARNING_RATE = 1e-5
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
BATCH_SIZE = 1
WEIGHT_DECAY = 0
NUM_WORKERS = 10
PIN_MEMORY = False
EPOCHS =500
LOAD_MODEL = True
MODEL_SAVE_PATH = f'./weights/{BACK}.pt'
LOAD_MODEL_FILE = f'./weights/{BACK}.pt'
COMMON_PATH = '/media/sien/DATA/DATA/dataset/voc_data/VOCtrainval_11-May-2012/VOCdevkit/VOC2012/for_detection'
IMG_DIR = COMMON_PATH + '/JPEGImages/'
LABEL_DIR = COMMON_PATH + '/Annotations/'
MODE = 'inference'



if BACK == 'VGG':
    VGG16 = torch.hub.load('pytorch/vision:v0.10.0', 'vgg16')
    for i in range(len(VGG16.features[:-1])):
        if type(VGG16.features[i]) == type(torch.nn.Conv2d(32, 32, 3)):
            VGG16.features[i].weight.requires_grad = False
            VGG16.features[i].bias.requires_grad = False
            VGG16.features[i].padding = 1
    model = YOLO(VGG16.features[:-1],False)
elif BACK == 'RES':
    ResNet50 = torch.hub.load('pytorch/vision:v0.10.0', 'resnet50', weights='DEFAULT')
    modules = list(ResNet50.children())[:-2]
    backbone = torch.nn.Sequential(*modules)
    for param in backbone.parameters():
        param.requires_grad = False
    model = YOLO(backbone[:-1],True)
elif BACK =='DARK' :
    model = YOLO_DARK(split_size=7, num_boxes=2, num_classes=20)
    print(model)
elif BACK == 'trans':
    model = trans_yolo()
train_path, val_path, test_path,sample_path = split_xml_path(LABEL_DIR)
sample_ds = Dataset(sample_path, IMG_DIR)
sample_loader = DataLoader(sample_ds, batch_size=BATCH_SIZE,shuffle=True)

test_ds = Dataset(sample_path, IMG_DIR)
test_loader = DataLoader(test_ds, batch_size=BATCH_SIZE,shuffle=True)


def train_step(train_loader,model,optimizer,loss_fn):
    model.train()
    loop = tqdm(train_loader,leave = True)
    mean_loss = []
    best = np.inf
    for x,y in loop:
        x,y = x.to(DEVICE),y.to(DEVICE)
        pred = model(x)
        if len(pred.shape) == 2:
            pred = pred.view(-1,7,7,30)
        loss = loss_fn(pred,y)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        loop.set_postfix(loss=loss.item())
        mean_loss.append(loss.item())
    print(f'one epoch loss : {sum(mean_loss)/len(mean_loss)}')
    return sum(mean_loss)/len(mean_loss)


def validation_step(validation_loader,model,loss_fn):
    model.eval()
    with torch.no_grad():
        loop = tqdm(validation_loader, leave=True)
        loss_store= []
        for x, y in loop:
            x, y = x.to(DEVICE), y.to(DEVICE)
            pred = model(x)
            loss = loss_fn(pred,y)
            loss_store.append(loss.item())
            loop.set_postfix(loss=loss.item())
        print(f'valdation loss : {sum(loss_store)/len(loss_store)}')
    return sum(loss_store)/len(loss_store)

def test_step(train_loader,model):
    model.eval()
    pred_store = []
    for x,y in train_loader:
        x,y = x.to(DEVICE),y.to(DEVICE)
        pred = model(x)
        if len(pred.shape) == 2:
            pred = pred.view(-1,7,7,30)
        boxes,class_list = decoding_label(np.array(pred.cpu().detach().squeeze(0)))
        boxes,class_list = non_max_suppression(boxes,0.2,0.5,class_list)
        img = torch.permute(x.squeeze(0),(1,2,0))
        img = np.array(img.cpu().detach())
        img = (img * 224).astype(np.uint8)
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = draw(boxes,img,class_list)
        pred_store.append(img)









if __name__ =="__main__":
    from myloss import YoloLoss as myloss


    loss_fn = myloss()
    #=loss_fn = torch.nn.MSELoss()
    optimizer = torch.optim.AdamW(params=model.parameters(),lr=LEARNING_RATE)


    if MODE == 'train':
        if LOAD_MODEL:
            std = torch.load(f'./weights/{BACK}.pt')
            model.load_state_dict(std)
            model = model.to(DEVICE)
            model.train()

        model = model.to(DEVICE)
        best = np.inf
        for i in range(EPOCHS):
            print(f'{EPOCHS}/{i + 1}')
            loss = train_step(
                train_loader=sample_loader,
                model=model,
                optimizer=optimizer,
                loss_fn=loss_fn
            )

            if( (i+1)%5 == 0 ):
                print(f'validation start')
                val_loss = validation_step(
                    validation_loader=test_loader,
                    model=model,
                    loss_fn=loss_fn
                )
                print(f'validation end')
                if loss < best:
                    best = loss
                    torch.save(model.state_dict(), MODEL_SAVE_PATH)
                    print('saved!')



    if MODE == 'inference':
        std = torch.load(f'weights/{BACK}.pt')
        model.load_state_dict(std)
        model = model.to('cuda')
        model.eval()
        test_step(test_loader,model)
    if MODE == 'field':
        std = torch.load(f'weights/{BACK}.pt')
        model.load_state_dict(std)
        model = model.to('cpu')
        model.eval()
        field(model)



