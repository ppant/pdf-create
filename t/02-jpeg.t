#!/usr/bin/perl -w
#
# simple test page with jpeg image
#

BEGIN { unshift @INC, "lib", "../lib" }
use strict;
use PDF::Create;

print "1..2\n";

my $pdfname = $0;
$pdfname =~ s/\.t/\.pdf/;

my $pdf = new PDF::Create('filename' => "$pdfname",
		  	  'Version'  => 1.2,
			  'PageMode' => 'UseOutlines',
			  'Author'   => 'Markus Baertschi',
			  'Title'    => 'Simple JPEG Test Document',
			);

my $root = $pdf->new_page('MediaBox' => $pdf->get_page_size('A4'));

# Prepare 2 fonts
my $f1 = $pdf->font('Subtype'  => 'Type1',
   	            'Encoding' => 'WinAnsiEncoding',
	            'BaseFont' => 'Helvetica');

# Add a page which inherits its attributes from $root
my $page = $root->new_page;

# Write some text to the page
$page->stringc($f1, 40, 306, 700, 'PDF::Create');
$page->stringc($f1, 20, 306, 650, "version $PDF::Create::VERSION");
$page->stringc($f1, 20, 306, 600, 'Simple JPEG Test Document');
$page->stringc($f1, 20, 300, 300, 'Fabien Tassin');
$page->stringc($f1, 20, 300, 250, 'Markus Baertschi (markus@markus.org)');

# Add a JPEG image
$page->string($f1, 20, 200, 400, 'JPEG Image:');
my $img1 = $pdf->image('pdf-logo.jpg');
$page->image('image'=>$img1, 'xscale'=>0.2,'yscale'=>0.2,'xpos'=>350,'ypos'=>400);

# Wrap up the PDF and close the file
$pdf->close;

# Check the resulting pdf for errors with pdftotext
if (-x '/usr/bin/pdftotext') {
  if (my $out=`/usr/bin/pdftotext $pdfname -`) {
    print "ok 1 # pdf reads fine with pdftotext\n";
  } else {
    print "not ok 1 # pdftotext reported errors\n";
    exit 1;
  }
} else {
  print "ok 1 # Warning: /usr/bin/pdftotext not installed";
}
print "ok 2 \# test $0 ended\n";
