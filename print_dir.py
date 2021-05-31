import numpy as np

with open("dir.v", "w") as f:
    f.write('localparam signed [0:359][9:0] Dir_x = {')
    f.write('\n')
    for i in range(360):
        angle = i / 180 * np.pi
        x = -np.cos(angle)
        x = x * (2 ** 9)
        x = int(round(x))
        x = min(x, 512)
        if x < 0:
            x += 1024
        if (i == 359):
            f.write('\t10\'d{:0>10s}\n'.format(format(x, 'b')))
        else:
            f.write('\t10\'d{:0>10s},\n'.format(format(x, 'b')))
    f.write('};\n')
    f.write('localparam signed [0:359][9:0] Dir_y = {')
    f.write('\n')
    for i in range(360):
        angle = i / 180 * np.pi
        x = np.sin(angle)
        x = x * (2 ** 9)
        x = int(round(x))
        x = min(x, 512)
        if x < 0:
            x += 1024
        if (i == 359):
            f.write('\t10\'d{:0>10s}\n'.format(format(x, 'b')))
        else:
            f.write('\t10\'d{:0>10s},\n'.format(format(x, 'b')))
    f.write('};\n')
