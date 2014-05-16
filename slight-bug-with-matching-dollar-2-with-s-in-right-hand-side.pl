my $text = <<'END_OF_STRING';
T2_DOCS = humour/by-others/was-the-death-star-attack-an-inside-job/index.html humour/fortunes/friends.html humour/fortunes/index.html humour/fortunes/joel-on-software.html humour/fortunes/nyh-sigs.html humour/fortunes/osp_rules.html humour/fortunes/paul-graham.html humour/fortunes/sharp-perl.html humour/fortunes/sharp-programming.html humour/fortunes/shlomif-factoids.html humour/fortunes/shlomif-fav.html humour/fortunes/shlomif.html humour/fortunes/subversion.html humour/fortunes/tinic.html humour/human-hacking/arabic-v2.html humour/human-hacking/conclusions/index.html humour/human-hacking/hebrew-v2.html
T2_TTMLS =
VIPE_IMAGES =
VIPE_DIRS =
VIPE_DOCS = index.html
VIPE_TTMLS =
END_OF_STRING

if ($ENV{BUG})
{
    print +($text =~ s!^(T2_DOCS = )([^\n]*)!$1 . ($2 =~ s#\bhumour/fortunes/##gr)!emrs ) =~ /T2_DOCS/g
}
else
{
    print +($text =~ s!^(T2_DOCS = )([^\n]*)!$1 . $2!emrs ) =~ /T2_DOCS/g;
}
print "\n";
