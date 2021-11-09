class Branch
	def initialize(name, location , currentStock)
      @name = name
      @location = location
      @currentStock = currentStock
	end

	def name
		@name
	end

	def location
		@location
	end

	def currentStock
		@currentStock
	end

	def caculateDistance(position)
		xDistance = (@location[0] - position.location[0]).abs
		yDistance = (@location[1] - position.location[1]).abs
		totalDistance = xDistance + yDistance
		totalDistance += 1 if xDistance>0 && yDistance>0
		return totalDistance
	end
end

class Order
	def initialize(location , amount)
      @location = location
      @amount = amount
	end

	def location
		@location
	end

	def amount
		@amount
	end
end

class Result
	def initialize(name, location, deliveryCost, amount)
      @name = name
      @location = location
	  @deliveryCost = deliveryCost
      @amount = amount
	end

	def name
		@name
	end

	def amount
		@amount
	end
end

def branchesFinder(branches, order)
	orderCleared = false
	multiStore = false
	totalStock = branches.inject(0){|sum,branch| sum + branch.currentStock }
	return [] if totalStock < order.amount

	result = []
	maxStock = branches.max_by {|branch| branch.currentStock }.currentStock
	multiStore = true if maxStock < order.amount

	branches = branches.sort_by { |branch| branch.caculateDistance(order) }
	remainingOrder = order.amount
	for branch in branches
		next if (branch.currentStock < remainingOrder && !multiStore )
		ordered = if branch.currentStock >= remainingOrder
					remainingOrder
				 else
					branch.currentStock
				 end
		remainingOrder -= ordered
		result << Result.new(branch.name, branch.location, branch.caculateDistance(order), ordered)
		break if remainingOrder == 0
	end
	result
end


branchs = [ Branch.new("Ladprao", [1,1], 5), Branch.new("PP", [7,3], 2), Branch.new("Aibo", [2,1], 2) ]
order = Order.new([7,5], 7)
result = branchesFinder(branchs, order)