class Board
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,5,9], [3,5,7], [1,4,7], [2,5,8], [3,6,9]]
  def initialize
    @board = {}
    (1..9).each {|position| @board[position] = Position.new(' ')}
  end

    def draw_board
    system "clear"
    puts "         |         |         "
    puts "    #{@board[1]}    |    #{@board[2]}    |    #{@board[3]}    "
    puts "         |         |         "
    puts "-----------------------------"
    puts "         |         |         "
    puts "    #{@board[4]}    |    #{@board[5]}    |    #{@board[6]}    "
    puts "         |         |         "
    puts "-----------------------------"
    puts "         |         |         "
    puts "    #{@board[7]}    |    #{@board[8]}    |    #{@board[9]}    "
    puts "         |         |         "
  end
  
  def empty_positions?
    @board.select {|_, position| position.empty?}.keys
  end
  
  def full_board?
    @board.select {|_, position| position.empty?}.values.size == 0
  end
  
  def mark_position(position, marker)
    @board[position].mark(marker)
  end 

# # computer chooses empty position when winning line has two player marks or two computer marks  
#   def ai_pick
#     WINNING_LINES.each do |line|
#       if @board.values_at(*line).count(Game::@player.marker) == 2 
#         return *line[*line.index(' ')]      
#       if @board.values_at(*line).count(Game::@computer.marker) == 2 
#         return *line[*line.index(' ')] 
#       else 
#         return @board.empty_positions?.sample
#       end
#     end
#   end
 
# checks for winner 
  def winner?(marker)
    WINNING_LINES.each do |line|
      return true if @board[line[0]].value == marker && @board[line[1]].value == marker && @board[line[2]].value == marker
    end
    false
  end  
end

class Position
  attr_accessor :value
  
  def initialize(value)
    @value = value
  end

  def mark(marker)
    @value = marker
  end
  
  def empty?
    @value == ' '
  end
  
  def occupied?
    @value != ' '
  end
  
  def to_s
    @value
  end
end

class Player
  attr_accessor :marker
  def initialize(marker)
    @marker = marker
  end
end

class Game
  attr_accessor :current_player, :player, :computer
  def initialize
    @board = Board.new
  end

# creates new player based on their choice of marker, assigns computer to other marker  
  def assign_marker
    begin
      puts "Choose your marker (X/O)"
      ans = gets.chomp.upcase
    end until ['X', 'O'].include?(ans)
      @player = Player.new(ans)
    if ans == 'X'
      @computer = Player.new('O')
    else
      @computer = Player.new('X')
    end
  end
  
  def current_player_mark_position
    if @current_player == @player
      begin
        puts "Please choose an empty square (1-9)."
        position = gets.chomp.to_i
      end until @board.empty_positions?.include?(position)
    else
#     position = @board.ai_pick
      position = @board.empty_positions?.sample
    end
    @board.mark_position(position, @current_player.marker)
  end

  def alternate_player
    if @current_player == @player
      @current_player = @computer
    else
      @current_player = @player
    end
  end

  def play
    assign_marker
    @current_player = @player
    @board.draw_board
    loop do
      current_player_mark_position
      @board.draw_board
      if @board.winner?(@current_player.marker)
        puts "#{@current_player.marker}'s Won!" 
        puts "Game over."
        break
      elsif @board.full_board?
        puts "It's a tie!" 
        puts "Game over."
        break
      end
      sleep 0.5
      alternate_player
    end
  end
end

Game.new.play
