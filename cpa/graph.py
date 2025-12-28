import os
import matplotlib.pyplot as plt
import numpy as np

def plot_first_line(file_path):
    # Read only the first line
    with open(file_path, 'r') as f:
        first_line = f.readline().strip()

    # Split into numbers
    y = [float(x) for x in first_line.split(',')]
    x = np.arange(1, len(y) + 1)

    # Plot only this one line
    plt.figure(figsize=(10, 6))
    plt.plot(x, y, label='First Line Data', linewidth=1.5)

    # Labels and style
    plt.xlabel('Index')
    plt.ylabel('Value')
    plt.title('Graph of First Line in CSV')
    plt.legend()
    plt.grid(True)

    # Save figure
    plt.savefig('graph_first_line2.png')
    plt.close()

def calc_average(data_list):
    data = np.vstack(data_list).mean(axis=1)
    return data

def plot_from_data(data, h = None, output_path="graph.png"):
    # Create directory if needed
    y = calc_average(data)
    x = np.arange(1, len(y) + 1)

    # Plot only this one line
    plt.figure(figsize=(10, 6))
    plt.plot(x, y, label='Data', linewidth=1.5)
    if h: plt.axhline(y=h, color='r', linestyle='--', label='Threshold')

    # Labels and style
    plt.xlabel('Index')
    plt.ylabel('Value')
    plt.title('Graph from Data')
    plt.legend()
    plt.grid(True)

    # Save figure
    plt.savefig(output_path)
    plt.close()

from correlation import load_traces
path = 'wave_data/EMwavedata30000/aes_tv_0000001-0005000_power.csv'
data = load_traces([path])
for i, line in enumerate(data[:10]):
    plot_from_data([line], output_path='img_test/' + os.path.basename(path) + f'_line_{i}.png')