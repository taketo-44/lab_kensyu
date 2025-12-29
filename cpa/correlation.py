import numpy as np
def load_traces(file_paths, dtype=np.float64):
    #load all traces from file paths
    return np.concatenate([np.loadtxt(p, delimiter=',', dtype=dtype) for p in file_paths])

def compute_correlation(num_traces = 30000, window = None):
    window_for_each_traces = {10000: (2800, 3200), 30000: (2080, 2100)}
    traces_file_path = {10000: ["wave_data/EMwavedata10000/aes_tv_0000001-0005000_power.csv",
                            "wave_data/EMwavedata10000/aes_tv_0005001-0010000_power.csv"],
                        30000: ["wave_data/EMwavedata30000/aes_tv_0000001-0005000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0005001-0010000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0010001-0015000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0015001-0020000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0020001-0025000_power.csv",
                            "wave_data/EMwavedata30000/aes_tv_0025001-0030000_power.csv"]
                        }
    window = window_for_each_traces[num_traces]
    traces = load_traces(traces_file_path[num_traces])
    ret = []

    leakage = traces[:, window[0]:window[1]].max(axis=1)
    #leakage = traces[:, window[0]:window[1]].mean(axis=1)
    
    for bytes in range(16):

        hd_file = f"hd_table/EMwavedata{num_traces}/HD_table_byte{bytes}.csv"
        hd_data = np.loadtxt(hd_file, delimiter=',', dtype=np.float32)
        assert hd_data.shape[0] == leakage.shape[0], \
            f"Mismatch traces: HD={hd_data.shape[0]} leakage={leakage.shape[0]}"

        pearson = np.empty(256, dtype=np.float64)
        for key in range(256):
            hd = hd_data[:, key]
            corr = np.corrcoef(hd, leakage)[0, 1]
            pearson[key] = abs(corr)

        max_k = int(np.argmax(pearson))
        max_v = float(pearson[max_k])
        #debug
        new_p = sorted([(hex(k), v) for k, v in enumerate(pearson)], key=lambda x: x[1], reverse=True)
        print([i for i, v in new_p[:7]])

        max_k = hex(max_k)[2:].zfill(2)
        print(f"Byte {bytes}: Max Pearson Correlation = {round(max_v, 4)} (key = {max_k})")
        ret.append((max_k, max_v))
    return ret
