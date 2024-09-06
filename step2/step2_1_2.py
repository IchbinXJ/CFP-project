#!/usr/bin/env python
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
##########################################################################
def process_section(section):
    lines = section.split('\n')
    processed_lines = []
    for line in lines:
        if re.match(r'^ \d',line):
            numbers = re.findall(r'-?\d+\.\d+', line)
#            print(numbers)
            if len(numbers) > 1 and line.startswith(' 3'):
                line = re.sub(r'\d+\.\d+', '0.003', line, count=2)
                line = re.sub(r'\d+\.\d+', '0.30', line, count=1)
            else:
                line = re.sub(r'\d+\.\d+', '0.000', line, count=2)
                line = re.sub(r'\d+\.\d+', '3.30', line, count=1)
        processed_lines.append(line)
    processed_section = '\n'.join(processed_lines)
    return processed_section
#############################################################################
def process_section2(section):
    lines = section.split('\n')
    processed_lines = []
    for line in lines:
        if re.match(r'^ \d',line):
            numbers = re.findall(r'-?\d+\.\d+', line)
#            print(numbers)
            if len(numbers) > 1 and line.startswith(' 3'):
                line = re.sub(r'\d+\.\d+', '0.000', line, count=2)
                line = re.sub(r'\d+\.\d+', '3.30', line, count=1)
            else:
                line = re.sub(r'\d+\.\d+', '0.000', line, count=2)
                line = re.sub(r'\d+\.\d+', '3.30', line, count=1)
        processed_lines.append(line)
    processed_section2 = '\n'.join(processed_lines)
    return processed_section2
###############################################################################
file_paths_in1 = glob.glob('./*.in1')
file_paths_in1c = glob.glob('./*.in1c')

file_paths= file_paths_in1 + file_paths_in1c
keyword = 'GLOBAL E-PARAMETER WITH n OTHER CHOICES, global APW/LAPW'

for file_path in file_paths:
    with open(file_path, 'r') as file:
        content = file.read()
    sections = split_file_by_keyword(file_path, keyword)
    processed_sections = []
    for index, section in enumerate(sections):
        if index in sm_indices:
            processed_section = process_section(section)
            processed_sections.append(processed_section)
        else:
            processed_section = process_section2(section)
            processed_sections.append(processed_section)

    processed_content = keyword.join(processed_sections)
    print(processed_content)

    with open(file_path, 'w') as file:
        file.write(processed_content)

