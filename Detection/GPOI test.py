import Jetson.GPIO as GPIO
from time import sleep
import numpy as np
import torch


def clamp()-> None:
    GPIO.setmode(GPIO.BCM)
    GPIO.setwarnings(False)
    GPIO.setup(11, GPIO.OUT)
    GPIO.output(11, GPIO.HIGH)
    sleep(1)
    GPIO.output(11, GPIO.LOW)

if __name__ == "__main__":
    clamp()