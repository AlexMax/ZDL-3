CC := i686-w64-mingw32-gcc
RC := i686-w64-mingw32-windres

CFLAGS := -Wall
LDFLAGS := -mwindows -static-libgcc -lcomdlg32 -lshlwapi

OBJS := cfg.o dlg.o sub.o zdl.o

.PHONY: clean

ZDL.exe: $(OBJS) zdl.rc.obj
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJS): %.o : %.c
	$(CC) -c -o $@ $< $(CFLAGS)
zdl.rc.obj: %.rc.obj : %.rc
	$(RC) $< $@

clean:
	rm -f *.exe *.o *.obj
