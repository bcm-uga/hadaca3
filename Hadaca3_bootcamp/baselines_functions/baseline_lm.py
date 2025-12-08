
########################################################
### Package dependencies /!\ DO NOT CHANGE THIS PART ###
########################################################
import subprocess
import sys
import importlib

def program(mix=None, ref=None, **kwargs):

  ##
  ## YOUR CODE BEGINS HERE
  ##

  # required_packages = ["sklearn","pandas",'scipy']
  # install_and_import_packages(required_packages)
  from sklearn.linear_model import LinearRegression

  # from attachement import additionnal_script
  # additionnal_script.useless_function()


  def estimate_proportions(mix_df, ref_df):
    results = []
    for i in range(len(mix_df.columns)):
        mix_col = mix_df.iloc[:, i]  # Select the i-th column as a Series
        res = LinearRegression(fit_intercept=False).fit(ref_df, mix_col).coef_
        # res, _ = scipy.optimize.nnls(ref_df.to_numpy(), mix_col.to_numpy())
        res[res < 0] = 0
        results.append(res)

    # Normalize the results to get proportions
    props = pandas.DataFrame([res_i / sum(res_i) for res_i in results], columns=ref_df.columns)
    return props.T
  

  # Creation of an index, idx_feat, corresponding to the intersection of features present in the references and those present in the mixtures.
  idx_feat = mix.index.intersection(ref.index)
  mix_filtered = mix.loc[idx_feat, :]
  ref_filtered = ref.loc[idx_feat, :]

  prop = estimate_proportions(mix_filtered, ref_filtered)
 
  # Labeling of estimated proportions 
  prop.columns = mix.columns

  return prop
  ##
  ## YOUR CODE ENDS HERE
  ##
