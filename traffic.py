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
END='total'
traffic={}


with Path('rural/data','trafdep.xlsx') as path:
     wb = openpyxl.load_workbook(str(path.as_posix()))
     ws = wb.active
     ncol = ord('A')
     nfil = 1
     sfil = 1
     efil = 1
     skey = ''
     flag = False
     
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
                         continue
                         #print(index, svalue)
                     if re.match(END, svalue, re.IGNORECASE):
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
df = df.set_index('Departamento')
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

'''
plt.legend(loc="upper left", 
           bbox_to_anchor=(1, 0.5), # bbox_to_anchor=(posiCol, posiFila)
		   ncol=1, shadow=True, fancybox=True, 
           framealpha=0.5, frameon=True)
'''