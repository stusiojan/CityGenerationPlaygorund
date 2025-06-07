import numpy as np
from dataclasses import dataclass
from enum import Enum

"""
Proces wyboru struktur danych

Cele:
1. Efektywność pamięciowa: Wykorzystanie NumPy zapewnia wydajne przechowywanie i operacje na dużych tablicach danych.
2. Łatwy dostęp do danych: Metody pomocnicze pozwalają na szybkie pobieranie informacji o konkretnych punktach i ich okolicy.
3. Elastyczność: Struktura pozwala na łatwe dodawanie nowych typów danych i funkcjonalności.
4. Enkapsulacja: Wszystkie dane i operacje są zgrupowane w jednej klasie.
5. Typowanie: Użycie dataclass i enum zwiększa czytelność i bezpieczeństwo typu.

Dodatkowe rozszerzenia:
1. Walidacja parametrów
2. Wczytywanie parametrów z bitmap
3. Metody do wizualizacji danych
4. Implementacja algorytmów analizy terenu
5. Cach często uzywanych wyników
"""


class WaterType(Enum):
    NONE = 0
    LAKE = 1
    OCEAN = 2
    RIVER = 3


class NodeType(Enum):
    CITY_CENTER = 0
    LOCAL_CENTER = 1


@dataclass
class CityNode:
    """
    Klasa reprezentująca węzeł miejski.
    Attributes:
        x (int): Współrzędna X węzła.
        y (int): Współrzędna Y węzła.
        importance (float): Waga węzła, gdzie 0.0 to najmniej ważny, a 1.0 to najważniejszy.
    """

    x: int
    y: int
    importance: float

    def __post_init__(self):
        """Walidacja danych po inicjalizacji"""
        if not 0 <= self.importance <= 1:
            raise ValueError("Importance must be between 0 and 1")


class TerrainData:
    """
    Klasa przechowująca dane o terenie w formie numerycznego modelu terenu (NMT).

    Attributes:
        width (int): Szerokość mapy.
        height (int): Wysokość mapy.
        population_density (np.ndarray): Mapa gęstości zaludnienia (wartości 0.0-1.0).
        elevation (np.ndarray): Mapa wysokości terenu (wartości w metrach n.p.m).
        water_map (np.ndarray): Mapa terenów wodnych (używamy enum WaterType).
        slope_map (np.ndarray): Mapa nachylenia terenu (wartości 0.0-1.0, gdzie 1.0 to maksymalne nachylenie).
        city_nodes (list): Lista węzłów miejskich (CityNode).
        buildable_mask (np.ndarray): Maska terenów niedostępnych pod zabudowę (z wartościami True/False).
    Args:
        width (int): Szerokość mapy w pikselach.
        height (int): Wysokość mapy w pikselach.
    """

    def __init__(self, width: int, height: int):
        self.width = width
        self.height = height
        self.population_density = np.zeros((height, width), dtype=np.float32)
        self.elevation = np.zeros((height, width), dtype=np.float32)
        self.water_map = np.zeros((height, width), dtype=np.int8)
        self.slope_map = np.zeros((height, width), dtype=np.float32)
        self.city_nodes = []
        self.buildable_mask = np.ones((height, width), dtype=bool)

    def add_city_node(self, node: CityNode):
        """Dodaje nowy węzeł miejski do listy"""
        self.city_nodes.append(node)

    def get_terrain_info(self, x: int, y: int) -> dict:
        """Zwraca wszystkie informacje o terenie dla danego punktu"""
        return {
            "population_density": self.population_density[y, x],
            "elevation": self.elevation[y, x],
            "water_type": WaterType(self.water_map[y, x]),
            "slope": self.slope_map[y, x],
            "is_buildable": self.buildable_mask[y, x],
        }

    def update_buildable_mask(self):
        """Aktualizuje maskę terenów dostępnych pod zabudowę"""
        # Tereny nie nadające się pod zabudowę:
        # - gdzie jest woda
        water_mask = self.water_map != WaterType.NONE.value
        # - gdzie nachylenie jest zbyt duże (np. powyżej 30%)
        steep_mask = self.slope_map > 0.3
        # Aktualizacja maski
        self.buildable_mask = ~(water_mask | steep_mask)

    def get_neighborhood_data(self, x: int, y: int, radius: int) -> dict:
        """Zwraca dane o okolicy danego punktu w określonym promieniu"""
        x_min = max(0, x - radius)
        x_max = min(self.width, x + radius + 1)
        y_min = max(0, y - radius)
        y_max = min(self.height, y + radius + 1)

        return {
            "population_density": self.population_density[y_min:y_max, x_min:x_max],
            "elevation": self.elevation[y_min:y_max, x_min:x_max],
            "water_map": self.water_map[y_min:y_max, x_min:x_max],
            "slope_map": self.slope_map[y_min:y_max, x_min:x_max],
            "buildable": self.buildable_mask[y_min:y_max, x_min:x_max],
        }
