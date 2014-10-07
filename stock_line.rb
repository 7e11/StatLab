class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
    #Coloring text with ansi sequences.
    #NOTE: I display variables in the string with #{}. If you are confused, it basicly auto adds .to_s for you.
  end
  #Efficiantly calling a method that is in the same class instead of rewriting it.
  #TODO: Add a randomize color method. something like .rainbow.
  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end
end

def mean? (array, colNum)
  sum = array[colNum].inject(:+)
  mean = sum.to_f / array[colNum].count.to_f
  #puts "The args were #{array} and #{colNum}"
  #return not needed as ruby autoreturns the last assigned value
end
def median? (array, colNum)
  sorted = array[colNum].sort
  len = sorted.length
  #sort the array, then find the median.
  return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

def stdDev? (array, colNum)
  colSquared = []
  for  i in 0..array[colNum].count-1
      colSquared.push((array[colNum][i].to_f - mean?(array, colNum).to_f)**2)
    end
#get mean of that array
    colSquaredSum = colSquared.inject(:+)
    variance = colSquaredSum / colSquared.count
#take the square root to find the standard deviation.
    stdDeviation = Math.sqrt(variance)
  return stdDeviation.to_f
end

def zscore? (array, colNum)
  zScoreArr = []
  mean = mean?(array, colNum).to_f
  dev = stdDev?(array, colNum)
  for i in 0..array[colNum].count-1
    zScoreArr.push((array[colNum][i].to_f - mean) / dev)
  end
return zScoreArr
end

def line? (array, linenum)
  #FIXME: need to input method to go through all columns and get all entrys at the same line.
  lineArr = []
  for i in 0..array.count-1
    lineArr.push(array[i][linenum.to_i])
  end
  return lineArr
end

def point? (array, col, line)
  #FIXME: INput to get a point from a column in a line.
  return array[col.to_i][line.to_i]
end

def getArrCol (array)
  print "Select a column from 1-#{array.count}: ".blue
  colSelection = gets.chomp
  return colSelection.to_i - 1
end

def getLineCol (array)
  print "Select a line from 2-#{array[0].count + 1}: ".blue
  #plus one so the user is not confused.
  lineSelection = gets.chomp
  return lineSelection.to_i - 2
end

#END OF ALL DEF

while true
puts "What is the name of your csv? (Must be in the same dir as this program)".blue
userCSV = gets.chomp
  break if File.exist?(userCSV)
end

#TODO: add in a funciton to grab url.
puts "File Found!".green
inputFile = File.open(userCSV, "r+")
#inputFile = File.open("NVIDIASTOCK.csv", "r+")
topicArray = inputFile.gets.chomp.strip.split(",")
puts "Detected #{topicArray.count} Columns"
for i in 0..topicArray.count-1
  #NOTE: it is -1 because .count does not count zero.
  puts "Column #{i} is: #{topicArray[i]}"
end
#Finish autodetecting columns. Now start the user part.
while true
  puts "Is this correct? (y/n)"
  userCorrectYN = gets.chomp
  break if (userCorrectYN == "y" || userCorrectYN == "n")
end
if (userCorrectYN == "n")
  puts "ERROR: No File Header Definitions".red
  puts "RECOVERY: Please enter #{topicArray.count} column names manually".green
  tempTopicCount = topicArray.count
  topicArray.clear
  for i in 0..tempTopicCount-1
      print "Column #{i} is: "
      tempColumnName = gets.chomp
      #TODO push this onto the array
      topicArray.push(tempColumnName)
    #TODO: Possibly rewrite the first line of the file with these new names?
  end
  puts "RECOVERY: Succeded".green
  puts "User inputted column names: "
  for i in 0..topicArray.count-1
    #NOTE: it is -1 because .count does not count zero.
    puts "Column #{i} is: #{topicArray[i]}"
  end
end

#start running iterators.
allDataArray = []
for i in 0.. topicArray.count-1
  allDataArray.push([])
