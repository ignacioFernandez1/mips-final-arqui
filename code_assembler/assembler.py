import argparse
import re

parser = argparse.ArgumentParser(description='')
parser.add_argument('-f','--file', help='file path', required=True)
args = vars(parser.parse_args())

R_TYPE = "r_type"
I_TYPE = "i_type"
J_TYPE = "j_type"

formats = {
    R_TYPE: "{opcode:0>6}{rs:05b}{rt:05b}{rd:05b}{shamt:05b}{funct:0>6}"
}

ops = {
    "sll": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "shamt"],
        "values": {
            "opcode": "000000",
            "rs": 0,
            "rt": 1,
            "rd": 0,
            "shamt": 2,
            "funct": "000000",
        }
    }
}

def get_register_number(reg: str):
    return int(re.findall(r'\d+', reg)[0])

if __name__ == "__main__":
    instructions = []

    with open(args["file"], 'r') as f:
        lines = f.readlines()
        l = lines[0].lower()
        op = l.split(" ")[0]
        args = l.split(" ")[1].split(",")
        args[-1] = args[-1].strip()
        op_type = ops[op]
        f = formats[op_type["optype"]]
        for a in op_type["args"]:
            if a in ["rd", "rt", "rs"]:
                op_type["values"][a] = get_register_number(args[op_type["values"][a]])
            else:
                op_type["values"][a] = int(args[op_type["values"][a]])

        instructions.append(f.format(**op_type["values"])) 

    print(instructions)