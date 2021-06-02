import numpy as np

def work():
    out = []
    dir_a = []
    for i in range(27, 28):
        angle = i / 180 * np.pi
        dir = np.array([[-np.cos(angle), np.sin(angle), 0]])
        hor = np.array([[np.sin(angle), np.cos(angle), 0]])
        up = np.array([[0, 0, 1]])
        R = np.concatenate([hor, -up, dir], axis = 0).transpose(1, 0)
        for x in range(74, 100):
            for y in range(90, 91):
                D = 0
                dir = np.array([[(x - 400) / 1024, -(y - 300) / 1024, 1]]).transpose(1, 0)
                # print('dir =', dir * (2 ** 9))
                dir = np.matmul(R, dir).transpose(1, 0)
                dir = dir[0]
                # print('Dir =', dir * (2 ** 8))
                center = np.array([32, 32, 32])
                for normal in [np.array([1, 0, 0])]:#, np.array([0, 1, 0])]:
                    x = np.dot(dir, normal)
                    if x == 0:
                        continue
                    t = (-np.dot(center, normal) + D * 64) / x
                    print('t =', t)
                    p = t * dir + center
                    # if p[0] < 0 or p[1] < 0 or p[2] < 0:
                    #     continue
                    # if p[0] > 320 or p[1] > 320 or p[2] > 64:
                    #     continue
                    # out.append(t)
                    # dir_a.append(dir[0])
                    # dir_a.append(dir[1])
                    # dir_a.append(dir[2])
    # a = np.abs(np.array(out))
    # dir_a = np.abs(np.array(dir_a))
    # mx = np.max(a)
    # mn = np.min(a)
    # dir_mx = np.max(dir_a)
    # dir_mn = np.min(dir_a)
    # print('max =', mx, 'min =', mn)
    # print('max =', dir_mx, 'min =', dir_mn)

work()

    