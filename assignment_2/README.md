# CE339 Assignment 2

## Directory Structure
- [src](./src/) - Contains all source files for the design
- [constraints.xdc](./constraints.xdc) - Edited constraints file for the project
- [scripts](./scripts/) - 
- [images](./images) - Images for this README file

## Python Scripts

The python scripts are used to generate VHDL ROM syntax from either a GIF or PNG.

### Usage:

- For [convert_image.py](./scripts/convert_image.py), in the script, the target image file name needs to be changed first.
Then run:
```shell
python convert_image.py
```

- For [convert_gif.py](./scripts/convert_gif.py), create a folder called `gif` and place the target gif inside there. And from the command line run:
```shell
python convert_gif.py
```

## Showcase 



## Compiling the project

- Create a new project in Vivado
- Select all `.vhd` files from the [src](./src) folder as the design sources
- Select [constraints.xdc](./constraints.xdc) as the constraints file
- Synthesise, Implement and Generate Bitstream using Vivado
- Enjoy!