class Object
    def shlomif()
        return self+3
    end
end

a = 100
printf("a.shlomif() = %i\n", a.shlomif());

b = 200
b.shlomif!();
# testing-exclamation-mark.rb:11: undefined method `shlomif!' for 200:Fixnum (NoMethodError)
printf("b = %i\n", b);
