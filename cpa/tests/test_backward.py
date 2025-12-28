import unittest


from AES import add, mult, sub_bytes, inv_sub_bytes, shift_rows, inv_shift_rows, mix_columns, inv_mix_columns, key_expansion, add_round_key, cypher, inv_cypher, Nb, Nr, Nk

class TestAESBackward(unittest.TestCase):
    def setUp(self):
        # From FIPS-197 Appendix C.1
        #69c4e0d86a7b0430d8cdb78070b4c55a
        self.crypted_block = [
            0x69, 0xc4, 0xe0, 0xd8,
            0x6a, 0x7b, 0x04, 0x30,
            0xd8, 0xcd, 0xb7, 0x80,
            0x70, 0xb4, 0xc5, 0x5a
        ]

        #13111d7fe3944a17f307a78b4d2b30c5
        self.key = [
            0x13, 0x11, 0x1d, 0x7f,
            0xe3, 0x94, 0x4a, 0x17,
            0xf3, 0x07, 0xa7, 0x8b,
            0x4d, 0x2b, 0x30, 0xc5
        ]

        #7ad5fda789ef4e272bca100b3d9ff59f
        self.expected_after_inv_add_round_key = [
            0x7a, 0xd5, 0xfd, 0xa7,
            0x89, 0xef, 0x4e, 0x27,
            0x2b, 0xca, 0x10, 0x0b,
            0x3d, 0x9f, 0xf5, 0x9f
        ]

        #7a9f102789d5f50b2beffd9f3dca4ea7
        self.expected_after_inv_shift_rows = [
            0x7a, 0x9f, 0x10, 0x27,
            0x89, 0xd5, 0xf5, 0x0b,
            0x2b, 0xef, 0xfd, 0x9f,
            0x3d, 0xca, 0x4e, 0xa7
        ]

        #bd6e7c3df2b5779e0b61216e8b10b689
        self.expected_after_inv_sub_bytes = [
            0xbd, 0x6e, 0x7c, 0x3d,
            0xf2, 0xb5, 0x77, 0x9e,
            0x0b, 0x61, 0x21, 0x6e,
            0x8b, 0x10, 0xb6, 0x89
        ]

        #e9f74eec023020f61bf2ccf2353c21c7
        self.expected_after_inv_add_round_key_2 = [
            0xe9, 0xf7, 0x4e, 0xec,
            0x02, 0x30, 0x20, 0xf6,
            0x1b, 0xf2, 0xcc, 0xf2,
            0x35, 0x3c, 0x21, 0xc7
        ]

        #54d990a16ba09ab596bbf40ea111702f
        self.exptected_after_inv_mix_columns = [
            0x54, 0xd9, 0x90, 0xa1,
            0x6b, 0xa0, 0x9a, 0xb5,
            0x96, 0xbb, 0xf4, 0x0e,
            0xa1, 0x11, 0x70, 0x2f
        ]

        #00112233445566778899aabbccddeeff
        self.expected_plaintext = [
            0x00, 0x11, 0x22, 0x33,
            0x44, 0x55, 0x66, 0x77,
            0x88, 0x99, 0xaa, 0xbb,
            0xcc, 0xdd, 0xee, 0xff
        ]

        self.expected_key = [
            0x00, 0x01, 0x02, 0x03,
            0x04, 0x05, 0x06, 0x07,
            0x08, 0x09, 0x0A, 0x0B,
            0x0C, 0x0D, 0x0E, 0x0F
        ]
            
    def _make_state(self, flat):
        return [[flat[r + 4*c] for c in range(Nb)] for r in range(Nb)]

    def _flatten_state(self, state):
        return [state[r][c] for c in range(Nb) for r in range(Nb)]

    def test_inv_add_round_key(self):
        round_key = key_expansion(self.key)
        state = self._make_state(self.crypted_block)
        result_state = add_round_key(state, round_key[0:4])
        result = self._flatten_state(result_state)
        self.assertEqual(result, self.expected_after_inv_add_round_key)
    
    def test_inv_shift_rows(self):
        state = self._make_state(self.expected_after_inv_add_round_key)
        state = inv_shift_rows(state)
        result = self._flatten_state(state)
        self.assertEqual(result, self.expected_after_inv_shift_rows)
    
    def test_inv_sub_bytes(self):
        state = self._make_state(self.expected_after_inv_shift_rows)
        state = inv_sub_bytes(state)
        result = self._flatten_state(state)
        self.assertEqual(result, self.expected_after_inv_sub_bytes)
    
    def test_inv_mix_columns(self):
        state = self._make_state(self.expected_after_inv_add_round_key_2)
        state = inv_mix_columns(state)
        result = self._flatten_state(state)
        self.assertEqual(result, self.exptected_after_inv_mix_columns)
    
    def test_full_decryption(self):
        decrypted, first_key = inv_cypher(self.crypted_block, self.key)
        self.assertEqual(decrypted, self.expected_plaintext)
        self.assertEqual(first_key, self.expected_key)

if __name__ == "__main__":
    unittest.main()