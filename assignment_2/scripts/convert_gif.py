import os
from PIL import Image
import requests
import glob
import traceback

def resize_image(img, w, h):
    # resize to match the aspect ratio
    return img.resize((w, h))

def convert(img, w=16, h=16):
    ''' Convert image so it can be input into VHDL code like:
    type color_sprite is array (0 to 1, 0 to 1) of std_logic_vector(0 to 11);
    constant COLOR_ROM : color_sprite := (
        ("000000000000","000000000000"),
        ("000000000000", "000000000000")
    );
    
    Where 1 is w and 1 is h and 12 is the number of bits per pixel.
    '''
    pixels = img.load()

    output = ''
    for i, y in enumerate(range(h)):
        output += '\t('
        for j, x in enumerate(range(w)):
            # import pdb; pdb.set_trace()
            r, g, b, a = pixels[x, y]
            output += '"{0:04b}{1:04b}{2:04b}"'.format(r >> 4, g >> 4, b >> 4)
            if j < w-1:
                output += ','
        output += ')'
        if i < h-1:
            output += ',\n'
    return output

def save_image(output, f_name_out, dimensions):
    with open(f_name_out, 'w') as f:
        f.write('type color_sprite is array (0 to {0}, 0 to {1}) of std_logic_vector(0 to 11);\n'.format(dimensions[0]-1, dimensions[1]-1))
        f.write('constant COLOR_ROM : color_sprite := (\n')
        f.write(output)
        f.write('\n);\n')   

def convert_gif(f_name, w=None, h=None):
    ''' Convert gif so it can be input into VHDL code like:
    type color_sprite is array (0 to 1, 0 to 1) of std_logic_vector(0 to 11);
    constant COLOR_ROM : color_sprite := (
        ("000000000000","000000000000"),
        ("000000000000", "000000000000")
    );
    
    Where 1 is w and 1 is h and 12 is the number of bits per pixel.
    '''
    imgs = gif_to_pil_imgs(f_name)
    output_gif = ""
    # import pdb; pdb.set_trace()
    for i, img in enumerate(imgs):
        output_gif += '\n\t('
        img = resize_image(img, w, h)
        # convert to rgba
        img = img.convert('RGBA')
        output_gif += convert(img, w, h)
        output_gif += ')\n' + ' -- {0}\n'.format(i)
        if i < len(imgs)-1:
            output_gif += ',\n'
    return output_gif
    
def save_gif(output_gif, f_name_out, dimensions):
    with open(f_name_out, 'w') as f:
        f.write('type color_gif_sprite is array (0 to {2}, 0 to {1}, 0 to {0}) of std_logic_vector(0 to 11);\n'.format(dimensions[0]-1, dimensions[1]-1, dimensions[2]-1))
        f.write('constant COLOR_GIF_ROM : color_gif_sprite := (\n')
        f.write(output_gif)
        f.write('\n);\n')

def gif_to_pil_imgs(f_name):
    gif = Image.open(f_name)
    imgs = []
    for i in range(gif.n_frames):
        gif.seek(i)
        imgs.append(gif.copy())
    return imgs

desired_height = 16
for f_name in glob.glob('gifs/*.gif'):
    # try:
    imgs = gif_to_pil_imgs(f_name)
    dimensions = imgs[0].size
    w = int(desired_height * dimensions[0] / dimensions[1])

    output_gif = convert_gif(f_name, w=w, h=desired_height)
    save_gif(output_gif, f_name.split('.')[0] + '.vhdl', (w, desired_height, len(imgs)))
    # except Exception as e:
    #     print(f"Error converting {f_name}: {e}")
