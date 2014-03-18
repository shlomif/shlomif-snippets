#!/bin/bash
cat v3_dump-[567].txt | perl -lne 'print "$1\t$2" if (/\Af\((\d+)\) == (\d+)/ && $2)' | sort -k2,2n -k1,1n | uniq --group -f 1  | perl -na -000 -E 'my @l = map{[split" ",$_]}split/\n/,$_;$x=join(",",map{$l[$_+1][0]-$l[$_][0]}0 .. $#l-1);say$x if $x'  | sort | uniq -c | sort -n
