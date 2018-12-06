require "byebug"

class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end

  def inspect
    @name.inspect
  end

end


class Manager < Employee
  attr_reader :employees

  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

  def bonus(multiplier)
    combined_salary_subordinates = 0
    subordinates = @employees.dup

    until subordinates.empty?
      begin
        cur_employee = subordinates.shift
        combined_salary_subordinates += cur_employee.salary
        subordinates += cur_employee.employees
      rescue NoMethodError
      end
    end

    combined_salary_subordinates * multiplier
  end

  def inspect
    "#{@name.inspect}, #{@employees.inspect}"
  end

end


if __FILE__ == $PROGRAM_NAME
  shawna = Employee.new("Shawna", "TA", 12000, "Darren")
  david = Employee.new("David", "TA", 10000, "Darren")
  darren = Manager.new("Darren", "TA Manager", 78000, "Ned", [shawna, david])
  ned = Manager.new("Ned", "Founder", 1000000, nil, [darren])

  puts ned.bonus(5) # => 500_000
  puts darren.bonus(4) # => 88_000
  puts david.bonus(3) # => 30_000
end
