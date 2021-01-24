#!/usr/bin/python3
#
# Parsing aarch64 ISA list in xml into armv8_isa_table.yaml.
#
# Note:
#   This script generates yaml from xml which is given by Arm.ltd. 
#   ISA version is A64_ISA_xml_v87A-2020-12, 
#   and not tested in any other versions. 
#
#   https://developer.arm.com/-/media/developer/products/architecture/armv8-a-architecture/2020-12/A64_ISA_xml_v87A-2020-12.tar.gz
#
#
import xml.etree.ElementTree as ET
import pprint
import yaml

tree = ET.parse('onebigfile.xml')
root = tree.getroot()

#
# instructionsection -> iclass -> arch_variant
#

isa_table = []
isa_key_list = []

for i in root.iter('instructionsection'):
    print("----------------")
    instructionsection_id = i.attrib['id']
    instructionsection = i
    tmp_table = [instructionsection_id,"None","None","None","None"]
    desc="None"

    for j in i.findall("./desc/brief"):
        try:
            desc=str(j[0].text)
            #print(desc)
        except IndexError:
            try:
                desc=str(j.text)
                #print(desc)
            except IndexError:    
                print("FATAL ERROR: desc/brief not found.")
                print("instructionsection_id = ",instructionsection_id)

    for j in instructionsection.iter('iclass'):
        try:
            iclass_id = j.attrib['id']
            tmp_table = [instructionsection_id,desc,iclass_id,"None","None"]
        except KeyError:
            continue

        iclass = j
        arch_variant_name_count = 0

        for k in iclass.iter('arch_variant'):
            try:
                arch_variant_name = k.attrib['name']
                arch_variant_name_count = arch_variant_name_count + 1
            except KeyError:
                continue

        if(arch_variant_name_count):
            for k in iclass.iter('arch_variant'):
                try:
                    print("    instructionsection.id=",i.attrib['id'])
                    print("    description=",desc)
                    print("    iclass.id=",j.attrib['id'])
                    print("    arch_variant.name=",k.attrib['name'])
                    print("    arch_variant.feature=",k.attrib['feature'])
                    arch_variant_name    = k.attrib['name']
                    arch_variant_feature = k.attrib['feature']
                    tmp_table = [instructionsection_id,desc,iclass_id,arch_variant_name,arch_variant_feature]
                    tmp_dict = {instructionsection_id:{'DESC':desc,'CLASS':iclass_id,'VARIANT':arch_variant_name,'VARIANT_FEATURE':arch_variant_feature}}
                    isa_table.append(tmp_table)
                    isa_key_list.append(tmp_dict)
                except KeyError:
                    continue
                arch_variant = k
        else:
            print("    instructionsection.id=",i.attrib['id'])
            print("    description=",desc)
            print("    iclass.id=",j.attrib['id'])        
            tmp_table = [instructionsection_id,desc,iclass_id,"None"]
            if('sve' in iclass_id):
                tmp_dict = {instructionsection_id:{'DESC':desc,'CLASS':iclass_id,'VARIANT':"SVE",'VARIANT_FEATURE':"None"}}
            else:
                tmp_dict = {instructionsection_id:{'DESC':desc,'CLASS':iclass_id,'VARIANT':"ARMv8.0",'VARIANT_FEATURE':"None"}}      
            isa_table.append(tmp_table)
            isa_key_list.append(tmp_dict)

print("-----------------------------------")
print("Total listed instructions:",len(isa_key_list))
#pprint.pprint(isa_key_list)
print("-----------------------------------")

#
# Yaml output format
# instructionsection.id:
#   CLASS   : iclass.id
#   DESC    : description
#   VARIANT : arch_variant.name:
#
with open('armv8_isa_table.yaml', 'w') as file:
    yaml.dump(isa_key_list, file)
print("---------Program end --------------")
