use warnings FATAL => q[uninitialized];
print sort {
    eval { $c <=> 1 }
} 1, 2;
