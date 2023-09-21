import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import scipy.io as sio
import cv2
import os



dimZ = 320
dimX = 835
dimY = 820
# Carica i dati dei centroidi dal file "valori.npy"
for array in os.listdir("Risultati_rete"):
    print(array)
    centroidi = np.load("Risultati_rete/" + array)
    print(centroidi)

    means = np.mean(centroidi, axis=0)
    stds = np.std(centroidi, axis=0)
    c_scan = np.zeros((dimZ,dimY),dtype = np.uint8)

    maschera = np.zeros((dimZ,dimY),dtype = np.uint8)


    filtered_centroidi = []
    for centroide in centroidi:
        if(centroide[0] < means[0] + 2 * stds[0]) and (centroide[1] < means[1] + 2 * stds[1]) and (centroide[2] < means[2] + 2 * stds[2]):
            filtered_centroidi.append(centroide)
            centro = (centroide[0],centroide[2])
            cv2.circle(c_scan,centro,1,255,1)
    cv2.imshow("c3",c_scan)

    contours, _ = cv2.findContours(c_scan, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    mask = np.zeros((dimZ,dimY),dtype = np.uint8)
    mask2 = np.zeros((dimZ,dimY,3),dtype = np.uint8)


    for contour in contours:
        area = cv2.contourArea(contour)
        if area > 50:
          cv2.drawContours(mask, [contour], -1, 255, thickness=cv2.FILLED)
          cv2.drawContours(mask2, [contour], -1, (0,0,255), thickness=cv2.FILLED)

    centroidi_after_mask = []

    valori_da_salvare_y,  valori_da_salvare_x = np.where(mask > 0)
    c_scan = np.zeros((238,814),dtype = np.uint8)
    for centroide in filtered_centroidi:
        #print(mask[centroide[1],centroide[0]])
        if(centroide[2] in valori_da_salvare_y and centroide[0] in valori_da_salvare_x):
            centro = (centroide[0],centroide[2])

            cv2.circle(c_scan,centro,1,255,1)
            centroidi_after_mask.append(centroide)

    cv2.imshow("c2",c_scan)


    

    if (len(centroidi_after_mask) > 0):

        means = np.mean(centroidi_after_mask, axis=0)
        stds = np.std(centroidi_after_mask, axis=0)
        c_scan = np.zeros((dimX,dimY),dtype = np.uint8)



        filtered_centroidi = []
        for centroide in centroidi_after_mask:
            if(centroide[0] < means[0] + 2 * stds[0]) and (centroide[1] < means[1] + 2 * stds[1]) and (centroide[2] < means[2] + 2 * stds[2]):
                filtered_centroidi.append(centroide)
                centro = (centroide[0],centroide[1])
                cv2.circle(c_scan,centro,1,255,1)


        cv2.imshow("c",c_scan)
        contours, _ = cv2.findContours(c_scan, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        mask = np.zeros((dimX,dimY),dtype = np.uint8)
        mask2 = np.zeros((dimX,dimY,3),dtype = np.uint8)


        for contour in contours:
            area = cv2.contourArea(contour)
            #print(area)
            if area > 70:
              cv2.drawContours(mask, [contour], -1, 255, thickness=cv2.FILLED)
              cv2.drawContours(mask2, [contour], -1, (0,0,255), thickness=cv2.FILLED)

        centroidi_after_mask = []

        valori_da_salvare_y,  valori_da_salvare_x = np.where(mask > 0)
        #print(valori_da_salvare_y)
        c_scan = np.zeros((dimX,dimY),dtype = np.uint8)
        for centroide in filtered_centroidi:
            #print(mask[centroide[1],centroide[0]])
            if(centroide[1] in valori_da_salvare_y and centroide[0] in valori_da_salvare_x):
                centro = (centroide[0],centroide[1])

                cv2.circle(c_scan,centro,1,255,1)
                centroidi_after_mask.append(centroide)

        #print(len(filtered_centroidi) != len(centroidi_after_mask))


        cv2.imshow("c4",c_scan)
        cv2.waitKey(15000)
        np.save("CLEANED/" + array,centroidi_after_mask)


    print(len(centroidi) - len(centroidi_after_mask))

