#!/usr/bin/env python
# coding: utf-8

# ## NB_download_ny_yt_data
# 
# null

# In[16]:


import requests
import pandas as pd
import logging as lg

lg.basicConfig(level=lg.INFO)


# In[17]:


par_datepart='2025-01'
par_url='https://d37ci6vzurychx.cloudfront.net'
par_filename='yellow_tripdata'
par_directory ='trip-data'
par_actual_url=f"{par_url}/{par_directory}/{par_filename}_{datepart}.parquet"
par_output_path = f"Files/newyork-data/yellow_taxi_data_{datepart}/"


# In[18]:


def download_taxi_data(url,output_path):

    try:
        # filename = url.split('/')[-1]
        r = requests.get(url)
        with open("temp.parquet", "wb") as f:
            f.write(r.content)

        df = pd.read_parquet("temp.parquet")

        spark_df = spark.createDataFrame(df)


        spark_df.repartition(1).write.format('parquet')\
                                      .mode('overwrite')\
                                      .save(output_path)   


    except Exception as e:
        lg.info(f"Error in download_taxi_data function {e}")



# In[19]:


def main():
    download_taxi_data(par_actual_url,par_output_path )


# In[20]:


if __name__ == '__main__':
    main()

