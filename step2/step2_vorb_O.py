#!/usr/bin/env python
import glob
import re
import os
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
        if 'NPT= ' in line:
            element = line.split()[0]
            element = re.sub(r'\d+$', '', element)
            return element
    return None
#########################################################################
file_forstruct_paths= glob.glob('./*.struct')
keyword1 = 'ATOM  '
element_indices = []

for file_forstruct_path in file_forstruct_paths:
    sections = split_file_by_keyword(file_forstruct_path, keyword1)
    for index, section in enumerate(sections):
        found_element = find_element(section, index)
        if found_element is not None:
            element_indices.append(found_element)

print("Element:", element_indices)
##############################################################################
content = ""

#####First line######################
num_element = len(element_indices)
first_line = f'  1  1  {num_element}  0.000000E+00 nmod, nsp, natorb, muB*Bext (Ry), spin up'
#print(first_line)
#content.append(first_line)
content += f"{first_line}\n"
#####Element########################
numbered_list = []
element_counts = {}
for element in element_indices:
    if element in element_counts:
        element_counts[element] += 1

    else:
        element_counts[element] = 1

    numbered_list.append(f"{element}{element_counts[element]}")

print(numbered_list)
############################find in dic####333
direc = '/home/xj54kovo/work/CFP/project1/script1_1to3/directionary_step2_for_O'
content_file = ""
nn=0
for element_indice in element_indices:
    print(element_indice)
    file_path = os.path.join(direc, f"{element_indice}")
    nn+=1
    try:
        with open(file_path, 'r', encoding = 'utf-8') as file:
            file_content = file.read()

            replace_content = file_content.replace('place1',f'{nn}')
            replace_content = replace_content.replace('place2',f'{numbered_list[nn-1]}')
            content_file += f"{replace_content}"
    except FileNotFoundError:
        print(f"file no found")
    except Exception as e:
        print(f"Error: {e}")
#print(content_file)

#content.append(content_file)
content += content_file
print(content)

#file_forstruct_paths= glob.glob('./*.struct')
#case = file_forstruct_paths.split('.')[0]
case = os.path.basename(file_forstruct_paths[0]).split('.')[0]

output_file_path = os.path.join('./',f'{case}.vorb')
with open(output_file_path, 'w', encoding='utf-8') as output_file:
    output_file.write(content)



