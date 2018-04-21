C64 Pacman
==========

What is this?
-------------

Pacman in 6502 assembler for the Commodore 64.

But why?
--------

I was never that happy with any of the home Pacman ports of the 80s, and was also quite curious about how to write an arcade game in the machine code of the day, so set about attempting to create a home Pacman port as faithful to the original as possible.


What do I do with it?
---------------------

You'll need 64tass to compile the code, a Makefile is included in src directory which should work on Mac or Linux. For Windows, you'd probably need to convert this to an equivalent batch file.

This should produce a pacman.prg binary in the root of the repo, which you can run with your favourite emulator - I've been using the VICE emulator during development.


