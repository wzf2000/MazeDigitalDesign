def main():
    header = '''
module translate(\n\
    input wire clk,\n\
    input wire [9:0] x,\n\
    input wire [9:0] y,\n\
    output reg [18:0] index\n\
);\n\
\n\
    localparam BUF_WIDTH = 19'd1024;\n\
    localparam [0:400*512][7:0] masks = {\n\
    '''
    tail = '''
    };\n\
\n\
    always @(posedge clk) begin\n\
        index <= y * BUF_WIDTH + x + masks[y * BUF_WIDTH + x] - 128;\n\
    end\n\
\n\
endmodule\n\
    '''
    
    with open('loss_y', mode='r') as f:
        lines = f.readlines()
        nums = []
        for line in lines:
            nums += [int(i) for i in line.strip().split(" ")]

    with open('translate.sv', 'w') as fout:
        fout.write(header)
        for num in nums:
            fout.write(str(num) + ', ')
        fout.write(str(nums[-1]))
        fout.write(tail)

def main2():
    with open('loss_y', mode='r') as f:
        lines = f.readlines()
        nums = []
        for line in lines:
            nums += [int(i) for i in line.strip().split(" ")]

    with open('translate.mif', 'w') as fout:
        fout.write('''WIDTH=8;\n\
DEPTH=204800;\n\
ADDRESS_RADIX=DEC;\n\
DATA_RADIX=DEC;\n\
CONTENT BEGIN\n\
'''
        )
        for idx,data in enumerate(nums):
            fout.write(f'{idx}:{data};\n')
        fout.write('END')
    
        

if __name__ == '__main__':
    main2()