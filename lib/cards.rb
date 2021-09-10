# create each card with the four different attributes
class Card
  attr_reader :color, :shape, :number, :shading

  # class variables for each attribute
  @@colors = %w[red green blue]
  @@shapes = %w[oval wave diamond]
  @@numbers = %w[1 2 3]
  @@shadings = %w[solid striped blank]

  # Initialize arrays for each attribute
  def initialize(color, shape, number, shading)
    @color = @@colors[color]
    @shape = @@shapes[shape]
    @number = @@numbers[number]
    @shading = @@shadings[shading]
  end

  # display each card on the board with red, blue, or green colored text
  def display_card
    case @color
    when 'red'
      print "#{@color}\t".red
      print "#{@shape}\t".red
      print "#{@number}\t".red
      print "#{@shading}\t".red
      puts
    when 'blue'
      print "#{@color}\t".blue
      print "#{@shape}\t".blue
      print "#{@number}\t".blue
      print "#{@shading}\t".blue
      puts
    when 'green'
      print "#{@color}\t".green
      print "#{@shape}\t".green
      print "#{@number}\t".green
      print "#{@shading}\t".green
      puts
    end
  end
end


