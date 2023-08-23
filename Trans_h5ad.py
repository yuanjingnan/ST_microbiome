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
sample_ID = sys.argv[2]

data_path = filename
data = st.io.read_gef(file_path=data_path, bin_type='cell_bins')
data.tl.raw_checkpoint()

output_basename1 = sample_ID + ".cellbin.h5ad"
adata=st.io.stereo_to_anndata(data,flavor='scanpy',output=output_basename1)
adata.X=adata.X.astype(np.float32)
sc.write(output_basename1, adata)
