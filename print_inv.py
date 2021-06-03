with open("inv.v", "w") as f:
    f.write('localparam [0:511][15:0] inverse = {')
    f.write('\n')
    for i in range(512):
        if i == 0 or i == 1:
            f.write('\t16\'b1111111111111111,\n')
        else:
            x = (2 ** 16) / i
            x = int(round(x))
            if (i == 511):
                f.write('\t16\'b{:0>16s}\n'.format(format(x, 'b')))
            else:
                f.write('\t16\'b{:0>16s},\n'.format(format(x, 'b')))
    f.write('};\n')