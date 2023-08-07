import sys
import stereo as st
import warnings
import scanpy as sc
import pandas as pd
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
warnings.filterwarnings('ignore')


filename = sys.argv[1]
anno_file = sys.argv[2]
sample_ID = sys.argv[3]
bin_size = sys.argv[4]
bin_size = int(bin_size)

input_dirname, input_basename = os.path.split(filename)
data1 = st.io.read_gef(filename, bin_type='bins', bin_size=bin_size, is_sparse=True)
output_basename2 = sample_ID +"."+str(bin_size)+".scanpy_out.h5ad"
data1.tl.raw_checkpoint()
adata=st.io.stereo_to_anndata(data1,flavor='scanpy',output=output_basename2)

adata.obs["X_Y"] = adata.obs["x"].astype(str) + "_" + adata.obs["y"].astype(str)
adata.obs = adata.obs.set_index("X_Y")

df1 = pd.read_table(anno_file, index_col=1,delimiter='\t')
df1 = df1.drop(['Total'], axis=1)
df1.set_index('X_Y', inplace=True)
df=adata.obs[['x', 'y']]
df.columns = ['X', 'Y']
df['X_Y'] = df[['X', 'Y']].astype(str).apply(lambda x: '_'.join(x), axis=1)
df.set_index('X_Y', inplace=True)
column_names = df1.columns
annotation_dict = df1[column_names].to_dict('index')
for obs_name, info in annotation_dict.items():
    df.loc[obs_name, column_names] = info.values()
df = df.drop(['X','Y'], axis=1)

column_names = df.columns
annotation_dict = df[column_names].to_dict('index')

for obs_name, info in annotation_dict.items():
    adata.obs.loc[obs_name, column_names] = info.values()

for CH_name in column_names:
    sc.pl.spatial(adata,spot_size=bin_size,color=CH_name,show=False)
    plot_file=sample_ID+"."+str(bin_size)+"."+CH_name+".pdf"
    plt.savefig(f'{plot_file}', bbox_inches='tight', dpi=150)
    plt.close()

output_basename3 = sample_ID+ "."+str(bin_size)+ ".h5ad"
adata.write(output_basename3)
