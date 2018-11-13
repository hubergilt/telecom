#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov  4 06:34:46 2018

@author: hubergilt@hotmail.com
"""

from importlib.resources import Path
import rural
import openpyxl
import re

from pandas import DataFrame
import matplotlib.pyplot as plt
import numpy as np



class readtraffic(object):
    
    def __init__(self, name):
        self.name = name
        self.MAXFIL=31
        self.MAXCOL='Z'
        self.START='departamento'
        self.END1='total'
        self.END2='Tráfico'
    
    def load_data(self):
        ncol = ord('A')
        nfil = 1
        sfil = 1
        efil = 1
        skey = ''
        flag = False
        sindex = ''        
        traffic={}
        
        with Path('rural/data', self.name) as path:
             wb = openpyxl.load_workbook(str(path.as_posix()))
             ws = wb.active

             
             while ncol < ord(self.MAXCOL)+1:
                 nfil = 1
                 while nfil < self.MAXFIL:
                     index = chr(ncol)+str(nfil)
                     value = ws[index].value
                     nfil+=1
                     if value != None:
                         svalue = str(value)
                         #print(index, svalue)
                         
                         if not flag:
                             if re.match(self.START, svalue, re.IGNORECASE):
                                 traffic[svalue]=[]
                                 skey=svalue
                                 sfil = nfil
                                 sindex=svalue
                                 continue
                                 #print(index, svalue)
                             if re.match(self.END1, svalue, re.IGNORECASE) or re.match(self.END2, svalue, re.IGNORECASE):
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
        return traffic, sindex
    
    def simple_plot(self, traffic, sindex, stitle):
        df = DataFrame(data=traffic, dtype=float)
        df = df.set_index(sindex)
        df = df.T
        fig = plt.figure()
        df.plot(title=stitle)
        xlabels_positions = np.arange(12)
        xlabels = df.PUNO.index
        plt.xticks(xlabels_positions, xlabels, rotation=45*2)
        plt.xlabel("Año", size=16)
        plt.ylabel("Tráfico (minutos)", size=16)        
        lgd = plt.legend(loc='lower right', bbox_to_anchor=(1.38, 0))        
        return fig, lgd
        

if __name__ == '__main__':
    
    files = ['itraffic.xlsx','otraffic.xlsx','itraffic_prom.xlsx','otraffic_prom.xlsx']
    titles = ['Tráfico rural anual entrante', 
              'Tráfico rural anual saliente', 
              'Tráfico rural promedio anual entrante',
              'Tráfico rural promedio anual saliente']
    
    for file, title in zip(files, titles):
        rt = readtraffic(name=file)
        traffic, sindex = rt.load_data()
        fig, lgd = rt.simple_plot(traffic, sindex, title)
        plt.savefig(file.split('.')[0]+'.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
    