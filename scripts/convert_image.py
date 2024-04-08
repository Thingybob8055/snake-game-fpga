import os

from PIL import Image

img = Image.open('game-over.png')

def resize_image(img, w, h):
    return img.resize((w, h))

def convert(img, output, w=211, h=91):
    ''' Convert image so it can be input into VHDL code like:
        
            
    type color_sprite is array (0 to 1, 0 to 1) of std_logic_vector(0 to 11);
    constant COLOR_ROM : color_sprite := (
        ("000000000000","000000000000"),
        ("000000000000", "000000000000")
    );
    
    Where 1 is w and 1 is h and 12 is the number of bits per pixel.
    '''
    img = resize_image(img, w, h)
    pixels = img.load()

    with open(output, 'w') as f:
        f.write('type color_sprite is array (0 to {0}, 0 to {1}) of std_logic_vector(0 to 11);\n'.format(w-1, h-1))
        f.write('constant COLOR_ROM : color_sprite := (\n')
        for i, y in enumerate(range(h)):
            f.write('\t(')
            for j, x in enumerate(range(w)):
                r, g, b, a = pixels[x, y]
                f.write('"{0:04b}{1:04b}{2:04b}"'.format(r >> 4, g >> 4, b >> 4))
                if j < w-1:
                    f.write(',')
            f.write(')')
            if i < h-1:
                f.write(',\n')
        f.write('\n);\n')
    
convert(img, 'snake-block.vhdl')