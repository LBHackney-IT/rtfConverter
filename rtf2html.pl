use XML::DOM;
use RTF::HTMLConverter;

my $html = '';
my $parser = RTF::HTMLConverter->new(
  in => $ARGV[0],
  out => \$html,
  DOMImplementation => 'XML::DOM',
  discard_images => 1,
);
$parser->parse();

print $html;
