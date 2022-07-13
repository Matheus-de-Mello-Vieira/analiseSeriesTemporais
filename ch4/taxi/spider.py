#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jun  5 10:07:40 2022

@author: matheus
"""
import numpy as np

start_times_and_freqs = [(0, 8), (8, 30), (16, 15)]
while True:
    start = np.random.choice(start_times_and_freqs, p = [.25, .5, .25])
    yield (start[0], start[0] + 7.5, start[1])