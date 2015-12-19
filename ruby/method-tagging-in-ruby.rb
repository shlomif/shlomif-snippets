dries@kaa ~ $ cat tag.rb
class Method
        @@tags = {}

        def tag
                @@tags[self.to_s]
        end

        def tag=(x)
                @@tags[self.to_s]=x
        end
end

dries@kaa ~ $ irb -rtag
irb(main):001:0> "boo".method(:length).tag = "far"
=> "far"
irb(main):002:0> "randomstring".method(:length).tag
=> "far"
irb(main):003:0>