end
inputFile.each_line{ |line|
  #prevent the splitting of the first line
    lineData = line.chomp.split(",")
    #print "#{lineData.inspect}\n"
    for i in 0..lineData.count-1
        allDataArray[i].push(lineData[i].to_f)
        #print "adding #{lineData[i]} to allDataArray[#{i}]\n"
    end
    #push the open data for that line into an Array
  #  .push(lineData[1].to_f)
}
#puts allDataArray[1].inspect
#TODO: Creating data sets is done.
puts "What would you like to calculate?".blue
puts "WARNING: THE FIRST LINE OF THE CSV WILL BE INGNORED".yellow
while true
  while true
  puts "You can calculate statistics for a column - mean, median, stdDev, zscore".blue
  puts "You can also look up the data - column, line, point".blue
  puts "You can also close the program with - quit".blue
  userCalcSel = gets.chomp
    break if (userCalcSel == "mean" || userCalcSel == "median" ||  userCalcSel == "column" || userCalcSel == "line" || userCalcSel == "point" || userCalcSel == "quit" || userCalcSel == "zscore" || userCalcSel == "stdDev")
  end

  if (userCalcSel == "mean")
    puts "You have selected mean".blue
    colSelection = getArrCol(topicArray)
    mean = mean?(allDataArray, colSelection.to_i)
    puts "The mean for column: #{topicArray[colSelection.to_i]} is: #{mean}".green
  elsif (userCalcSel == "median")
    puts "You have selected median".blue
    colSelection = getArrCol(topicArray)
    median = median?(allDataArray, colSelection.to_i)
    puts "The median for column: #{topicArray[colSelection.to_i]} is: #{median}".green
  elsif (userCalcSel == "column")
    #FIXME: STUFF FOR data lookup.
    colSelection = getArrCol(topicArray)
    puts "All data for column #{topicArray[colSelection.to_i]}: #{allDataArray[colSelection.to_i]}".green
  elsif (userCalcSel == "line")
    #FIXME:NEEEEEEDS A METHOD FOR THIS ONE
    lineSelection = getLineCol(allDataArray)
    puts "All data for line #{lineSelection.to_i + 2}: #{line?(allDataArray, lineSelection.to_i)}".green
  elsif (userCalcSel == "point")
    colSelection = getArrCol(allDataArray)
    lineSelection = getLineCol(allDataArray)
    puts "The data for column #{topicArray[colSelection.to_i]} at line #{lineSelection.to_i + 2} is: #{point?(allDataArray, colSelection, lineSelection)}".green
  elsif (userCalcSel == "zscore")
    colSelection = getArrCol(allDataArray)
    tempZscores = zscore?(allDataArray, colSelection.to_i)
    puts "All zscores for column #{topicArray[colSelection.to_i]}: #{tempZscores}".green
    puts "Output zscores to a file?(y/n)".blue
    userOutputZ = gets.chomp
    if (userOutputZ == "y")
      outputFile = File.new("#{topicArray[colSelection.to_i]} Zscores.txt" , "w")
      tempZscores.each { |zscore| outputFile.print("#{zscore},\n")}
      outputFile.close
      puts "Created new file: \"#{topicArray[colSelection.to_i]} Zscores.txt\"".green
    end
  elsif (userCalcSel == "stdDev")
    colSelection = getArrCol(allDataArray)
    puts "The standard deviation for column #{topicArray[colSelection.to_i]} is: #{stdDev?(allDataArray, colSelection.to_i)}".green
  else
    exit
  end
end

#FIXME: OLD STUFF HERE.
=begin
f = File.new("NVIDIASTOCK.csv", "r")
#set f = to the file, NVIDIASTOCK.csv
openColumn = []
squredOpenColumn = []
lineCount = 0
zScoreArray = []
#initialize Vars

#Run file iterator
f.each_line{ |line|
  #prevent the splitting of the first line
  if (lineCount > 0)
  lineData = line.split(",")
  #push the open data for that line into an Array
  openColumn.push(lineData[1].to_f)
  end
  lineCount = lineCount + 1
}
f.close
#enumreable to add all of an array.
openColumnSum = openColumn.inject(:+)
openColumnMean = openColumnSum.to_f / openColumn.count.to_f
#take each open data, subtract the mean, and square it.
for  i in 0..openColumn.count-1
  squredOpenColumn.push((openColumn[i].to_f - openColumnMean)**2)
end
#add the squared array together.
squaredOpenColumnSum = squredOpenColumn.inject(:+)
squaredOpenColumnMean = squaredOpenColumnSum / squredOpenColumn.count
#take the square root to find the standard deviation.
stdDeviation = Math.sqrt(squaredOpenColumnMean)
puts "The standard deviation of the Open column is #{stdDeviation.round(2).to_s}"

#start calculating z-score
for i in 0..openColumn.count-1
  zScoreArray.push((openColumn[i].to_f - openColumnMean) / stdDeviation)
end
#File.new("zScores.txt")
outputFile = File.new("zScores.txt" , "w")
zScoreArray.each { |zscore| outputFile.print("#{zscore},\n")}
outputFile.close
puts "\"zScores.txt\" has been created in the current Directory"



=end


