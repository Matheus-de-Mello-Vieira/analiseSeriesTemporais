#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun May 22 20:37:33 2022

@author: matheus
"""
# %% enriroment preparation

import pandas as pd
import numpy as np

air = pd.read_csv("ch2/data/AirPassengers.csv", names=['Date', 'Passengers'])

# %% suaviação exponencial
air['Smooth.5'] = air.Passengers.ewm(alpha=.5).mean()
air['Smooth.9'] = air.Passengers.ewm(alpha=.9).mean()

air

# %% fusos horários
import datetime
import pytz
import dateutil

datetime.datetime.utcnow()
datetime.datetime.now()
datetime.datetime.now(datetime.timezone.utc)

western = pytz.timezone("US/Pacific")
western.zone

