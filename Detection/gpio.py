import Jetson.GPIO as GPIO
from time import sleep
import numpy as np
import torch

classes_num_rev = {
    0: 'aeroplane',
    1: 'bicycle',
    2: 'bird',
    3: 'boat',
    4: 'bottle',
    5: 'bus',
    6: 'car',
    7: 'cat',
    8: 'chair',
    9: 'cow',
    10: 'diningtable',
    11: 'dog',
    12: 'horse',
    13: 'motorbike',
    14: 'person',
    15: 'pottedplant',
    16: 'sheep',
    17: 'sofa',
    18: 'train',
    19: 'tvmonitor'
}




def BBI(class_list) -> None :
    Flag = False
    for i in range(class_list):
        index = np.argmax(class_list)
        if index == 14:
            Flag = True
            break
    if Flag is True:
        GPIO.setmode(GPIO.BOARD)
        GPIO.setwarnings(False)
        GPIO.setup(7, GPIO.OUT, initial=GPIO.LOW)
        GPIO.output(7, GPIO.HIGH)
        sleep(0.5)
        GPIO.output(7, GPIO.LOW)
        Flag = False


