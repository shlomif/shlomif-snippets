.sub main :main
    .local pmc myclass, iterator, _set

    myclass = newclass 'PermIter'
    addattribute myclass, 'stack'
    addattribute myclass, 'lim'

    _set = new 'ResizablePMCArray'
    push _set, 7
    push _set, 6
    push _set, 5
    push _set, 4
    push _set, 3
    push _set, 2
    push _set, 1

    iterator = new 'PermIter'
    iterator._init(_set)

check_next_perm:
    $P0 = iterator.next_perm()
    $I0 = defined $P0
    if $I0 == 0 goto print_all_end
    $S0 = join "", $P0
    $I0 = $S0
    $N0 = sqrt $I0
    $I1 = $N0
    $I2 = 2
is_prime_start:
    if $I2 == $I1 goto found
    $I3 = $I0 % $I2
    if $I3 == 0 goto check_next_perm
    inc $I2
    goto is_prime_start
found:
    print "Found: "
    say $I0
print_all_end:

.end


=head2 A Permutations Iterator

=cut

.namespace ['PermIter']

.sub _init :method
    .param pmc _set
    .local pmc stack
    .local pmc first_state

    $I0 = _set
    $I0 += 1

    $P0 = new Integer
    $P0 = $I0
    setattribute self, "lim", $P0

    first_state = new 'Hash'
    $P0 = new 'ResizablePMCArray'
    first_state['prefix'] = $P0

    $P0 = _set
    $P1 = clone $P0
    first_state['set'] = $P1

    $P0 = new 'Undef'
    first_state['elem'] = $P0

    $P0 = new 'ResizablePMCArray'
    first_state['prev'] = $P0

    stack = new 'ResizablePMCArray'

    push stack, first_state
    setattribute self, "stack", stack
.end

.sub next_perm :method
    .local pmc stack, s, new_s
    .local int limit

    stack = getattribute self, "stack"
    $P0 = getattribute self, "lim"
    limit = $P0

stack_loop:
    $I0 = stack
    if $I0 == 0 goto ret_undef

    s = stack[-1]
    if $I0 == limit goto ret_prefix

    # Now we need to iterate more.
    $P0 = s['elem']
    $I0 = defined $P0
    if $I0 == 0 goto after_push_to_prev
    $P1 = s['prev']
    push $P1, $P0

after_push_to_prev:

    $P2 = s['set']
    $I0 = $P2
    if $I0 == 0 goto pop_stack

    $P0 = shift $P2
    s['elem'] = $P0


    # Now we push another element to the stack.
    new_s = new 'Hash'

    # Assign new_s['prefix']
    $P0 = s['prefix']
    $P1 = clone $P0
    $P0 = s['elem']

    push $P1, $P0
    new_s['prefix'] = $P1

    # Assign new_s['set]

    $P0 = s['prev']
    $P1 = s['set']
    $P2 = clone $P0
    $P2.append($P1)
    new_s['set'] = $P2

    $P0 = new Undef
    new_s['elem'] = $P0

    $P0 = new ResizablePMCArray
    new_s['prev'] = $P0

    push stack, new_s

    goto after_more_iter

pop_stack:
    $P0 = pop stack
    goto after_more_iter

after_more_iter:
    goto stack_loop

ret_prefix:
    $P0 = pop stack
    $P0 = s['prefix']

    goto ret_something

ret_undef:
    $P0 = new 'Undef'
    goto ret_something

ret_something:
    .return ($P0)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:

