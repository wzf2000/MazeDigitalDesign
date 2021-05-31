with open("inv.v", "w") as f:
    f.write('localparam [0:511][8:0] inverse = {')
    f.write('\n')
    for i in range(512):
        if i == 0 or i == 1:
            f.write('\t9\'b111111111,\n')
        else:
            x = (2 ** 9) / i
            x = int(round(x))
            if (i == 511):
                f.write('\t9\'d{:0>9s}\n'.format(format(x, 'b')))
            else:
                f.write('\t9\'d{:0>9s},\n'.format(format(x, 'b')))
    f.write('};\n')