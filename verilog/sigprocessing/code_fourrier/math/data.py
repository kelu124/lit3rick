import numpy as np
import math


def bytes_from_file(filename, chunksize=8192):
    with open(filename, "rb") as f:
        while True:
            chunk = f.read(chunksize)
            if chunk:
                for b in chunk:
                    yield b
            else:
                break


def open_sample(FN='sample.dat'):
    RES = []
    i = 0
    Pon = []
    Poff = []
    res = 0
    # example:
    for by in bytes_from_file(FN):
        if not(i):
            a = int(by)
            A = math.floor(a/2)
            Poff.append(3000*(A & 0b1000000) >> 6)
            Pon.append(3000*(A & 0b0100000) >> 5)
            A = A & 0b0011111

        if not(i % 2):
            b = int(by)
            B = int(b/2)
        else:
            a = int(by)
            A = math.floor(a/2)
            Poff.append(3000*(A & 0b1000000) >> 6)
            Pon.append(3000*(A & 0b0100000) >> 5)
            A = A & 0b0011111
            C = (A << 7) | B
            RES.append(C-2048)
            res = 0
        i += 1
    return RES

def open_verilog_demo_out(filename='../tb/rb_demo_out.mem'):
    with open(filename) as mem_file:
        data = mem_file.readlines()
