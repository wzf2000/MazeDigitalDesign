import cv2
import ctypes
import numpy as np

def main():
    img2 = cv2.imread('start.png')
    img1 = cv2.imread('end.png')
    with open('image.sv', 'w', encoding='utf-8') as fout:
        for (name, src) in [('start_img', img2), ('end_img', img1)]:
            cnt = 0
            dataheader = f'localparam [0:7499][23:0] {name} = {{\n'
            fout.write(dataheader)
            for i in range(0, 75):
                for j in range(0, 100):
                    r = (src[i, j, 0])
                    g = (src[i, j, 1])
                    b = (src[i, j, 2])
                    ans = r << 16 | g << 8 | b
                    s = '{0:024b}'.format(ans)
                    fout.write(f'       24\'b{s},\n')
            #         fout.write(ans)
                    cnt += 1
            ender = '''};\n'''
            fout.write(ender)

if __name__ == "__main__":
    main()