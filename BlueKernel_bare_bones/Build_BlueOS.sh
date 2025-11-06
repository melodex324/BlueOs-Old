echo "


_|_|_|    _|        _|    _|  _|_|_|_|              _|_|      _|_|_|
_|    _|  _|        _|    _|  _|                  _|    _|  _|
_|_|_|    _|        _|    _|  _|_|_|  _|_|_|_|_|  _|    _|    _|_|
_|    _|  _|        _|    _|  _|                  _|    _|        _|
_|_|_|    _|_|_|_|    _|_|    _|_|_|_|              _|_|    _|_|_|


_|_|_|_|_|  _|    _|  _|_|_|_|        _|_|      _|_|_|      _|_|_|_|  _|_|_|      _|_|    _|      _|
    _|      _|    _|  _|            _|    _|  _|            _|        _|    _|  _|    _|  _|_|  _|_|
    _|      _|_|_|_|  _|_|_|        _|    _|    _|_|        _|_|_|    _|_|_|    _|    _|  _|  _|  _|
    _|      _|    _|  _|            _|    _|        _|      _|        _|    _|  _|    _|  _|      _|
    _|      _|    _|  _|_|_|_|        _|_|    _|_|_|        _|        _|    _|    _|_|    _|      _|


_|_|_|_|_|  _|    _|  _|_|_|_|      _|_|_|_|  _|    _|  _|_|_|_|_|  _|    _|  _|_|_|    _|_|_|_|
    _|      _|    _|  _|            _|        _|    _|      _|      _|    _|  _|    _|  _|      
    _|      _|_|_|_|  _|_|_|        _|_|_|    _|    _|      _|      _|    _|  _|_|_|    _|_|_|  
    _|      _|    _|  _|            _|        _|    _|      _|      _|    _|  _|    _|  _|      
    _|      _|    _|  _|_|_|_|      _|          _|_|        _|        _|_|    _|    _|  _|_|_|_|


"

echo "You're about to build BlueOs"

#from now on the script will execute commands that will create the iso file
export PATH="$HOME/opt/cross/bin:$PATH"

#make in a directory where the build will be
rm -r Build #remove if the directory exist
mkdir Build
cd Build

#Paths of BlueKernel and BlueOs
BLUELIB_INC="../blueLib/include/" #path to the C include folder of the Blue library

#these commands will assemble, link and compile the os
i686-elf-as ../boot.s -o boot.o #assemble the boot.s file

i686-elf-gcc -c ../kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra -m32 -I$BLUELIB_INC #compiled in C. it is possible to compile in C++ for a kernel written in C++

i686-elf-gcc -c ../blueLib/src/corelib.c -o corelib.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra -m32 -I$BLUELIB_INC


i686-elf-gcc -T ../linker.ld -o BlueOs.bin -ffreestanding -O2 -nostdlib boot.o corelib.o kernel.o -lgcc #link the Os binaries to the boot and the kernel using the linker.ld file


#these commands will create and verify the grub multiboot
grub-file --is-x86-multiboot BlueOs.bin
if grub-file --is-x86-multiboot BlueOs.bin; then #check if multiboot is possible
  echo multiboot confirmed
else
  echo the file is not multiboot #check if multiboot is not possible
fi

#these commands will build the kernel and make a bootbale iso
mkdir -p isodir/boot/grub
cp BlueOs.bin isodir/boot/BlueOs.bin
cp ../grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o BlueOs.iso isodir

#log file in case there's errors
> log.txt #i have no idea how to make a log file for now there's nothing

#start BlueOS //will still boot even if BlueOS.bin isn't compiled so check the code if there isn't any errors
qemu-system-i386 -cdrom BlueOs.iso
