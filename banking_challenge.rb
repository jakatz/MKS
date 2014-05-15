#!/usr/bin/ruby

class Person
	attr_reader :name
	attr_accessor :cash, :creditcards

	def initialize(name, cash)
		@name = name
		@cash = cash
		@creditcards= []

		puts "Hi, #{@name}. You have $#{cash}!"
	end

	def display_credit_balances
		@creditcards.each do |card|
			puts card.current_balance
		end
	end

	def use_credit_card(amount, bank_name)
		this_card = get_credit_card(bank_name)
		if this_card != nil
			this_card.use(amount)
		end
	end

	def get_credit_card(bank_name)
		this_card = @creditcards.select { |card| card.bank.bank_name == bank_name }[0]

		if this_card == nil
			puts "You don't have a credit card with #{bank_name}."
			return
		end

		return this_card
	end

	def pay_bill_for_credit_card(amount, bank_name)
		this_card = get_credit_card(bank_name)
		if this_card != nil
			this_card.pay_bill(amount)
		end
	end

	def pay_all_bills
		creditcards.each do |card|
			pay_bill_for_credit_card(card.credit_balance, card.bank.bank_name)
		end
	end


end



class Bank
	attr_accessor :bank_name, :register

	def initialize(bank_name)
		@bank_name = bank_name
		@register = {}
		puts "#{@bank_name} bank was just created."
	end

	def open_account(individual, wants_card = false)
		@register[individual.name] = 0
		if wants_card == true
			individual.creditcards << CreditCard.new(individual, self)
		end


		puts "#{individual.name}, thanks for opening an account at #{@bank_name}!"
	end

	def deposit(individual, amount)
		if individual.cash < amount 
			puts "#{individual.name} does not have enough cash to deposit $#{amount}."
			return
		end

		@register[individual.name] += amount
		individual.cash -= amount
		puts "#{individual.name} deposited $#{amount} to #{@bank_name}. #{individual.name} has $#{individual.cash}.  #{individual.name}'s account has $#{@register[individual.name]}."
	end

	def withdraw(individual, amount)
		if @register[individual.name] < amount
			puts "#{individual.name} does not have enough money in the account to withdraw $#{amount}."
			return
		end


		@register[individual.name] -= amount
		individual.cash += amount
		puts "#{individual.name} withdrew $#{amount} to #{@bank_name}. #{individual.name} has $#{individual.cash}.  #{individual.name}'s account has $#{@register[individual.name]}."
	end

	def transfer(individual, transfer_to_bank, amount)
		@register[individual.name] -= amount
		transfer_to_bank.register[individual.name] += amount
		puts "#{individual.name} transfered $#{amount} from the #{@bank_name} account to the #{transfer_to_bank.bank_name}.  The #{@bank_name} account has $#{@register[individual.name]} and the #{transfer_to_bank.bank_name} has $#{transfer_to_bank.register[individual.name]}."
	end

	def get_balance(individual)
		if @register[individual.name] == nil
			puts "#{individual.name} does not have an account with #{bank_name}."
			return
		end

		return @register[individual.name]
	end

	def total_cash_in_bank
		"#{@bank_name} has $#{@register.values.reduce(:+)} in the bank."
	end
end

class CreditCard
	attr_reader :individual, :bank, :credit_balance
	attr_accessor :creditcard_number

	def initialize(individual, bank)
		@individual = individual
		@bank = bank
		@creditcard_number = (0..15).map{ rand(10) }.join

		@credit_balance = 0
	end

	def pay_bill(amount)
		if amount > @credit_balance
			puts "Sorry, you can't pay more than your current balance."
			return
		end

		if bank.register[individual.name] < amount
			puts "Insufficient funds."
			return
		end

		bank.register[individual.name] -= amount
		@credit_balance -= amount

		puts "#{individual.name} paid $#{amount} from their account at #{bank.bank_name}. #{individual.name} has $#{bank.register[individual.name]} in their account.  #{individual.name}'s credit card balance is now $#{@credit_balance}."
	end

	def current_balance
		"#{individual.name}'s current credit balance at #{bank.bank_name} is $#{@credit_balance}."
	end

	def use(amount)
		@credit_balance += amount
	end
end


def test
	chase = Bank.new("JP Morgan Chase")
	wells_fargo = Bank.new("Wells Fargo")
	me = Person.new("Shehzan", 500)
	friend1 = Person.new("John", 1000)
	chase.open_account(me, true)
	chase.open_account(friend1, true)
	wells_fargo.open_account(me, true)
	wells_fargo.open_account(friend1)
	chase.deposit(me, 200)
	chase.deposit(friend1, 300)
	chase.withdraw(me, 50)
	chase.transfer(me, wells_fargo, 100)
	chase.deposit(me, 5000)
	chase.withdraw(me, 5000)
	puts chase.total_cash_in_bank
	puts wells_fargo.total_cash_in_bank

	me.use_credit_card(50, "JP Morgan Chase")
	me.use_credit_card(50, "Wells Fargo")
	me.display_credit_balances
	me.pay_all_bills
	me.display_credit_balances
	friend1.use_credit_card(2, "Wells Fargo")
	friend1.use_credit_card(99999999, "JP Morgan Chase")
	friend1.display_credit_balances
	friend1.pay_bill_for_credit_card(999999999, "JP Morgan Chase")
	friend1.pay_bill_for_credit_card(99999999, "JP Morgan Chase")
	puts chase.get_balance(friend1)
	friend1.pay_bill_for_credit_card(chase.get_balance(friend1), "JP Morgan Chase")
	friend1.display_credit_balances
end

test
