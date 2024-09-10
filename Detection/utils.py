from xml.etree import ElementTree as ET

import cv2
import numpy as np
import cv2 as cv
from torchvision.transforms import transforms
import os
from sklearn.model_selection import train_test_split
import torch
import config
'''
'xml_path' is mapped by each img path
'img_dir' is not direct_path just dir
'img_path' is direct img_path
'''
classes_num = {'종이류': 0, '플라스틱': 1, '유리': 2, '캔': 3, '고철류': 4, '의류': 5,
               '전자제품': 6, '스티로폼': 7, '도기류': 8, '비닐류': 9, '가구': 10, '자전거': 11,
               '형광등': 12, '페트병류': 13, '나무류': 14}
classes_num_rev = {
    0: '종이류',
    1: '플라스틱',
    2: '유리',
    3: '캔',
    4: '고철류',
    5: '의류',
    6: '전자제품',
    7: '스티로폼',
    8: '도기류',
    9: '비닐류',
    10: '가구',
    11: '자전거',
    12: '형광등',
    13: '페트병류',
    14: '나무류',
}


IMG_SIZE = 224.0

CELL = 32.0
def create_label_at_one_xml_path(xml_path,img_dir):
    tree = ET.parse(xml_path)
    root = tree.getroot()
    width = float(root.find('size').find('width').text)
    height = float(root.find('size').find('height').text)
    img_name = root.find('filename').text
    img_path = img_dir + '/' + img_name

    label = np.zeros(shape=(7, 7, 25), dtype=float)
    ration_x = IMG_SIZE/width
    ratio_y =  IMG_SIZE/height

    for obj in root.findall('object'):
        class_name = obj.find('name').text
        class_id = classes_num[class_name]

        xmin = float(obj.find('bndbox').find('xmin').text)
        ymin = float(obj.find('bndbox').find('ymin').text)
        xmax = float(obj.find('bndbox').find('xmax').text)
        ymax = float(obj.find('bndbox').find('ymax').text)

        cx = xmin + ((xmax - xmin) / 2)
        cy = ymin + ((ymax - ymin) / 2)
        w = xmax - xmin
        h = ymax - ymin

        # mapped by new ratio
        rcx = cx * ration_x
        rcy = cy * ratio_y
        rw = w * ration_x
        rh = h * ratio_y

        cell_position_x = int(rcx / CELL)
        cell_position_y = int(rcy / CELL)

        # 각 셀의 시작 x, y 좌표를 계산합니다.
        start_x = cell_position_x * CELL
        start_y = cell_position_y * CELL

        rcx = (rcx - start_x) / CELL
        rcy = (rcy - start_y) / CELL

        rw = rw / IMG_SIZE
        rh = rh / IMG_SIZE

        label[cell_position_x, cell_position_y][20] = rcx
        label[cell_position_x, cell_position_y][21] = rcy
        label[cell_position_x, cell_position_y][22] = rw
        label[cell_position_x, cell_position_y][23] = rh
        label[cell_position_x, cell_position_y][24] = 1.0
        label[cell_position_x, cell_position_y][class_id] = 1.0
    return img_path, label

def decoding_label(label):
    bbox = []
    class_box = []

    for i in range(7):
        for j in range(7):
            cx = (label[i][j][20] * CELL)+(i*CELL)
            cy = (label[i][j][21] * CELL)+ (j*CELL)
            w = label[i][j][22] * IMG_SIZE
            h = label[i][j][23] * IMG_SIZE

            xmin = int(cx - w / 2)
            xmax = int(cx + w / 2)
            ymin = int(cy - h / 2)
            ymax = int(cy + h / 2)
            conf = label[i][j][24]
            class_pred = np.max(label[i][j][:14])
            bbox.append([class_pred, conf, xmin, ymin, xmax, ymax])
            class_box.append(label[i][j][:20])

        for j in range(7):
            cx = (label[i][j][25] * CELL) + (i * CELL)
            cy = label[i][j][26] * CELL + (j * CELL)
            w = label[i][j][27] * IMG_SIZE
            h = label[i][j][28] * IMG_SIZE

            xmin = int(cx - w / 2)
            xmax = int(cx + w / 2)
            ymin = int(cy - h / 2)
            ymax = int(cy + h / 2)
            conf = label[i][j][24]
            class_pred = np.max(label[i][j][:20])
            bbox.append([class_pred, conf, xmin, ymin, xmax, ymax])
            class_box.append(label[i][j][:20])
    return bbox,class_box

def draw(bbox_list,img,class_list):
    img = img.astype(np.uint8).copy()
    for i in range(len(bbox_list)):
        img = cv.rectangle(
            img=img,
            pt1=(bbox_list[i][2],bbox_list[i][3]),
            pt2=(bbox_list[i][4],bbox_list[i][5]),
            color=(0,225,0),thickness=1)
        max_val = np.max(class_list[i])
        max_index = np.argmax(class_list[i])
        img = cv2.putText(
            img,
            f'{classes_num_rev[max_index]} | {np.max(class_list[i])}',
            (bbox_list[i][2], bbox_list[i][3]),
            cv2.FONT_HERSHEY_SIMPLEX,
            fontScale=0.5,
            color=(0, 255, 0),
            thickness=1,
            lineType=cv2.LINE_AA
        )

    return img


def get_augmentor():
    return transforms.Compose([
        transforms.Resize(size=(int(IMG_SIZE),int(IMG_SIZE))),
        transforms.ToTensor()
    ])

