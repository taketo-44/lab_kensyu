import os
import numpy as np
from scipy.signal import find_peaks
from graph import plot_from_data

def identify_10th_peak(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    data = [[int(x) for x in line.rstrip().split(',')] for line in lines]
    ret = []
    index_set = []
    for row in data:

        peaks, _ = find_peaks(row, height=0, distance=100)
        value = [(row[p], i) for i, p in enumerate(peaks)]
        peak_10 = sorted(value, reverse=True)[:10]
        for v in value:
            if v in peak_10 and len(peak_10) == 1:
                ret.append(v[0])
                index_set.append(v[1])
                break
            elif v in peak_10:
                peak_10.remove(v)
    return ret
        
def main():
    traces = 10000 #30000
    traces_file_path = {10000: ["wave_data/EMwavedata10000/aes_tv_0000001-0005000_power.csv",
                            "wave_data/EMwavedata10000/aes_tv_0005001-0010000_power.csv"],
                        30000: ["wave_data/EMwavedata30000/aes_tv_0000001-0005000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0005001-0010000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0010001-0015000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0015001-0020000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0020001-0025000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0025001-0030000_power.csv"]
                        }
    
    all_peaks = []
    for file_path in traces_file_path[traces]:
        peaks = identify_10th_peak(file_path)
        all_peaks.extend(peaks)

    all_peaks = np.array(all_peaks, dtype=float)  # shape (num_traces,)

    for bytes in range(16):
        pearson_correlation = []

        hd_file = f"hd_table/EMwavedata{traces}/HD_table_byte{bytes}.csv"
        hd_data = np.loadtxt(hd_file, delimiter=',', dtype=float)
        if hd_data.ndim == 1:
            # If the CSV has a single line, make it a 2D array with one row
            hd_data = hd_data.reshape(1, -1)
        num_traces_hd = hd_data.shape[0]
        num_traces_peaks = len(all_peaks)
        assert num_traces_hd == num_traces_peaks, f"Mismatch in number of traces: HD data has {num_traces_hd}, peaks data has {num_traces_peaks}"

        for key in range(256):
            hd_distance = hd_data[:, key]

            correlation = np.corrcoef(hd_distance, all_peaks)[0, 1] 
            pearson_correlation.append(abs(correlation))
        #find the index of the maximum value and its value
        max_index = np.argmax(pearson_correlation)
        max_value = pearson_correlation[max_index]
        #print the result
        #key as a hexadecimal
        max_index = hex(max_index)[2:].zfill(2)
        print(f"Byte {bytes}: Max Pearson Correlation = {max_value} (key = {max_index})")

if __name__ == "__main__":
    main()