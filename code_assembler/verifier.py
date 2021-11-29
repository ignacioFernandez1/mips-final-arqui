import argparse

parser = argparse.ArgumentParser(description='')
parser.add_argument('-i','--instruction', help='instruction code', required=True)
args = vars(parser.parse_args())

if __name__ == '__main__':
    i = args["instruction"]
    print()
    print("R-TYPE:")
    print("\topcode:", i[-32:-26])
    print("\trs:", i[-26:-21])
    print("\trt:", i[-21:-16])
    print("\trd:", i[-16:-11])
    print("\tshamt:", i[-11:-6])
    print("\tfunct:", i[-6:])