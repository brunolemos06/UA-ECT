from PIL import Image, ImageDraw
import random
import os 

# DEFINE
IMAGE_WIDTH             = 16 
BACKGROUND_COLOR        = 0   # black
LINE_COLOR              = 255 # white
OBSTACLE_COLOR          = 128 # gray
MAX_NUMBER_OF_OBSTACLES = 100
images_generated        = 10

def get_white_pixeis(img:Image):
    white_pixeis = []
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            if img.getpixel((x, y)) == LINE_COLOR:
                white_pixeis.append((x, y))
    return white_pixeis

def generate_image(name:str):
    # Cria uma imagem em preto com o tamanho especificado em pixels - IMAGE_WIDTHxIMAGE_WIDTH
    # mono = 'L'
    img = Image.new('L', (IMAGE_WIDTH, IMAGE_WIDTH), color = BACKGROUND_COLOR)

    # Obtém um objeto para desenhar na imagem
    draw = ImageDraw.Draw(img)

    # Desenha uma linha branca de 1 pixel de espessura do topo até ao fundo da imagem
    value_top = random.randint(0, IMAGE_WIDTH - 1)
    value_bottom = random.randint(0, IMAGE_WIDTH - 1)
    draw.line((value_top, 0, value_bottom, IMAGE_WIDTH - 1), fill=LINE_COLOR, width=1)

    obstacles = random.randint(1, MAX_NUMBER_OF_OBSTACLES)
    white_pixeis = get_white_pixeis(img)
    # print in hex format the color of the pixel
    # print(f'White pixel color: {img.getpixel((value_top, 0))}')
    for i in range(obstacles):
        x = random.randint(0, IMAGE_WIDTH - 1)
        y = random.randint(0, IMAGE_WIDTH - 1)
        cond = (x, y) in white_pixeis
        while (cond):
            x = random.randint(0, IMAGE_WIDTH - 1)
            y = random.randint(0, IMAGE_WIDTH - 1)
            cond = (x, y) in white_pixeis
        # draw.point((x, y), fill=OBSTACLE_COLOR)
        draw.point((x, y), fill=OBSTACLE_COLOR)
        if (x+1, y) in white_pixeis:
            draw.point((x-1, y), fill=OBSTACLE_COLOR)
        else:
            draw.point((x+1, y), fill=OBSTACLE_COLOR)

    
    # save image in raw format
    # save the hex value of the pixel
    save_hex_image(img, name)

def save_hex_image(img:Image, name:str):
    with open(f'imagens/{name}.raw', 'wb') as f:
        for x in range(img.size[0]):
            for y in range(img.size[1]):
                f.write(bytes([img.getpixel((x, y))]))

if __name__ == '__main__':
    index_image = 0
    
    # remove all content from path imagens
    for file in os.listdir('imagens'):
        os.remove(os.path.join('imagens', file))

    print('All images removed from imagens folder !\n')

    for i in range(images_generated):
        generate_image(f'img{index_image}')                          # generate image                              
        print('Image {:03d} generated'.format(index_image))             # print using .format() to have always 3 digits
        index_image += 1