class Car
	@@repaint_count = 0

	def initialize(color)
		@color = color
	end

	def color
		return @color
	end

	def repaint_count
		return @@repaint_count
	end

	def paint(color)
		@color = color
		@@repaint_count += 1
	end

end

c = Car.new("blue")
puts c.color
puts c.repaint_count
c.paint("red")
c.paint("green")
puts c.repaint_count
puts c.color