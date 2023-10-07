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
    ax = fig.add_subplot(111, projection='3d')
    # Estrai le coordinate y, x e z dai punti filtrati
    y_coords = [int(point[0]) *0.1267 for point in centroidi]
    x_coords = [int(point[1]) *0.0462 for point in centroidi]
    z_coords = [int(point[2])  *0.0462 for point in centroidi]

    # Crea il plot 3D
    ax.scatter(x_coords,y_coords , z_coords,s =10, c='r')

    ax.set_ylim(0, 300 *0.1267)
    ax.set_xlim(dimX*0.0462,0)
    ax.set_zlim(dimZ*0.0462, 0)

    # Etichette degli assi
    ax.set_xlabel('Asse X')
    ax.set_ylabel('Asse Y')
    ax.set_zlabel('Asse Z')

    # Mostra il grafico 3D
    print(os.getcwd())

    plt.savefig("Grafici_3D/" +  array.replace(".npy","") + ".jpg")