def split_xml_path(xml_dir):
    path_list = []
    cnt=0
    for file_path, _, file_name in os.walk(xml_dir):
        for name in file_name:
            full_path = file_path+name
            path_list.append(full_path)
    dummy_label = np.zeros(shape=(len(path_list),))
    train_path,test_path,t_l,e_l = train_test_split(path_list,dummy_label,train_size=0.95,test_size=0.05,shuffle=False)
    train_path,val_path,_,__  = train_test_split(train_path,t_l,train_size=0.9,test_size=0.1,shuffle=False)
    val_path,sample_path,___,____ = train_test_split(val_path,__,train_size=0.9,test_size=0.1,shuffle=False)
    return train_path,val_path,test_path,sample_path

def bbox_to_coords(t):
    """Changes format of bounding boxes from [x, y, width, height] to ([x1, y1], [x2, y2])."""

    width = bbox_attr(t, 2)
    x = bbox_attr(t, 0)
    x1 = x - width / 2.0
    x2 = x + width / 2.0

    height = bbox_attr(t, 3)
    y = bbox_attr(t, 1)
    y1 = y - height / 2.0
    y2 = y + height / 2.0

    return torch.stack((x1, y1), dim=4), torch.stack((x2, y2), dim=4)

def get_iou(p, a):
    p_tl, p_br = bbox_to_coords(p)          # (batch, S, S, B, 2)
    a_tl, a_br = bbox_to_coords(a)

    # Largest top-left corner and smallest bottom-right corner give the intersection
    coords_join_size = (-1, -1, -1, config.B, config.B, 2)
    tl = torch.max(
        p_tl.unsqueeze(4).expand(coords_join_size),         # (batch, S, S, B, 1, 2) -> (batch, S, S, B, B, 2)
        a_tl.unsqueeze(3).expand(coords_join_size)          # (batch, S, S, 1, B, 2) -> (batch, S, S, B, B, 2)
    )
    br = torch.min(
        p_br.unsqueeze(4).expand(coords_join_size),
        a_br.unsqueeze(3).expand(coords_join_size)
    )

    intersection_sides = torch.clamp(br - tl, min=0.0)
    intersection = intersection_sides[..., 0] \
                   * intersection_sides[..., 1]       # (batch, S, S, B, B)

    p_area = bbox_attr(p, 2) * bbox_attr(p, 3)                  # (batch, S, S, B)
    p_area = p_area.unsqueeze(4).expand_as(intersection)        # (batch, S, S, B, 1) -> (batch, S, S, B, B)

    a_area = bbox_attr(a, 2) * bbox_attr(a, 3)                  # (batch, S, S, B)
    a_area = a_area.unsqueeze(3).expand_as(intersection)        # (batch, S, S, 1, B) -> (batch, S, S, B, B)

    union = p_area + a_area - intersection

    # Catch division-by-zero
    zero_unions = (union == 0.0)
    union[zero_unions] = 1e-7
    intersection[zero_unions] = 0.0

    return intersection / union

'''
겹치는 부분 / 전체 박스인데! 귀찮으니까 센터끼지 차이로 보자
sqrt(pred x,y - label x,y)
20번째 21번째가 center 좌표
'''
def intersection_over_union(boxes_preds, boxes_labels):
    box1_x1 = boxes_preds[..., 0:1] - boxes_preds[..., 2:3] / 2
    box1_y1 = boxes_preds[..., 1:2] - boxes_preds[..., 3:4] / 2
    box1_x2 = boxes_preds[..., 0:1] + boxes_preds[..., 2:3] / 2
    box1_y2 = boxes_preds[..., 1:2] + boxes_preds[..., 3:4] / 2
    box2_x1 = boxes_labels[..., 0:1] - boxes_labels[..., 2:3] / 2
    box2_y1 = boxes_labels[..., 1:2] - boxes_labels[..., 3:4] / 2
    box2_x2 = boxes_labels[..., 0:1] + boxes_labels[..., 2:3] / 2
    box2_y2 = boxes_labels[..., 1:2] + boxes_labels[..., 3:4] / 2


    x1 = torch.max(box1_x1, box2_x1)
    y1 = torch.max(box1_y1, box2_y1)
    x2 = torch.min(box1_x2, box2_x2)
    y2 = torch.min(box1_y2, box2_y2)

    intersection = (x2 - x1).clamp(0) * (y2 - y1).clamp(0)

    box1_area = abs((box1_x2 - box1_x1) * (box1_y2 - box1_y1))
    box2_area = abs((box2_x2 - box2_x1) * (box2_y2 - box2_y1))

    return intersection / (box1_area + box2_area - intersection + 1e-6)

def bbox_attr(data, i):

    attr_start = 20 + i
    return data[..., attr_start::5]

def non_max_suppression(bboxes, conf_th, iou_threshold, class_list):
    # 박스 필터링 및 클래스 저장
    filtered_boxes = [(box, cls) for box, cls in zip(bboxes, class_list) if box[1] > conf_th]
    # 신뢰도로 정렬
    filtered_boxes.sort(key=lambda x: x[0][1], reverse=True)

    selected_boxes = []
    selected_classes = []

    while filtered_boxes:
        current_box, current_class = filtered_boxes.pop(0)
        selected_boxes.append(current_box)
        selected_classes.append(current_class)
        filtered_boxes = [(box, cls) for box, cls in filtered_boxes
                          if intersection_over_union(torch.Tensor(current_box[2:]),torch.Tensor(box[2:])) <= iou_threshold and max(cls) >0.0 and max(cls<1.0)]

    return selected_boxes, selected_classes
