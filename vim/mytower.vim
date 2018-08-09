" =head1 COPYRIGHT & LICENSE
"
" Copyright 2018 by Shlomi Fish
"
" This program is distributed under the MIT / Expat License:
" L<http://www.opensource.org/licenses/mit-license.php>
"
" Permission is hereby granted, free of charge, to any person
" obtaining a copy of this software and associated documentation
" files (the "Software"), to deal in the Software without
" restriction, including without limitation the rights to use,
" copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the
" Software is furnished to do so, subject to the following
" conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
" OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
" HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
" WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
" OTHER DEALINGS IN THE SOFTWARE.

" Lines:
" 11 - contains the recursion depth
" 12 - contains the next commands to be recursed into
" 13 - contains column src (one for each depth)
" 14 - contains column dest (one for each depth)
" 15 - contains column other (one for each depth)

" Registers:
" s - source stack (for the move disk macro)
" d - dest stack (for the move disk macro)
" o - other stack
" u - the disc being moved
" c - the command to recurse to

" Marks:
" p - The stack pointer

" Put 10 in line no. 5
map <F2> 5ggDi10<ESC>
map <F3> 5gg"ny$gg$a[<C-R>n]<ESC>5gg<C-X>
map _3 <F3>
map <F9> <F2>10ggi_3<ESC>0"5y$10@511ggi10<ESC>12gg9a_6<ESC>a0000<ESC><S-F9>
map <S-F9> 13gga1<ESC>30a <ESC>14ggi2<ESC>30a <ESC>15ggi3<ESC>30a <ESC>12ggmp
map <F4> <F9><F6>
" Delay of one unit.
" map <F5> :sleep 300m<CR>
map <F5> :sleep 1m<CR>
map _6 <F6>
" The main function
map <F6> `pj"sylj"oylj"dyl<S-F8>`pj"sylj"dyl<F7>`pj"oylj"dylj"syl<S-F8>
"        <---------------> - Assign new_src=src, new_dest=other,
"                            new_other=dest
"                         <----> - Recurse
"                               <--------------> - Move the disk from source
"                                                     to dest
"                                               <--------------->
" Assign new_src=other, new_dest=dest, new_other=src   <--|

" Recurse into the next stage and then back-track
map <S-F6> `p"cy2l`p2lmp@c`phhmp
"          <-----> - read the recusrion command into register c
"                 <----> - set the mark two places to the right
"                       <> - Recurse (if at all)
"                         <----> - Set the mark two places to the left
" move a disk
map <F7> @sgg$?[<CR>"uy$d$@dgg$"up<F5>
" put the new source/dest/other values in the p+1 places in their stacks.
map <F8> `pljlxh"sphjlxh"dphjlxh"oph
" integrated recursing procedure
map <S-F8> <F8><S-F6>
