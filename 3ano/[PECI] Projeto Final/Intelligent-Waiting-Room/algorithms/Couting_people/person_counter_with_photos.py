import cv2
from threading import *
import threading
import time
import cv2
import numpy as np
from centroidtracker import CentroidTracker
import cv2
import numpy as np
from centroidtracker import CentroidTracker
from itertools import combinations



value = 1
image = None
frame = None

protopath = "MobileNetSSD_deploy.prototxt"
modelpath = "MobileNetSSD_deploy.caffemodel"
detector = cv2.dnn.readNetFromCaffe(prototxt=protopath, caffeModel=modelpath)
# detector.setPreferableBackend(cv2.dnn.DNN_BACKEND_INFERENCE_ENGINE)
# detector.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)
IMG_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.tiff', '.gif']

CLASSES = ["background", "aeroplane", "bicycle", "bird", "boat",
           "bottle", "bus", "car", "cat", "chair", "cow", "diningtable",
           "dog", "horse", "motorbike", "person", "pottedplant", "sheep",
           "sofa", "train", "tvmonitor"]

tracker = CentroidTracker(maxDisappeared=40, maxDistance=50)

def non_max_suppression_fast(boxes, overlapThresh):
    try:
        if len(boxes) == 0:
            return []

        if boxes.dtype.kind == "i":
            boxes = boxes.astype("float")

        pick = []

        x1 = boxes[:, 0]
        y1 = boxes[:, 1]
        x2 = boxes[:, 2]
        y2 = boxes[:, 3]

        area = (x2 - x1 + 1) * (y2 - y1 + 1)
        idxs = np.argsort(y2)

        while len(idxs) > 0:
            last = len(idxs) - 1
            i = idxs[last]
            pick.append(i)

            xx1 = np.maximum(x1[i], x1[idxs[:last]])
            yy1 = np.maximum(y1[i], y1[idxs[:last]])
            xx2 = np.minimum(x2[i], x2[idxs[:last]])
            yy2 = np.minimum(y2[i], y2[idxs[:last]])

            w = np.maximum(0, xx2 - xx1 + 1)
            h = np.maximum(0, yy2 - yy1 + 1)

            overlap = (w * h) / area[idxs[:last]]

            idxs = np.delete(idxs, np.concatenate(([last],
                                                   np.where(overlap > overlapThresh)[0])))

        return boxes[pick].astype("int")
    except Exception as e:
        print("Exception occurred in non_max_suppression : {}".format(e))

def saveimage():
    #global frame
    global value
    while True:
        if value == 2:
            #print("Save the image\n----------------")
            x,frame = cv2.VideoCapture('image2.jpg').read()
            (H, W) = frame.shape[:2]

            blob = cv2.dnn.blobFromImage(frame, 0.007843, (W, H), 127.5)

            detector.setInput(blob)
            person_detections = detector.forward()
            rects = []
            for i in np.arange(0, person_detections.shape[2]):
                confidence = person_detections[0, 0, i, 2]
                if confidence > 0.5:
                    idx = int(person_detections[0, 0, i, 1])

                    if CLASSES[idx] != "person":
                        continue

                    person_box = person_detections[0, 0, i, 3:7] * np.array([W, H, W, H])
                    (startX, startY, endX, endY) = person_box.astype("int")
                    rects.append(person_box)

            boundingboxes = np.array(rects)
            boundingboxes = boundingboxes.astype(int)
            rects = non_max_suppression_fast(boundingboxes, 0.3)
            centroid_dict = dict()
            objects = tracker.update(rects)
            for (objectId, bbox) in objects.items():
                x1, y1, x2, y2 = bbox
                x1 = int(x1)
                y1 = int(y1)
                x2 = int(x2)
                y2 = int(y2)
                cX = int((x1 + x2) / 2.0)
                cY = int((y1 + y2) / 2.0)


                centroid_dict[objectId] = (cX, cY, x1, y1, x2, y2)
            red_zone_list = []
            for (id1, p1), (id2, p2) in combinations(centroid_dict.items(), 2):
                dx, dy = p1[0] - p2[0], p1[1] - p2[1]
                if id1 not in red_zone_list:
                    red_zone_list.append(id1)
                if id2 not in red_zone_list:
                    red_zone_list.append(id2)

            for id, box in centroid_dict.items():
                cv2.rectangle(frame, (box[2], box[3]), (box[4], box[5]), (0, 255, 0), 2)
                print(f'x:{box[2]} | y:{box[3]} | z:{box[4]} w:{box[5]}')

            counter_text = "Numero de pessoas - >{}".format(len(objects))
            cv2.putText(frame, "{}".format(len(objects)), (5, 200), cv2.FONT_HERSHEY_COMPLEX_SMALL, 5, (255, 0, 0), 5)
            print(counter_text)
            #save the image using cv2.imwrite
            cv2.imwrite("image.jpg", frame)
            value = 0
def camerafunc():

    camera = cv2.VideoCapture(0)
    global value
    global image
    global frame
    while True:
        return_value,image = camera.read()
        gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
        cv2.imshow('image',gray)
        if cv2.waitKey(1)& value == 1:
            #print("START THE SAVING")
            frame = image
            value = 2
def sleep_sem():
    global value
    global frame
    while True:
        time.sleep(3)
        #save image with cv2.imwrite
        cv2.imwrite("image2.jpg", frame)
        value = 1
        #print("----------------\nTIMER STARTED")


t1 = threading.Thread(target=camerafunc) 
t2 = threading.Thread(target=sleep_sem)
t3 = threading.Thread(target=saveimage)

t1.start()

t3.start()

t2.start()
