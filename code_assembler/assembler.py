import argparse
import re

parser = argparse.ArgumentParser(description='')
parser.add_argument('-f','--file', help='file path', required=True)
parser.add_argument('-o','--outfile', help='outfile path', required=True)
program_args = vars(parser.parse_args())

R_TYPE = "r_type"
I_TYPE = "i_type"
J_TYPE = "j_type"

formats = {
    R_TYPE: "{opcode:0>6}{rs:05b}{rt:05b}{rd:05b}{shamt:05b}{funct:0>6}",
    I_TYPE: "{opcode:0>6}{rs:05b}{rt:05b}{inm:016b}",
    J_TYPE: "{opcode:0>6}{dir:026b}"
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
    },
    "srl": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "shamt"],
        "values": {
            "opcode": "000000",
            "rs": 0,
            "rt": 1,
            "rd": 0,
            "shamt": 2,
            "funct": "000010",
        }
    },
    "sra": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "shamt"],
        "values": {
            "opcode": "000000",
            "rs": 0,
            "rt": 1,
            "rd": 0,
            "shamt": 2,
            "funct": "000011",
        }
    },
    "sllv": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 2,
            "rt": 1,
            "rd": 0,
            "shamt": 0,
            "funct": "000100",
        }
    },
    "srlv": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 2,
            "rt": 1,
            "rd": 0,
            "shamt": 0,
            "funct": "000110",
        }
    },
    "srav": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 2,
            "rt": 1,
            "rd": 0,
            "shamt": 0,
            "funct": "000111",
        }
    },
    "addu": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 1,
            "rt": 2,
            "rd": 0,
            "shamt": 0,
            "funct": "100001",
        }
    },
    "subu": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 1,
            "rt": 2,
            "rd": 0,
            "shamt": 0,
            "funct": "100011",
        }
    },
    "and": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 1,
            "rt": 2,
            "rd": 0,
            "shamt": 0,
            "funct": "100100",
        }
    },
    "or": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 1,
            "rt": 2,
            "rd": 0,
            "shamt": 0,
            "funct": "100101",
        }
    },
    "xor": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 1,
            "rt": 2,
            "rd": 0,
            "shamt": 0,
            "funct": "100110",
        }
    },
    "slt": {
        "optype": R_TYPE,
        "args": ["rt", "rd", "rs"],
        "values": {
            "opcode": "000000",
            "rs": 1,
            "rt": 2,
            "rd": 0,
            "shamt": 0,
            "funct": "101010",
        }
    },
    "lb": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "100000",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "lh": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "100001",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "lw": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "100011",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "lwu": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "100111",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "lbu": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "100100",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "lhu": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "100101",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "sb": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "101000",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "sh": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "101001",
            "rs": 2,
            "rt": 0,
            "inm": 1,
        }
    },
    "addi": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "001000",
            "rs": 1,
            "rt": 0,
            "inm": 2,
        }
    },
    "andi": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "001100",
            "rs": 1,
            "rt": 0,
            "inm": 2,
        }
    },
    "ori": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "001101",
            "rs": 1,
            "rt": 0,
            "inm": 2,
        }
    },
    "xori": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "001110",
            "rs": 1,
            "rt": 0,
            "inm": 2,
        }
    },
    "lui": {
        "optype": I_TYPE,
        "args": ["rt", "inm"],
        "values": {
            "opcode": "001111",
            "rs": 0,
            "rt": 0,
            "inm": 1,
        }
    },
    "slti": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "001010",
            "rs": 1,
            "rt": 0,
            "inm": 2,
        }
    },
    "beq": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "000100",
            "rs": 0,
            "rt": 1,
            "inm": 2,
        }
    },
    "bne": {
        "optype": I_TYPE,
        "args": ["rt", "rs", "inm"],
        "values": {
            "opcode": "000101",
            "rs": 0,
            "rt": 1,
            "inm": 2,
        }
    },
    "j": {
        "optype": J_TYPE,
        "args": ["dir"],
        "values": {
            "opcode": "000010",
            "dir": 0
        }
    },
    "jal": {
        "optype": J_TYPE,
        "args": ["dir"],
        "values": {
            "opcode": "000011",
            "dir": 0
        }
    },
    "jr": {
        "optype": R_TYPE,
        "args": ["rs"],
        "values": {
            "opcode": "000000",
            "rs": 0,
            "rt": 0,
            "rd": 0,
            "shamt": 0,
            "funct": "001000",
        }
    },
    "jalr": {
        "optype": R_TYPE,
        "optional_args": True,
        "options": {
            1: {
                "args": ["rs"],
                "values": {
                    "opcode": "000000",
                    "rs": 0,
                    "rt": 0,
                    "rd": 31,
                    "shamt": 0,
                    "funct": "001001",
                }
            },
            2: {
                "args": ["rs", "rd"],
                "values": {
                    "opcode": "000000",
                    "rs": 1,
                    "rt": 0,
                    "rd": 0,
                    "shamt": 0,
                    "funct": "001001",
                }
            }
        }
    },
}

def parse_line(line: str):
    # returns op and args
    op = line.split(" ")[0]
    args = re.split(r'[,(]', line.replace(op, ""))
    args = [a.replace(" ", "").replace(")", "").strip() for a in args]
    print(args)
    return op.lower(), args

def get_register_number(reg: str):
    return int(re.findall(r'\d+', reg)[0])

if __name__ == "__main__":
    instructions = []

    with open(program_args["file"], 'r') as f:
        lines = f.readlines()
        for l in lines:
            op, args = parse_line(l)
            print("OP:", op)
            
            op_type = ops[op]
            if "optional_args" in op_type and op_type["optional_args"]:
                values = dict(op_type["options"][len(args)]["values"])
                req_args = list(op_type["options"][len(args)]["args"])
            else:
                values = dict(op_type["values"])
                req_args = list(op_type["args"])
            
            f = formats[op_type["optype"]]
            
            for a in req_args:
                if a in ["rd", "rt", "rs"]:
                    print("\t", a, get_register_number(args[values[a]]))
                    values[a] = get_register_number(args[values[a]])
                else:
                    print("\t", a, int(args[values[a]]))
                    values[a] = int(args[values[a]])

            instructions.append(f.format(**values)) 

    # write
    with open(program_args["outfile"], 'w+') as f:
        for i in instructions:
            f.write(i + "\n")