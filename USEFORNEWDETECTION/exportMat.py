import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import scipy.io as sio
import os


# Creazione di un dizionario per i dati dei centroidi
data_dict = {}
data_dict2d = {}
i = 1
for array in os.listdir("CLEANED"):
    centroidi = np.load("CLEANED/" + array)
    print(centroidi.shape)
    # Estrazione delle coordinate y, x e z dai punti filtrati
    x_coords = np.array([int(point[0]) for point in centroidi])
    y_coords = np.array([int(point[1]) for point in centroidi])
    z_coords = np.array([int(point[2]) for point in centroidi])
    print(len(y_coords))

    # Aggiunta dei dati al dizionario
    data_dict = {
        "y_coords": y_coords,
        "x_coords": x_coords,
        "z_coords": z_coords
    }
    data_dict2d = {
        "y_coords": y_coords,
        "x_coords": x_coords
    }
    # Directory di output per i file .mat
    output_dir_3d = "template_3D"
    output_dir_2d = "template_2D"

    # Assicurati che le directory di output esistano
    os.makedirs(output_dir_3d, exist_ok=True)
    os.makedirs(output_dir_2d, exist_ok=True)

    # Salvataggio dei dati in un file .mat
    sio.savemat(os.path.join(output_dir_3d, array.replace(".npy", ".mat")), data_dict)
    sio.savemat(os.path.join(output_dir_2d, array.replace(".npy", ".mat")), data_dict2d)
    data_dict = {}
    data_dict2d = {}
    print("Dato salvato in file .mat")
