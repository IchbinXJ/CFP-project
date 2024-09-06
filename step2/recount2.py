#!/usr/bin/env python
import glob
import os
import re

def replace_second_number(file_path, keyword):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    new_lines = []
    section_start = -1
    for i, line in enumerate(lines):
        if keyword in line:
            if section_start != -1:
                section_length = i - section_start - 1
                def replace_second_number_in_line(match):
                    return f"{match.group(1)}{section_length} {match.group(3)}"

                pattern = re.compile(r"(\S+\s+)(\S+)(\s+.*)")
                if pattern.search(lines[section_start]):
                    lines[section_start] = pattern.sub(replace_second_number_in_line, lines[section_start])
                    print(f"Replaced in file {file_path}: {lines[section_start].strip()}")
            section_start = i
        new_lines.append(line)

    if section_start != -1:
        section_length = len(lines) - section_start - 2
        pattern = re.compile(r"(\S+\s+)(\S+)(\s+.*)")
        if pattern.search(lines[section_start]):
            lines[section_start] = pattern.sub(lambda m: f"{m.group(1)}{section_length} {m.group(3)}", lines[section_start])
            print(f"Replaced in file {file_path}: {lines[section_start].strip()}")

    with open(file_path, 'w') as file:
        file.writelines(new_lines)

file_paths_in1 = glob.glob('./*.in1')
file_paths_in1c = glob.glob('./*.in1c')

file_paths = file_paths_in1 + file_paths_in1c

keyword = "GLOBAL E-PARAMETER WITH n OTHER CHOICES, global APW/LAPW"

for file_path in file_paths:
    if os.path.isfile(file_path):
        replace_second_number(file_path, keyword)
    else:
        print(1)
