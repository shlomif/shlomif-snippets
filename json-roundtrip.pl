#!/usr/bin/perl

use strict;
use warnings;

use JSON::MaybeXS qw(encode_json decode_json);

my $data = { html_key => <<'EOF' };
<script type="text/language">
alert("I am running");
</script>
EOF

my $json = encode_json($data);

print <<"EOF";
The JSON is:
<<<

$json

>>>
EOF

my $from_json = decode_json($json);

my $html = $from_json->{html_key};

print <<"EOF";
The HTML is:

[[[

$html

]]]
EOF
