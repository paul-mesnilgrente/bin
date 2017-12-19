#!/bin/bash

function usage
{
    echo "USAGE:"
    echo "    $0 <device> <label> slow|fast"
    echo "    $0 -h|--help"
    echo "DESCRIPTION"
    echo "    Do a complete rewriting of the USB stick, including the partition table"
    echo "OPTIONS"
    echo '    device    the file to the device (to find it, check the command `dmesg`'
    echo "    label     the label that you want to give to the new partition"
    echo "    slow      write 0 on the entire USB stick"
    echo "    fast      write 0 only at the beginning of the USB stick"
    echo "EXAMPLES"
    echo "    $0 /dev/sdb FILES fast"
    echo "    $0 /dev/sdb FILES slow"
}

function write_progress
{
    echo -e "\e[1m\e[32m${@}\e[0m"
}

if [ $# -eq 1 ]; then
    if [ ${1} != '-h' -a ${1} != '--help' ]; then
        echo "ERROR: wrong parameters"
        usage
        exit 1
    fi
    usage
    exit 0
fi

parted --version &> /dev/null
if [ $? -ne 0 ]; then
    echo "Please install the package parted before to run this script"
    exit 3
fi

mkfs.vfat --help &> /dev/null
if [ $? -ne 0 ]; then
    echo "Please install the command mkfs.vfat before to run this script"
    exit 4
fi

if [ $# -ne 3 ]; then
    echo "ERROR: 3 parameters required"
    usage
    exit 5
fi

# exit the program on any failure
set -e

file=${1}
label=${2}
mode=${3}
if [ ! -b ${file} ]; then
    echo "ERROR: ${file} is not a block special file"
    usage
    exit 6
fi

if [ ${mode} != fast -a ${mode} != slow ]; then
    echo "ERROR: mode must slow or fast, nothing else"
    usage
    exit 7
fi

write_progress "Detecting mounted partitions..."
for partition in $(ls ${file}* | tail -n +2); do
    if [ $(grep -c ^${partition} /proc/mounts) -ne 0 ]; then
        write_progress "Unmounting ${partition}..."
        umount ${partition}
    fi
done

sudo ls &> /dev/null
device=$(basename ${file})
sectors=$(cat /sys/block/${device}/size)
bs=$(cat /sys/block/${device}/queue/logical_block_size)
if [ ${mode} = slow ]; then
    count=${sectors}
elif [ ${mode} = fast ]; then
    count=2048
fi
write_progress "Writing ${bs} * ${count} = $((${bs} * ${count})) zeros..."
sudo dd if=/dev/zero of=${file} bs=${bs} count=${count} status=progress

write_progress "Creating the partition table..."
sudo parted ${file} mklabel msdos

write_progress "Creating the empty partition in FAT32..."
sudo parted -a optimal ${file} mkpart primary fat32 0% 100%

write_progress "Creating the filesystem by formatting..."
sudo mkfs.vfat -n ${label} ${file}1

write_progress "\nUSB stick fully cleared!"

exit 0
