#!/usr/bin/perl -w

BEGIN { unshift @INC, "lib", "../lib" }
use strict;

use PDF::Create;

my $f1;
my $f2;
my $f3;

sub Coord {
  my $page = shift;
  my $x = shift;
  my $y = shift;
  my $s = shift;
  
  $page->line($x-60, $y, $x+60, $y);
  $page->line($x, $y-45, $x, $y+65);
  $page->line($x, $y+65, $x+2.5, $y+60);
  $page->line($x, $y+65, $x-2.5, $y+60);
  $page->line($x+60, $y, $x+55, $y+2.5);
  $page->line($x+60, $y, $x+55, $y-2.5);
  
  $page->line($x-82.5, $y-80, $x+82.5, $y-80);
  $page->line($x-82.5, $y-80, $x-82.5, $y+80);
  $page->line($x+82.5, $y-80, $x+82.5, $y+80);
  $page->line($x-82.5, $y+80, $x+82.5, $y+80);
  
  my @s = split("\n", $s);
  foreach $s (@s) {
      $page->stringc($f1, 8, $x, $y-60, $s);
      $y-=10;
  }    
}


my $pdf = new PDF::Create('filename' => 'mypdf.pdf',
			  'Version'  => 1.2,
			  'PageMode' => 'UseOutlines',
			  'Author'   => 'Fabien Tassin',
			  'Title'    => 'My title',
			 );
my $root = $pdf->new_page('MediaBox'  => $pdf->get_page_size("letter"));

# Add a page which inherits its attributes from $root
my $page = $root->new_page;

    # Prepare 2 fonts
    $f1 = $pdf->font('Subtype'  => 'Type1',
 	   	        'Encoding' => 'WinAnsiEncoding',
 		        'BaseFont' => 'Helvetica');
    $f2 = $pdf->font('Subtype'  => 'Type1',
 		        'Encoding' => 'WinAnsiEncoding',
 		        'BaseFont' => 'Helvetica-Bold');

    $f3 = $pdf->font('Subtype'  => 'Type1',
 		        'Encoding' => 'WinAnsiEncoding',
 		        'BaseFont' => 'Courier');


    # Prepare a Table of Content
    my $toc = $pdf->new_outline('Title' => 'Document',
                                'Destination' => $page);
    $toc->new_outline('Title' => 'Section 1');
    my $s2 = $toc->new_outline('Title' => 'Section 2', 'Status' => 'closed');
    $s2->new_outline('Title' => 'Subsection 1');

    $page->stringc($f2, 40, 306, 426, "PDF::Create");
    $page->stringc($f1, 20, 306, 396, "version $PDF::Create::VERSION");

    # Add another page
    my $page2 = $root->new_page;
    $page2->line(0, 0, 612, 792);
    $page2->line(0, 792, 612, 0);

$toc->new_outline('Title' => 'Section 3');
$pdf->new_outline('Title' => 'Summary');

