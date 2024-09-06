import os
import glob
import re
#####################################################################
def split_file_by_keyword(file_path, keyword):
    with open(file_path, 'r') as file:
        content = file.read()
        sections = content.split(keyword)
        return sections
#########################################################################
def find_element(section, index):
    lines = section.split('\n')
    for line in lines:
#        print('Current line:', line)
        if line.startswith('Sm'):
            return index
    return None
#########################################################################
def find_element_number(content):
    lines = content.split('\n')
    process_lines = []
    for line in lines:
        if 'MULT=' in line:
            print(line)
            number = re.findall(r'\d+',line)
            if number:
                return int(number[0])
    return 0

file_forstruct_paths= glob.glob('./*.struct')
keyword1 = 'ATOM  '
sm_indices = []

for file_forstruct_path in file_forstruct_paths:
    sections = split_file_by_keyword(file_forstruct_path, keyword1)
    for index, section in enumerate(sections):
        found_index = find_element(section, index)
        if found_index is not None:
            sm_indices.append(found_index)

#print("Sm indices:", sm_indices)
num = 0
for sm_indice in sm_indices:
    num += find_element_number(sections[sm_indice])

band_number = 7*num
#print(band_number)

#################################################
num2 = 0
for index, section in enumerate(sections):
    if index not in sm_indices:
        num2 += find_element_number(section)

#print(num2)
##################################################################

num3 = 0
for index, section in enumerate(sections):
    if index < sm_indice:
        num3 += find_element_number(section)
print(f"first num:{num3}")

####################################################

def find_number_before_negative_line(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    for i in range(1, len(lines)):
        line = lines[i]
        if any(float(num) < 0 for num in re.findall(r'-?\d+\.?\d*', line)):
            previous_line = lines[i - 1]
            first_number = re.findall(r'-?\d+\.?\d*', previous_line)
            if first_number:
                return float(first_number[0])
    return None

file_paths = glob.glob('./*.vorb')  # Use glob to match all .vorb files
results = []

for file_path in file_paths:
    result = find_number_before_negative_line(file_path)
    if result is not None:
        results.append((file_path, result))

for file_path, result in results:
    print(f"File: {file_path}, Number: {result}")

#########################################################

aa = num2*(result*2+1)+1
bb = aa+ band_number-1

aa = int(aa)
bb = int(bb)

num3 = num3+1
#print (aa,bb)
write_file_path = 'step3.band_number'
with open(write_file_path, 'w') as file:
    file.write(f"{aa} {bb} {num} {num3}\n")

# Print confirmation
print(f"Wrote aa={aa} and bb={bb} to {file_path}")

#######################################


#os.system('echo -e "{} {}\n" |write_inwf'.format(aa,bb))



