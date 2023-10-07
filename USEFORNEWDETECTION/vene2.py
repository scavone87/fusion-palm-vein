import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import scipy.io as sio
import os

dimZ = 320
dimX = 835
dimY = 820
# Carica i dati dei centroidi dal file "valori.npy"
for array in os.listdir("Risultati_rete"):

    centroidi = np.load("Risultati_rete/" + array)

    print(len(centroidi))

    fig = plt.figure()
    # Estrai le coordinate y, x e z dai punti filtrati
    y_coords = [int(point[0]) for point in centroidi]
    x_coords = [int(point[1]) for point in centroidi]

    # Crea il plot 3D
    plt.scatter(y_coords, x_coords,s =10, c='r')

    # Mostra il grafico 3D
    print(os.getcwd())
    

    plt.savefig("Grafici_2D/" +  array.replace(".npy","") + ".jpg")



