# Conway's Game of Life Implementation in Ruby:
#
# Copyrighted By Shlomi Fish ( http://www.shlomifish.org/ ), 2008
#
# Licensed under the MIT/X11 License:
# http://www.opensource.org/licenses/mit-license.php

require "curses"
include Curses

class Array
    def vicinity(pos, &block)
        return self[ [pos-1,0].max .. (pos+1)].each(&block)
    end
end

class Life < Array
    def initialize(width, height)
        @width = width
        @height = height
        super()

        # Initialize the array
        replace(Array.new(height) { Array.new(width, 0) })
    end

    def loop_over_field()
        @height.times do |y|
            @width.times do |x|
                yield x,y
            end
        end
    end

    def life_print()
        loop_over_field do |x,y|
            setpos(y,x)
            addstr((self[y][x] == 0) ? " " : "*")
        end
        char = getch
        return !((char == "q"[0]) || (char == "x"[0]))
    end

    def num_neighbours(x,y)
        sum = 0
        vicinity(y) do |row|
            row.vicinity(x) { |e| sum += e }
        end
        sum -= self[y][x]
        return sum
    end

    def alive?(x,y)
        nn = num_neighbours(x, y)
        return ((nn == 3) || ((nn == 2) && self[y][x] == 1))
    end

    def step()
        new_field = Life.new(@width, @height)
        loop_over_field do |x,y|
            new_field[y][x] = (alive?(x, y) ? 1 : 0);
        end
        return new_field
    end

end

def first_field()
    field = Life.new(10, 10)

    field[5][5] = 1
    field[4][5] = 1
    field[3][5] = 1
    field[4][4] = 1
    field[5][6] = 1

    return field
end

def read_field(filename)
    fh = File.new(filename, "r")
    dims = fh.readline()
    if dims =~ /^(\d+) +(\d+)$/
        w = Integer($1)
        h = Integer($2)
    else
        throw "Incorrect format for the first line - should be two integers"
    end
    field = Life.new(w, h)
    h.times do |y|
        line = fh.readline
        line.chomp!
        w.times do |x|
            field[y][x] = ((line[x,1] == "*") ? 1 : 0)
        end
    end

    fh.close

    return field
end

field = read_field(ARGV.shift)

init_screen

begin
    while field.life_print do
        field = field.step()
    end
ensure
    close_screen
end
