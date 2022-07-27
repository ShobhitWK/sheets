require 'date'
require "bundler"

Bundler.require

# setting up the file online

session = GoogleDrive::Session.from_service_account_key("client_secret.json")
spreadsheet = session.spreadsheet_by_title("dailyreport")
worksheet = spreadsheet.worksheets.first

START = "-----------------------------------------Daily Status Generator-----------------------------------------"

# integer validator

while true
  system("clear")
  puts START
  print "How many rows you want to insert [1-5]: "
  rows_no = gets.chomp.to_i
  if rows_no.is_a?(Integer) && rows_no.to_i > 0 && rows_no.to_i <= 5
    break
  else
    next
  end
end

worksheet.delete_rows(2,rows_no+1)

a = "#{Date.today-1}".to_s.split("-") # idk why but ...
date = "#{a[2]}/#{a[1]}/#{a[0]}"

for i in 2..rows_no+1

  # adding today's date

  worksheet["A#{i}"] = date


  print "\n"

  print "Enter Task #{i-1}: "
  val = gets.chomp.to_s
  worksheet["B#{i}"]=val

  print "Enter Status #{i-1} [d: done, p: pending, l: learning / custom]: "
  val = gets.chomp.to_s

  if val.downcase == "d"
    worksheet["C#{i}"]="Done"
  elsif val.downcase == "p"
    worksheet["C#{i}"]="Pending"
  elsif val.downcase == "l"
    worksheet["C#{i}"]="Learning"
  else
    worksheet["C#{i}"]=val
  end

  print "Enter Time #{i-1}: "
  val = gets.chomp.to_s
  worksheet["D#{i}"]=val

end

begin

  worksheet.save
  print "\nChanges has been saved to the sheets online.\n\n"

rescue => exception

  puts "There's an error while pushing the changes #{exception}"

end

worksheet.rows.first(10).each { |row| puts row.first(6).join(" | ")}

puts "\nOpening daily report in your browser."
system("xdg-open", "https://docs.google.com/spreadsheets/d/1j8OI826uuJN7VuOiiu3eJbsMo8UIGM5IJaS_wUjJhek")

puts "-"*START.length
