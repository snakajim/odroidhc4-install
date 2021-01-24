#!/bin/bash
#
# Download xml arm-v8a instruction set architecture manual from arm.
#
work_dir=${PWD}
if [ ! -f ${work_dir}/onebigfile.xml ]; then 
  rm -rf ${work_dir}/xml && mkdir -p ${work_dir}/xml && cd ${work_dir}/xml
  aria2c -x4 \
    https://developer.arm.com/-/media/developer/products/architecture/armv8-a-architecture/2020-12/A64_ISA_xml_v87A-2020-12.tar.gz \
    -o A64_ISA_xml_v87A-2020-12.tar.gz && tar -zxvf A64_ISA_xml_v87A-2020-12.tar.gz
  if [ ! -f ${work_dir}/xml/ISA_A64_xml_v87A-2020-12/onebigfile.xml ]; then
    echo "Fatal ERROR: onebigfile.xml is not found in A64_ISA_xml_v87A-2020-12.tar.gz. Program exit"
    read -p "Hit enter to exit: "
    exit
  else
    cp ${work_dir}/xml/ISA_A64_xml_v87A-2020-12/onebigfile.xml ${work_dir}/
    echo "Extracting onebigfile.xml is done."
  fi
else
  echo "You have already had onebigfile.xml. Program end."
fi
