import numpy as np

#generates the 512-point Hamming window
hamming = np.hamming(512)
hamming_scaled = (hamming * 65535).astype(np.uint16)
#nice little trick to make it into a vhd file then just put these coeffs into the generator block
with open('hamming_lut.vhd', 'w') as f:
    f.write("constant HAMMING_LUT : lut_type := (\n")
    for i, val in enumerate(hamming_scaled):
        f.write(f"    {val}")
        if i < len(hamming_scaled) - 1:
            f.write(",")
        f.write("\n")
    f.write(");")
