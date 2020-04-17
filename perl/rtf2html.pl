use lib '.';
use XML::DOM;
use RTF::HTMLConverter;
use File::Basename;

my $html = '';
my $parser = RTF::HTMLConverter->new(
  in => $ARGV[0],
  out => $ARGV[1],
  DOMImplementation => 'XML::DOM',
  image_dir => dirname($ARGV[1])
);
$parser->parse();