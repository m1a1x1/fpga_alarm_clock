from PIL import Image

MIF_HEAD = """DEPTH = 8192;
WIDTH = 1;
ADDRESS_RADIX = HEX;
DATA_RADIX = BIN;

CONTENT
BEGIN"""

MIF_ENDING = "END;"

ING_DIR = "days_lable/"

def get_string( im ):

  raw = ""
  mem = ""

  for i in range( 210 ):
    print( raw )
    if( i%30 == 0 ):
      print ("----------------------------------------" ) 
    print( raw )
    raw=""
    for j in range( 38 ):
      pix = im.getpixel( (j, i) )
      if( pix[0] > 120 ):
        color = 0;
      else:
        color = 1;
      raw = raw + str(color)
      mem = mem + hex(38*i+j)[2:] + " : " + str(color) + ";\n"

  return( mem )

def write_file( fname, header, content, ending):
  f = open(fname, 'w')
  f.write( header + "\n\n" + content + "\n\n" + ending)
  f.close()

all_img = [0]

all_img[0] = Image.open(ING_DIR+"days_lable.jpg")

mem_init_data = get_string( all_img[0] )
mem_fname = "../" + "days_lable" + ".mif"
write_file( mem_fname, MIF_HEAD, mem_init_data, MIF_ENDING)
