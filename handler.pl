#!/opt/bin/perl

use XML::DOM;
use RTF::HTMLConverter;
use JSON;

sub send_html {
	my $html = $_[0];
	my $response = {
		statusCode => 200,
		headers => { 'Content-Type' => 'text/html' },
		isBase64Encoded => false,
		body => $html
	};
	return encode_json($response);
}

sub convert {
	my $event_data = decode_json($ENV{EVENT_DATA});
	
	# Extract the document body
	$body = $event_data->{'body'};

	# Hack to create a temporary input file - should be able to create a file handle instead
  open (my $handle,'>','/tmp/input.rtf') or die("Could not open /tmp/input.rtf");
  print $handle $body;
  close ($handle) or die ("Unable to close /tmp/input.rtf");

	# Convert temp file to html
	my $html = '';
	my $parser = RTF::HTMLConverter->new(
		in => '/tmp/input.rtf',
		out => \$html,
		DOMImplementation => 'XML::DOM',
		discard_images => 1,
	);
	$parser->parse();

	# Send the response
	return send_html($html);
}

sub form {
	open (my $fh,'<','form.html') or die("Could not open form.html");
	my $html = do { local $/; <$fh> };
	return send_html($html);
}

my %functions = (
  convert  => \&convert,
  form  => \&form,
);

my $function = shift;

if (exists $functions{$function}) {
  print $functions{$function}->();
} else {
  die "There is no function called $function available\n";
}
