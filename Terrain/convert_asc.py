import numpy as np 
import matplotlib.pyplot as plt 
from matplotlib import colors 
from matplotlib.colors import LightSource 
import os
 
def read_asc_file(file_path): 
    # Wczytanie nagłówka 
    header = {} 
    with open(file_path, 'r') as file: 
        header['ncols'] = int(file.readline().split()[1]) 
        header['nrows'] = int(file.readline().split()[1]) 
        header['xllcenter'] = float(file.readline().split()[1]) 
        header['yllcenter'] = float(file.readline().split()[1]) 
        header['cellsize'] = float(file.readline().split()[1]) 
        header['nodata_value'] = float(file.readline().split()[1]) 
     
    # Wczytanie danych wysokościowych 
    data = np.loadtxt(file_path, skiprows=6) 
     
    return header, data 
 
def visualize_terrain(data, header, title="Numeryczny Model Terenu"): 
    # Zamiana wartości nodata na NaN 
    data[data == header['nodata_value']] = np.nan 
     
    # Utworzenie figury i osi 
    fig, ax = plt.subplots(figsize=(12, 8)) 
     
    # Wyświetlenie danych 
    im = ax.imshow(data,  
                   cmap='terrain', 
                   aspect='equal') 
     
    # Dodanie paska kolorów 
    cbar = fig.colorbar(im, ax=ax) 
    cbar.set_label('Wysokość [m n.p.m.]') 
     
    # Dodanie tytułu i etykiet 
    ax.set_title(title) 
    ax.set_xlabel('Kolumny') 
    ax.set_ylabel('Wiersze') 
     
    plt.show() 
 
def visualize_terrain_with_hillshade(data, header, title="Numeryczny Model Terenu z cieniowaniem"): 
    # Zamiana wartości nodata na NaN 
    data[data == header['nodata_value']] = np.nan 
     
    # Utworzenie figury i osi 
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(20, 8)) 
     
    # Podstawowa wizualizacja terenu 
    im1 = ax1.imshow(data, cmap='terrain') 
    ax1.set_title("Podstawowa wizualizacja") 
    fig.colorbar(im1, ax=ax1, label='Wysokość [m n.p.m.]') 
     
    # Utworzenie źródła światła dla cieniowania 
    ls = LightSource(azdeg=315, altdeg=45) 
     
    # Cieniowanie terenu 
    hillshade = ls.hillshade(data, vert_exag=1.0) 
    im2 = ax2.imshow(hillshade, cmap='gray') 
    ax2.set_title("Cieniowanie terenu") 
     
    # Dodanie tytułu głównego 
    fig.suptitle(title, fontsize=16) 
     
    plt.show() 
 
def main(): 
    # Ścieżka do pliku .asc 
    file_path = os.path.join("Terrain", "Data", "80052_1526701_M-34-51-C-d-4-1.asc")
     
    try: 
        # Wczytanie danych 
        header, data = read_asc_file(file_path) 
         
        # Wyświetlenie podstawowych statystyk 
        print("\nPodstawowe statystyki:") 
        print(f"Wymiary danych: {data.shape}") 
        print(f"Minimalna wysokość: {np.nanmin(data):.2f} m") 
        print(f"Maksymalna wysokość: {np.nanmax(data):.2f} m") 
        print(f"Średnia wysokość: {np.nanmean(data):.2f} m") 
         
        # Wizualizacja terenu na trzy sposoby 
        visualize_terrain(data, header) 
        visualize_terrain_with_hillshade(data, header) 
         
    except Exception as e: 
        print(f"Wystąpił błąd: {e}") 
 
if __name__ == "__main__": 
    main() 
