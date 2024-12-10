all:
	@mkdir build
	@nasm -fwin32 main.asm -o build/main.o
	@nasm -fwin32 comp.asm -o build/comp.o
	@gcc -m32 build/*.o -o main.exe

clean:
	@rm -rf build
	@rm -f main.exe
