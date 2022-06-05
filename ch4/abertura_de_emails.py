#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun  4 13:07:36 2022

@author: matheus

O objetivo é simular a abertura de emails e o comportamento de doação de
membros de uma organização sem fins lucrativos ao longo de vários anos.
"""

import numpy as np
import pandas as pd

# membership status
years = ['2014', '2015', '2016', '2017', '2018']
memberStatus = ['bronze', 'silver', 'gold', 'inactive']

memberYears = np.random.choice(years, 1000,p=[.1, .1, .15, .30, .35])
memberStats = np.random.choice(memberStatus, 1000, p=[.5, .3, .1, .1])

yearJoined = pd.DataFrame({'yearJoined': memberYears,
                           'memberStats': memberStats})

NUM_EMAILS_SENT_WEEKLY = 3

def never_opens(period_rng):
    return []

def constant_open_rate(period_rng):
    n = NUM_EMAILS_SENT_WEEKLY
    p = np.random.uniform(0,1)
    num_opened = np.random.binomial(n, p, len(period_rng))
    return num_opened

def increasing_open_rate(period_rng):
    return open_rate_with_factor_change(period_rng,
                                        np.random.uniform(1.01, 1.3))

def decreasing_open_rate(period_rng):
    return open_rate_with_factor_change(period_rng, np.random.uniform(0.5, 0.99))


def open_rate_with_factor_change(period_rng, fac):
    if len(period_rng) < 1:
        return []
    times = np.random.rand(0, len(period_rng), int(0.1 * len(period_rng)))
    
    num_opened = np.zeros(len(period_rng))
    for prd in range(0, len(period_rng), 2):
        try:
            n = NUM_EMAILS_SENT_WEEKLY
            p = np.random.uniform(0, 1)
            
            num_opened[prd:(prd + 2)] = np.random.binomial(n, p, 2)
            
            p = max(min(1, p * fac), 0)
        except:
            num_opened[prd] = np.random.binomial(n, p, 1)
    for t in range(len(times)):
        num_opened[times[t]] = 0
    return num_opened

