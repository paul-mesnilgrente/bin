#!/usr/bin/env python3

import argparse
import binascii


def text_to_bits(text, encoding='utf-8', errors='surrogatepass'):
    bits = bin(int(binascii.hexlify(text.encode(encoding, errors)), 16))[2:]
    return bits.zfill(8 * ((len(bits) + 7) // 8))


def text_from_bits(bits, encoding='utf-8', errors='surrogatepass'):
    n = int(bits, 2)
    return int2bytes(n).decode(encoding, errors)


def int2bytes(i):
    hex_string = '%x' % i
    n = len(hex_string)
    return binascii.unhexlify(hex_string.zfill(n + (n & 1)))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Convert an ascii sequence \
                                     into binary or inverse')
    parser.add_argument('-b', '--binary',
                        type=str,
                        help='Transform binary into an ascii sequence')
    parser.add_argument('-a', '--ascii',
                        type=str,
                        help='Transform an ascii sequence into binary')
    args = parser.parse_args()

    if args.ascii is not None:
        print('Convert of "{}" into binary sequence'.format(args.ascii))
        bits = text_to_bits(args.ascii)
        print(' '.join([bits[i:i+8] for i in range(0, len(bits), 8)]))
    if args.binary is not None:
        print('Convert the binary into ASCII sequence'.format(args.binary))
        print(text_from_bits(args.binary.replace(' ', '')))
