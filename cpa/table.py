from AES import inv_shift_rows, add_round_key, inv_sub_bytes, make_state, flatten_state, shift_rows
import csv

#Calculate Haming Distance
def calc_hd(X, Y, key):
    #HD_x = InvSbox(InvShiftRows(AddRoundKey(c_x))) ^ c_y
    return [x ^ y for x, y in zip(flatten_state(inv_sub_bytes(inv_shift_rows(add_round_key(X, key)))), Y)]

def read_file(file_path):
    #input file
    #from 0xstring_of_16byte to [hex, hex, ..., hex] (16)
    ret = []
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            line = line[2:].rstrip()
            ret.append([int(line[i:i+2], 16) for i in range(0, len(line), 2)])
            assert len(ret[-1]) == 16
    return ret

def write_file(file_path, data):
    with open(file_path, 'w') as f:
        writer = csv.writer(f)
        for value in data:
            writer.writerow(value)

def main():
    number_of_traces = 10000 #30000
    plain_text = read_file(f"wave_data/EMwavedata{number_of_traces}/CIPHERTEXT{number_of_traces}.txt")
    HD_tables = [[[] for _ in range(number_of_traces)] for _ in range(16)]

    for k in range(256):
        key = make_state([k]*16)
        for i in range(number_of_traces):
            hd_unshifted = calc_hd(make_state(plain_text[i]), plain_text[i], key)
            hd = flatten_state(shift_rows(make_state(hd_unshifted)))
            for byte in range(16):
                HD_tables[byte][i].append(bin(hd[byte]).count("1"))

    for byte in range(16):
        write_file(f"hd_table/EMwavedata{number_of_traces}/HD_table_byte{byte}.csv", HD_tables[byte])

if __name__ == "__main__":
    main()