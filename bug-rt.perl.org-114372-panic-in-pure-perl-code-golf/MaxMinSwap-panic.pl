#!perl -p
@h{@x=sort{$a<=>$b}/\d+/g}=reverse@x;s#\d+#$h{$&}#g
