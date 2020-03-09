```@meta
EditURL="https://:@hirlam.org/trac//wiki/Training/HarmonieSystemTraining2011/Lecture/Installation/PreqHard?action=edit"
```
# Hardware Prerequisites

* Recent AMD or Intel CPU (the more cores, the merrier).

* At least 512 Mbyte of RAM (more is better).
  - In 512 Mbyte of RAM, a 50x50x40 grid can be used comfortably.
  - A 200x200x40 grid needs at least 4 Gbyte of RAM.

* At least 20 Gbyte of disk space (idem).
  - The output of one 6 hour run on a 200x200x40 grid takes 1.25 Gbyte of disk space.

Yes, a HARMONIE system built with MPI can run on a single core CPU by specifying that "scalar jobs" use 'mpirun -np 1' to start the master executable.