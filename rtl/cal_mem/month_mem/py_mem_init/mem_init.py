from PIL import Image

MIF_HEAD = """DEPTH = 8192;
WIDTH = 1;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;

CONTENT
BEGIN"""

MIF_ENDING = "END;"

ING_DIR = "monthes/"

def get_string( im ):

  raw = ""
  mem = ""

  for i in range( 60 ):
    print( raw )
    raw=""
    for j in range( 130 ):
      pix = im.getpixel( (j, i) )
      if( pix[0] > 120 ):
        color = 0;
      else:
        color = 1;
      raw = raw + str(color)
      mem = mem + hex(130*i+j)[2:] + " : " + str(color) + ";\n"

  return( mem )

def write_file( fname, header, content, ending):
  f = open(fname, 'w')
  f.write( header + "\n\n" + content + "\n\n" + ending)
  f.close()

all_img = [0,1,2,3,4,5]

all_img[0] = Image.open(ING_DIR+"0001.jpg")
all_img[1] = Image.open(ING_DIR+"0203.jpg")
all_img[2] = Image.open(ING_DIR+"0405.jpg")
all_img[3] = Image.open(ING_DIR+"0607.jpg")
all_img[4] = Image.open(ING_DIR+"0809.jpg")
all_img[5] = Image.open(ING_DIR+"1011.jpg")

for i in range(6):
  mem_init_data = get_string( all_img[i] )
  mem_fname = "../" + "%02d%02d"%(i*2,i*2+1)+ ".mif"
  write_file( mem_fname, MIF_HEAD, mem_init_data, MIF_ENDING)

