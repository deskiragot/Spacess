CC=gcc `pkgconf sdl2_image sdl2 --cflags`
LIBS=`pkgconf sdl2_image sdl2 --libs`
run: spacess
	./spacess
spacess: main.o
	$(CC) main.o $(LIBS) -o spacess
main.o: main.c
	$(CC) main.c -c
main.c: main.m4
	m4 main.m4 > main.c
clean:
	rm spacess *c *o
list-dependencies: spacess
	ldd spacess