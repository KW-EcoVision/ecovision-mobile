import cv2
import torch
from model import YOLO as Yolov1
#from gpio import BBI,clamp

from utils import non_max_suppression,decoding_label, draw

import cv2 as cv
import numpy as np



size = 224


def field(model):

    DEVICE = 'cuda'
    green = (0,255,0)

    webcam = cv2.VideoCapture(0)

    if not webcam.isOpened():
        print("Could not open webcam")
        exit()

    while webcam.isOpened():
        status, img = webcam.read()

        if status:
            img = cv.resize(img,(size,size))
            copy = img
            img = img/255.0


            img = torch.Tensor(img)
            img = img.permute(2,0,1).float().unsqueeze(dim=0).to('cpu')
            pred = model(img)

            if len(pred.shape) == 2:
                pred = pred.view(-1, 7, 7, 30)
            boxes,class_list = decoding_label(np.array(pred.cpu().detach().squeeze(0)))
            boxes,class_list = non_max_suppression(boxes,0.3,0.4,class_list)
            for i in boxes:
                #clamp(i[0])
                pass

            copy = draw(boxes,copy,class_list)
            cv2.imshow('detecting',copy)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
    webcam.release()
    cv2.destroyAllWindows()






