import os
import time
from multiprocessing import Process
from collections import defaultdict
from upload import firebase_init
from upload import upload_file

INPUT_FILENAME="myFile.txt"
OUTPUT_FILENAME="result.txt"

def classify():
    cmd="edge-impulse-linux-runner > " + INPUT_FILENAME
    #cmd="edge-impulse-linux-runner"
    os.system(cmd)


def process_info():
    while True:
        if os.path.isfile(INPUT_FILENAME):
            with open(INPUT_FILENAME, 'r+') as f:
                lines = f.read().splitlines()
                if len(lines) > 35:
                    prob_dict = defaultdict(lambda: 0.0)
                    for i in range(35):
                        prob_dict = update_dict(lines, -1*(i+2), prob_dict)
                    with open(OUTPUT_FILENAME, "w") as output:
                        classified = max(prob_dict, key=prob_dict.get)
                        print(classified)
                        output.write(classified)
                    upload_file(OUTPUT_FILENAME)
                    if (i%2) == 0:
                        f.truncate(0)
                else:
                    print("Not enough lines in file: " + INPUT_FILENAME)
        else:
            print("No file: " + INPUT_FILENAME)
        time.sleep(7)
        

def update_dict(lines, line_num, prob_dict):
    classification = lines[line_num].split(':')
    if len(classification) >= 2:
        trans_table = {ord(i): None for i in ",{}' "}
        prob_dict[classification[0].translate(trans_table)] += float(classification[1].translate(trans_table))
    return prob_dict

def main():
    firebase_init()
    p1 = Process(target=classify)
    p1.start()
    p2 = Process(target=process_info)
    p2.start()
    p1.join()
    p2.join()

if __name__ == "__main__":
        main()