# Add something to the first page
$page->stringc($f1, 20, 306, 300, 'by Fabien Tassin <fta@sofaraway.org>');


    # Add images presentation
    my $gif = $pdf->image("sample.gif");
    my $gifinterlace = $pdf->image("sampleinterlace.gif");
    my $jpg = $pdf->image("sample.jpg");

    $page2 = $root->new_page;
    $toc->new_outline('Title' => 'Images', 'Destination' => $page2);


    my $y;
    my $x; 
    $y = 725;
    $page2->stringc($f2, 20, 300, $y, 'Image Support');
    $y-=25;
    $page2->stringl($f1, 13, 50, $y, 'Support for GIF and JPEG-Images by Michael Gross mdgrosse@sbox.tugraz.at.');
    $y-=20;
    $page2->stringl($f1, 10, 50, $y, 'Usage:');
    $y-=15;
    $page2->stringl($f3, 10, 60, $y, '$image = $pdf->image(filename)');
    $y-=15;
    $page2->stringl($f1, 10, 70, $y, 'Creates xobject for image <filename>.');
    $y-=20;
    $page2->stringl($f3, 10, 60, $y, '$page->image(image, x, y, alignx, aligny, ');
    $y-=15;
    $page2->stringl($f3, 10, 60, $y, '  scalex, scaley, rotation, scewx, scewy)');
    $y-=15;
    $page2->stringl($f1, 10, 70, $y, 'Inserts <image> into <$page> at position <x>, <y>.');
    $y-=15;
    $page2->stringl($f3, 10, 70, $y, 'alignx, aligny');
    $page2->stringl($f1, 10, 200, $y, 'Alignment of image. 0 is left/bottom, 1 centered, 2 right/top.');
    $y-=15;
    $page2->stringl($f3, 10, 70, $y, 'scalex, scaley');
    $page2->stringl($f1, 10, 200, $y, 'Scaling of image. 1 for original size.');
    $y-=15;
    $page2->stringl($f3, 10, 70, $y, 'rotation');
    $page2->stringl($f1, 10, 200, $y, 'Image rotation, 0 for no rotation, 2*pi for 360°.');
    $y-=15;
    $page2->stringl($f3, 10, 70, $y, 'scewx, scewy');
    $page2->stringl($f1, 10, 200, $y, 'Image scew.');

    $y = 450;
    $x = 125;    
    $page2->image('image' => $gif, 'xpos' => $x, 'ypos'=>$y);
    Coord($page2, $x, $y, "image('image' => \$gif, 'xpos' => \$x, \n'ypos'=>\$y)");
    
    $x+=165;
    $page2->image('image' => $gif, 'xpos' => $x, 'ypos'=>$y, 'xalign' => 1, 'yalign' => 1);
    Coord($page2, $x, $y, "image('image' => \$gif, 'xpos' => \$x, \n'ypos' => \$y, 'xalign' => 1, 'yalign' => 1)");
    
    $x+=165;
    $page2->image('image' => $gif, 'xpos' => $x, 'ypos'=>$y, 'xalign' => 2, 'yalign' => 2);
    Coord($page2, $x, $y, "image('image' => \$gif, 'xpos' => \$x, \n'ypos' => \$y, 'xalign' => 2, 'yalign' => 2)");


    $y-=160;
    $x = 125;    
    $page2->image('image' => $gif, 'xpos' => $x, 'ypos'=>$y, 'xscale' => 2, yscale => '0.5');
    Coord($page2, $x, $y, "image('image' => \$gif, 'xpos' => \$x, \n'ypos' => \$y, 'xscale' => 2, yscale => '0.5')");
    
    $x+=165;
    $page2->image('image' => $gif, 'xpos' => $x, 'ypos'=>$y, 'rotate' => 0.7);
    Coord($page2, $x, $y, "image('image' => \$gif, 'xpos' => '$x, \n'ypos' => \$y, 'rotate' => 0.7)");
    
    $x+=165;
    $page2->image('image' => $gif, 'xpos' => $x, 'ypos'=>$y, 'xskew' => 0.7);
    Coord($page2, $x, $y, "image('image' => \$gif, 'xpos' => \$x, \n'ypos' => \$y, 'xskew' => 0.7)");


    $y-=160;
    $x = 125;    
    $page2->image('image' => $gif, 'xpos' => $x, 'ypos'=>$y, 'yskew' => 0.7);
    Coord($page2, $x, $y, "image('image' => \$gif, 'xpos' => \$x, \n'ypos' => \$y, 'yskew' => 0.7)");
    
    $x+=165;
    $page2->image('image' => $gifinterlace, 'xpos' => $x, 'ypos'=>$y);
    Coord($page2, $x, $y, 'interlaced GIF');
    
    $x+=165;
    $page2->image('image' => $jpg, 'xpos' => $x, 'ypos'=>$y);
    Coord($page2, $x, $y, 'JPEG image');


# Add the missing PDF objects and a the footer then close the file
$pdf->close;
