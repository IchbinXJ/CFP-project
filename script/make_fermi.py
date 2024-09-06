import os
import glob
import re
######################################################################
def find_ef_value(content):
    lines = content.split('\n')
    process_lines = []
    for line in lines:
        if 'EF=' in line:
            #print(line)
            match = re.findall(r'-?\d*\.\d+',line)
            return match

file_paths_in1 = glob.glob('./*.in1')
file_paths_in1c = glob.glob('./*.in1c')

file_paths= file_paths_in1 + file_paths_in1c

for file_path in file_paths:
    with open(file_path,'r') as file:
        content = file.read()
        ef_value = find_ef_value(content)[0]
#   print(ef_value)


in1_files = [f for f in os.listdir('.') if os.path.isfile(f) and f.endswith('.in1') or f.endswith('.in1c')]

for in1_file in in1_files:
    case = in1_file.split('.')[0]
#    print(case)

fermi_file_path = f"{case}.fermi"
with open(fermi_file_path, 'w') as fermi_file:
    fermi_file.write(ef_value)

    
    #os.system('save_lapw -d {}'.format(case))
