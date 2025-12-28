from AES import inv_key_expansion
from correlation import compute_correlation

def restore_key():
    round_key_10 = [int(b, 16) for b, _ in compute_correlation(num_traces=30000)]
    print("10th Round Key:", [hex(b) for b in round_key_10])
    assert round_key_10 == [0xd0, 0x14, 0xf9, 0xa8, 0xc9, 0xee, 0x25, 0x89, 0xe1, 0x3f, 0xc, 0xc8, 0xb6, 0x63, 0xc, 0xa6], "10th round key restoration failed!"
    word = inv_key_expansion(round_key_10)
    secret_key = [v for sublist in word[0:4] for v in sublist]
    print("Restored Secret Key:", [hex(b) for b in secret_key])
    #assert secret_key == [0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c], "Key restoration failed!"

if __name__ == "__main__":
    restore_key()