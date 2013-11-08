#!/usr/bin/env ruby
class Hello
    def myhello
        puts "This is myhello."
    end
end

h = Hello.new
h.myhello()
h.non_existent_method()
