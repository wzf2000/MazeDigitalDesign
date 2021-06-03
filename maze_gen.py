with open('maze.txt', 'r') as f:
    lines = f.readlines()
    n = len(lines)
    maze = []
    out_maze = []
    for line in lines:
        line = line.strip().split(' ')
        line.reverse()
        out_maze.append(''.join(line))
        line.reverse()
        maze.append(line)
with open('maze.v', 'w') as f:
    f.write('localparam [0:%d][%d:0] maze = {%d\'b' % (n - 1, n - 1, n) + (', %d\'b' % (n)).join(out_maze) + '};\n')
    hor = []
    ver = []
    for i in range(n + 1):
        hor_line = ''
        ver_line = ''
        for j in range(n):
            if i == 0 or i == n or maze[i - 1][j] != maze[i][j]:
                hor_line += '1'
            else:
                hor_line += '0'
            if i == 0 or i == n or maze[j][i - 1] != maze[j][i]:
                ver_line += '1'
            else:
                ver_line += '0'
        hor_line = hor_line[::-1]
        ver_line = ver_line[::-1]
        hor.append(hor_line)
        ver.append(ver_line)
    f.write('localparam [0:%d][%d:0] hor_wall = {%d\'b' % (n, n - 1, n) + (', %d\'b' % (n)).join(hor) + '};\n')
    f.write('localparam [0:%d][%d:0] ver_wall = {%d\'b' % (n, n - 1, n) + (', %d\'b' % (n)).join(ver) + '};\n')
