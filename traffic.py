#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov  4 06:34:46 2018

@author: hubergilt
"""

from importlib.resources import Path
import rural
import openpyxl
import re
from pandas import DataFrame
import matplotlib.pyplot as plt
import numpy as np

MAXFIL=31
MAXCOL='Z'
START='departamento'
END1='total'
END2='Tráfico'
traffic={}


with Path('rural/data','otraffic_prom.xlsx') as path:
     wb = openpyxl.load_workbook(str(path.as_posix()))
     ws = wb.active
     ncol = ord('A')
     nfil = 1
     sfil = 1
     efil = 1
     skey = ''
     flag = False
     sindex = ''
     
     while ncol < ord(MAXCOL)+1:
         nfil = 1
         while nfil < MAXFIL:
             index = chr(ncol)+str(nfil)
             value = ws[index].value
             nfil+=1
             if value != None:
                 svalue = str(value)
                 #print(index, svalue)
                 
                 if not flag:
                     if re.match(START, svalue, re.IGNORECASE):
                         traffic[svalue]=[]
                         skey=svalue
                         sfil = nfil
                         sindex=svalue
                         print('index: %s'%index)
                         continue
                         #print(index, svalue)
                     if re.match(END1, svalue, re.IGNORECASE) or re.match(END2, svalue, re.IGNORECASE):
                         flag = True
                         efil = nfil
                         #print(index, svalue)
                         break
                 else:
                     if nfil == sfil:
                         traffic[svalue]=[]
                         skey=svalue
                         continue
                     if nfil == efil:
                         break
             
                 if skey in traffic:
                     traffic[skey].append(svalue) 
         ncol+=1

df = DataFrame(data=traffic, dtype=float)
df = df.set_index(sindex)
df = df.T
#df = DataFrame(df, columns=['PUNO', 'LIMA', 'AREQUIPA', 'HUANCAVELICA', 'LORETO', 'CAJAMARCA'])
#df = DataFrame(df, columns=['PUNO','LORETO','SAN MARTIN', 'JUNIN'])
#df = df.cumsum()
plt.figure()
df.plot()
xlabels_positions = np.arange(12)
xlabels = df.PUNO.index
plt.xticks(xlabels_positions, xlabels, rotation=45*2)
plt.legend(loc='lower right', bbox_to_anchor=(1.38, 0))