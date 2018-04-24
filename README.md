C64 Pacman
==========

What is this?
-------------

Pacman in 6502 assembler for the Commodore 64.

But why?
--------

I was never that happy with any of the home Pacman ports of the 80s, was something I never really managed to master back in the day - and was also quite curious about how to write an arcade game in the machine code of the time, so set about attempting to create a home Pacman port as faithful to the original as possible.


What do I do with it?
---------------------

You'll need 64tass to compile the code. A Makefile is included in src directory which should work on Mac OS or Linux. For Windows, you'd probably need to convert this to an equivalent batch file.

This should produce a pacman.prg binary in the root of the repo, which you can run with your favourite emulator - I've been using the VICE emulator during development (in PAL mode - it will also run in NTSC mode, but will be a bit fast).
