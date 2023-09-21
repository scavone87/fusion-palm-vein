import numpy as np
import cv2
import scipy.io as sio
import matplotlib.pyplot as plt
import os
from keras.models import load_model

# Carica il modello UNet pre-addestrato

model = load_model("model_new.h5")
for mat in os.listdir("Dataset_vene_gruppo"):
    nome_template = mat.replace(".mat","")
    print(nome_template)
    try:
        if not os.path.exists("Risultati_rete/" + nome_template +".npy"):
            data = sio.loadmat("Dataset_vene_gruppo/" + mat)
            M = data['M']
            c_scan = np.zeros((542,814))

            dimensione_z, dimensione_x, dimensione_y = M.shape
            print(M.shape)
            centroidi = {}
            for y in range(150,300):
                centroidi[y] = []

            for y in range(dimensione_y):
                if y>150 and y <300:
                    #print(y)
                    parte_inferiore = np.squeeze(M[dimensione_z-20:dimensione_z,:,y])
                    rumore = (np.mean(parte_inferiore))
                    if rumore <= 50:
                        sezione_xz = np.squeeze(M[0:dimensione_z-20, :, y])
                    else:
                        sezione_xz = np.squeeze(M[0:dimensione_z, :, y])
                    #print(sezione_xz.shape)
                    sezione_xz = cv2.resize(sezione_xz, (528, 224))
                    img_contours2 = np.zeros(sezione_xz.shape)
                    #sezione_xz = cv2.medianBlur(sezione_xz, 15)
                    cv2.imshow("sezione_xz",sezione_xz)
                    input_image = cv2.cvtColor(sezione_xz, cv2.COLOR_GRAY2RGB)
                    min_value = np.min(input_image)
                    max_value = np.max(input_image)

                    # Normalizza le predizioni nell'intervallo [0, 1]
                    input_image = (input_image - min_value) / (max_value - min_value)
                    input_image = input_image.astype(np.float32)

                    input_image = np.expand_dims(input_image, axis=0)

                    predictions = model.predict(input_image)
                    #print(predictions.shape)
                    #cv2.imshow("output_rete",predictions)
                    predictions = np.squeeze(predictions) * 255.0
                    predictions = predictions.astype(np.uint8)

                    _, threshold_image = cv2.threshold(predictions, np.mean(predictions)*3, 255, cv2.THRESH_BINARY)
                    #cv2.imshow("binarize_rete",threshold_image)
                    threshold_image = threshold_image.astype(np.uint8)


                    # Trova i contorni delle vene
                    contours, _ = cv2.findContours(threshold_image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
                    for contour in contours:
                        area = cv2.contourArea(contour)
                        #print(area)
                        indice_finestra = 0
                        if area > 65:
                            Ma = cv2.moments(contour)
                            centroide_x = int(Ma['m10'] / Ma['m00'])
                            centroide_z = int(Ma['m01'] / Ma['m00'])

                            c_scan[centroide_x,y] = 255
                            centroidi[y].append([centroide_x,centroide_z])
                    cv2.imshow("CSCAN",c_scan)


                    cv2.waitKey(1)
            valori = []
            # Itera attraverso le chiavi in centroid_positions_filtrati
            for key in centroidi.keys():
                y_coords=[]
                x_coords=[]
                z_coords=[]
                # Estrai le coordinate y, x e z dai punti filtrati
                if (len(centroidi[key]) >0):
                    for numero in range(len(centroidi[key])):
                        y_coords.append([int(key)])
                    
                    x_coords = [int(point[0]) for point in centroidi[key]]
                    z_coords = [int(point[1]) for point in centroidi[key]]

                    combined_coords = np.column_stack((y_coords, x_coords, z_coords))
                    valori.extend(combined_coords)

            valori = np.array(valori)
            #print(valori)
            print("Risultati_rete/"+nome_template + ".npy")
            np.save("Risultati_rete/"+nome_template + ".npy",valori)
    except Exception as error:
        pass

    
