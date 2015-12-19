5.times { puts "*" }
a = %w( ant bee cat dog elk )
a.each { |animal| puts animal }

def fibo(n)
  i = 0
  a = 0
  b = 1
  while i < n
    yield(i,a)
    i = i+1
    a,b = b,(a+b)
  end
end

fibo(10) { |i,fib_i| puts "The #{i}'th Fib Number is #{fib_i}" }
