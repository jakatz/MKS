def fib_nums
	fib1 = 1
	fib2 = 1
	sums = 0

	while fib2 < 4000000
		if fib2 % 2 == 0
			sums += fib2
		end

		new_fib = fib1 + fib2
		fib1, fib2 = fib2, new_fib
	end

	sums
end


a = [1, 2]
max = 4000000

while a[-2] + a[-1] < max
	a << a[-2] + a[-1]
end

sum = 0
a.each { |x| sum += x if x.even? }

puts "The result is #{sum}"



puts fib_nums