
from correlation import compute_correlation
round_key_correct = ["0xd0", "0x14", "0xf9", "0xa8", "0xc9", "0xee", "0x25", "0x89", "0xe1", "0x3f", "0xc", "0xc8", "0xb6", "0x63", "0xc", "0xa6"]
final_range_result = []
def check_window(num_traces=30000, window = 50, start = 1700):
    matched_windows = []
    for w_start in range(start, right, window):
        w_end = w_start + window

        print(f"Checking window: {w_start}-{w_end}")
        round_key_10 = [int(b, 16) for b, _ in compute_correlation(num_traces=num_traces, window = (w_start, w_end) )]
        print("10th Round Key:", [hex(b) for b in round_key_10])
        cnt = 0
        for i, b in enumerate(round_key_10):
            if hex(b) == round_key_correct[i]:
                cnt += 1
        matched_windows.append((cnt, (w_start, w_end))) 
        if round_key_10 == round_key_correct:
            print("Successful window found!")
            print(f"Window: {w_start}-{w_end}")
            break
    matched_windows.sort(reverse=True)
    print("Top 5 matched windows:")
    final_range_result.append(matched_windows[0])
    for cnt, (s, e) in matched_windows[:5]:
        print(f"Matched Bytes: {cnt}, Window: {s}-{e}")
    
left = 2160
right = 2300
for window in [40]:
    for start in range(0, window, window // 10):
        start = left + start
        check_window(num_traces=30000, window=window, start=start)

print(sorted(final_range_result, reverse=True)[:100])
