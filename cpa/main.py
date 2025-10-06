from AES import cypher, inv_cypher

if __name__ == "__main__":
    plain_text = [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0XDD, 0xEE, 0xFF]
    Key = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F]
    print("Plain text:", plain_text) # 平文
    print("Key:", Key)
    encypted_answer, last_roundkey = cypher(plain_text, Key)
    print("Crypted Text:", encypted_answer) # 暗号文
    print("10th RoundKey:", last_roundkey) # ラウンド鍵10
    decrypted_answer, first_key = inv_cypher(encypted_answer, last_roundkey)
    print("Plain text:", decrypted_answer) # 復号化後の平文
    print("Key:", first_key) # 復号化後の秘密