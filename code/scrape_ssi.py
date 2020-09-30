#!/usr/bin/env python
# coding: utf-8

# # COVID-19 in DK – Scraper for SSI numbers (with Selenium)

# ### Relevant Libraries

# In[1]:


from selenium import webdriver
from time import sleep
from bs4 import BeautifulSoup as bs

from datetime import datetime
import os

import pandas as pd
import numpy as np


# ### Selenium start-up

# In[5]:


# <<< Insert your starting URL in the line below >>>

start_url='https://sseruminstitut.maps.arcgis.com/apps/opsdashboard/index.html#/f1d9acad6d0947ecaae1aee987f13339'

options = webdriver.ChromeOptions()

# <<< Change the path to your chromedriver's location >>>
driver = webdriver.Chrome(executable_path="/usr/local/bin/chromedriver", options=options)
driver.get(start_url)
sleep(10)


# ### Creating a results folder

# In[21]:


# Create folder for the .csv results

# <<< Change path to your working directory >>>
wd = "/Users/kristofferbaek/Documents/Projekter/Dataanalyse/Covid/Covid-19-Danmark/data/"

now = datetime.now()
#current_time = now.strftime("%d%m%y")
dirName = "Dashboard"

try:
    # Create target Directory
    os.mkdir(os.path.join(wd, dirName))
    print("Directory " , dirName ,  " Created ")
except FileExistsError:
    print("Directory " , dirName ,  " already exists")


# ### Scraping

# In[8]:


data = []

soup = bs(driver.page_source, 'html')

text_elements = soup.find_all('text')

for element in text_elements:

    try:
        value = element.getText()
    except:
        value = -1

    data.append({"val": value})


# In[9]:


dataa = pd.DataFrame(data)[0:30]


# In[10]:


dataa = dataa.drop([26,29], axis = 0).reset_index(drop=True)


# In[22]:


df = pd.DataFrame(dataa.val.values.reshape(-1,2),columns=['variable','values'])


# In[23]:


df


# ### Export

# In[24]:


df.to_csv(os.path.join(wd, dirName,'Dashboard_{}.csv'.format(datetime.now().strftime("%y%m%d"))), index = True, header = True)
print('Dashboard_{}.csv'.format(datetime.now().strftime("%y%m%d")), " created")

# In[ ]:
