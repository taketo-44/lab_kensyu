import unittest

# Import your AES implementation here
from AES import add, mult, sub_bytes, inv_sub_bytes, shift_rows, inv_shift_rows, mix_columns, inv_mix_columns, key_expansion, add_round_key, cypher, inv_cypher, Nb, Nr, Nk

class TestAESSteps(unittest.TestCase):
    def setUp(self):
        self.key = [
            0x00, 0x01, 0x02, 0x03,
            0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0B,
            0x0C, 0x0D, 0x0E, 0x0F
        ]

        self.input_block = [
            0x00, 0x11, 0x22, 0x33,
            0x44, 0x55, 0x66, 0x77,
            0x88, 0x99, 0xAA, 0xBB,
            0xCC, 0xDD, 0xEE, 0xFF
        ]

        # Expected intermediate states (FIPS-197 Appendix C.1)
        # 00102030405060708090a0b0c0d0e0f0
        self.expected_after_add_round_key = [
            0x00, 0x10, 0x20, 0x30,
            0x40, 0x50, 0x60, 0x70,
            0x80, 0x90, 0xA0, 0xB0,
            0xC0, 0xD0, 0xE0, 0xF0
        ]
        #63cab7040953d051cd60e0e7ba70e18c
        self.expected_after_sub_bytes = [
            0x63, 0xca, 0xb7, 0x04,
            0x09, 0x53, 0xd0, 0x51,
            0xcd, 0x60, 0xe0, 0xe7,
            0xba, 0x70, 0xe1, 0x8c
        ]
        #6353e08c0960e104cd70b751bacad0e7
        self.expected_after_shift_rows = [
            0x63, 0x53, 0xe0, 0x8c,
            0x09, 0x60, 0xe1, 0x04,
            0xcd, 0x70, 0xb7, 0x51,
            0xba, 0xca, 0xd0, 0xe7
        ]
        #5f72641557f5bc92f7be3b291db9f91a 
        self.expected_after_mix_columns = [
            0x5f, 0x72, 0x64, 0x15,
            0x57, 0xf5, 0xbc, 0x92,
            0xf7, 0xbe, 0x3b, 0x29,
            0x1d, 0xb9, 0xf9, 0x1a
        ]
        # Expected final cipher text
        # 69c4e0d86a7b0430d8cdb78070b4c55a
        self.expected_cipher = [
            0x69, 0xc4, 0xe0, 0xd8,
            0x6a, 0x7b, 0x04, 0x30,
            0xd8, 0xcd, 0xb7, 0x80,
            0x70, 0xb4, 0xc5, 0x5a
        ]

    def _make_state(self, flat):
        """Convert 16-byte flat list to 4x4 state (column-major)."""
        return [[flat[r + 4 * c] for c in range(4)] for r in range(4)]

    def _flatten_state(self, state):
        return [state[r][c] for c in range(4) for r in range(4)]

    def test_add_round_key(self):
        round_keys = key_expansion(self.key)
        state = self._make_state(self.input_block)
        state = add_round_key(state, round_keys[0:4])
        result = self._flatten_state(state)
        self.assertEqual(result, self.expected_after_add_round_key)

    def test_sub_bytes(self):
        state = self._make_state(self.expected_after_add_round_key)
        state = sub_bytes(state)
        result = self._flatten_state(state)
        self.assertEqual(result, self.expected_after_sub_bytes)

    def test_shift_rows(self):
        state = self._make_state(self.expected_after_sub_bytes)
        state = shift_rows(state)
        result = self._flatten_state(state)
        self.assertEqual(result, self.expected_after_shift_rows)

    def test_mix_columns(self):
        state = self._make_state(self.expected_after_shift_rows)
        state = mix_columns(state)
        result = self._flatten_state(state)
        self.assertEqual(result, self.expected_after_mix_columns)

    def test_full_cipher(self):
        cipher, _ = cypher(self.input_block, self.key)
        self.assertEqual(cipher, self.expected_cipher)

if __name__ == "__main__":
    unittest.main()
