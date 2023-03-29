# https://www.freecodecamp.org/learn/data-analysis-with-python/data-analysis-with-python-projects/mean-variance-standard-deviation-calculator

import numpy as np

def calculate(list):
  if len(list) < 9:
    raise ValueError("List must contain nine numbers.")
  else:
    arr = np.array(list)
    new_arr = arr.reshape(3, 3)
    calculations = {}
    calculations["mean"] = [np.mean(new_arr,0).tolist(),
                            np.mean(new_arr,1).tolist(), 
                            np.mean(arr)]
    calculations["variance"] = [np.var(new_arr,0).tolist(),
                                np.var(new_arr,1).tolist(),
                                np.var(arr)]
    calculations["standard deviation"] = [np.std(new_arr,0).tolist(), 
                                          np.std(new_arr,1).tolist(),
                                          np.std(arr)]
    calculations["max"] = [np.max(new_arr,0).tolist(), 
                           np.max(new_arr,1).tolist(), 
                           np.max(arr)]
    calculations["min"] = [np.min(new_arr,0).tolist(), 
                           np.min(new_arr,1).tolist(), 
                           np.min(arr)]
    calculations["sum"] = [np.sum(new_arr,0).tolist(), 
                           np.sum(new_arr,1).tolist(), 
                           np.sum(arr)]
    return calculations
