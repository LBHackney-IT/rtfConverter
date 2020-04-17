use lib '.';
use XML::DOM;
use RTF::HTMLConverter;

my $html = '';
my $parser = RTF::HTMLConverter->new(
  in => $ARGV[0],
  out => $ARGV[1],
  DOMImplementation => 'XML::DOM',
  discard_images => 1,
);
$parser->parse();
