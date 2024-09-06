import re
import glob
import os
import sys
#################
case = parent_folder_name = os.path.basename(os.path.dirname(os.getcwd()))

new_file_name = f"{case}.lua"
#####################################################################
def extract_text_between_keywords(text, keyword1, keyword2):
    pattern = re.compile(rf'{re.escape(keyword1)}(.*?)(?={re.escape(keyword2)})', re.DOTALL)

    match = pattern.search(text)
    if match:
        return match.group(1).strip()
    else:
        print(f"No match found between '{keyword1}' and '{keyword2}'.")
        return None

###############################################
file_paths = glob.glob('./*.outbkq')

if not file_paths:
    print("file not found!")
    sys.exit()

else:
    output1 = []

    keyword1 = "Nonzero crystal field parameters [eV]"
    keyword2 = "Hamiltonian constructed from CFP: real part"

    for file_path in file_paths:
        print(f"Processing file: {file_path}")
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
            result = extract_text_between_keywords(content, keyword1, keyword2)
            if result:
                output1.append(result)
            else:
                print(f"No results extracted from {file_path}.")

    for idx, result in enumerate(output1):
#    print(f"Text between keywords from file {file_paths[idx]}:")
        print(result)
#    print("-" * 40)

#################################################################

lines = result.strip().split('\n')

kCqk = []
qCqk = []
Bqk_real = []
Bqk_imag = []

for index,line in enumerate(lines):
    if index ==0:
        continue
    parts = line.split()
    kCqk.append(int(parts[1]))
    qCqk.append(int(parts[2]))
    Bqk_real.append(float(parts[4]))
    Bqk_imag.append(float(parts[5]))

matrix = list(zip(kCqk,qCqk,Bqk_real,Bqk_imag))

#print(matrix)
#print(len(matrix))

########################################################

Akm = []

for i in range(len(matrix)):
    kCqk, qCqk, Bqk_real, Bqk_imag = matrix[i]
    
    if matrix[i][1] == 0:
        if Bqk_imag != 0:
            Bqk_express = f"{Bqk_real:.6f} + I*{Bqk_imag:.6f}"
        else:
            Bqk_express = f"{Bqk_real:.6f}"
        Akm.append(f"{{{kCqk}, {qCqk}, {Bqk_express}}}")
    elif matrix[i][1] % 2 == 0:
        if Bqk_imag != 0:
            Bqk_express = f"{Bqk_real:.6f} + I*{Bqk_imag:.6f}"
            Bqk_neg_express = f"{Bqk_real:.6f} - I*{Bqk_imag:.6f}"
        else:
            Bqk_express = f"{Bqk_real:.6f}"
            Bqk_neg_express = f"{Bqk_real:.6f}"
        Akm.append(f"{{{kCqk}, {qCqk}, {Bqk_express}}}")
        Akm.append(f"{{{kCqk}, {-qCqk}, {Bqk_neg_express}}}")
    elif matrix[i][1] % 2 == 1:
        if Bqk_imag != 0:
            Bqk_express = f"{-Bqk_real:.6f} + I*{-Bqk_imag:.6f}"
            Bqk_neg_express = f"{Bqk_real:.6f} + I*{-Bqk_imag:.6f}"
        else:
            Bqk_express = f"{-Bqk_real:.6f}"
            Bqk_neg_express = f"{Bqk_real:.6f}"
        Akm.append(f"{{{kCqk}, {qCqk}, {Bqk_express}}}")
        Akm.append(f"{{{kCqk}, {-qCqk}, {Bqk_neg_express}}}")

#################################################################

def sort_key(item):
    parts = item.strip("{}").split(",")
    first_num = int(parts[0].strip())
    second_num = int(parts[1].strip())
    return (first_num, -second_num) 

Akm_sorted = sorted(Akm, key=sort_key)


#print("Akm = {")
#for line in Akm_sorted:
#    print(f"    {line},")
#print("}")

##########################################################################
##################################################################
akm_str = "Akm = {\n"
for line in Akm_sorted:
    akm_str += f"    {line},\n"
akm_str += "}\n"

lua_files = glob.glob('/home/xj54kovo/work/CFP/project1/script1_1to3/cal_CFP/templet.lua')

for file_path in lua_files:
    with open(file_path,'r') as file:
        lua_content = file.read()

    start_idx = lua_content.find("Akm = {")
    end_idx = lua_content.find("}",start_idx) + 1

    new_lua_content = lua_content[:start_idx] + akm_str + lua_content[end_idx:]
    
    if start_idx != -1 and end_idx != -1:
        new_lua_content = lua_content[:start_idx] + akm_str + lua_content[end_idx:]

        with open(new_file_name, 'w') as file:
            file.write(new_lua_content)

        print(1)
    else:
        print(0)
