#!/sbin/python3

import os
import random

wallpapers_path = f"{os.getenv("HOME")}/.config/hypr/wallpapers/"
wallpapers = os.listdir(wallpapers_path)
wallpapers.remove(os.path.basename(__file__))

print(wallpapers_path + random.choice(wallpapers))
