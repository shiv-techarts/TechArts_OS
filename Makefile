GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = loader.o kernel.o

%.o : %.cpp 
	g++ $(GPPPARAMS) -o $@ -c $<
        
%.o : %.s 
	as $(ASPARAMS) -o $@ $<
      
techArtsKernel.bin : linker.ld $(objects) 
	ld $(LDPARAMS) -T $< -o $@ $(objects)

install : techArtsKernel.bin 
	sudo cp $< /boot/TechArtsKernel.bin
    
techarts.iso : techArtsKernel.bin 
	mkdir iso 
	mkdir iso/boot 
	mkdir iso/boot/grub 
	cp $< iso/boot 
	echo 'set timeout = 0' >> iso/boot/grub/grub.cfg 
	echo 'set default = 0' >> iso/boot/grub/grub.cfg 
	echo '' >> iso/boot/grub/grub.cfg 
	echo 'menuentry "TechArts OS" {' >> iso/boot/grub/grub.cfg 
	echo '  multiboot /boot/techArtsKernel.bin' >> iso/boot/grub/grub.cfg 
	echo '  boot' >> iso/boot/grub/grub.cfg 
	echo '}' >> iso/boot/grub/grub.cfg 
	grub-mkrescue --output=$@ iso 
	rm -rf iso
	
run : techarts.iso
	(killall virtualbox && sleep 1) || true
	virtualbox --startvm "TechArts OS" & 

all : techarts.iso
