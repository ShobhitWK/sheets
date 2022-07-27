require 'date'
require "bundler"
Bundler.require

# setting up the file online

session = GoogleDrive::Session.from_service_account_key("client_secret.json")
spreadsheet = session.spreadsheet_by_title("dailyreport")
worksheet = spreadsheet.worksheets.first

START = "-----------------------------------------Daily Status Generator-----------------------------------------"

while true
  system("clear")
  puts START
  print "How many rows you want to insert: "
  rows_no = gets.chomp.to_i
  if rows_no.is_a?(Integer) && rows_no.to_i > 0
    break
  else
    next
  end
end

worksheet.delete_rows(2,rows_no+1)

for i in 2..rows_no+1

  worksheet["A#{i}"] = Date.today-1 # for adding today's date

  print "\n"

  print "Enter #{i-1} Task: "
  val = gets.chomp.to_s
  worksheet["B#{i}"]=val

  print "Enter #{i-1} Status [d: done, p: pending, l: learning / custom]: "
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

  print "Enter #{i-1} Time: "
  val = gets.chomp.to_s
  worksheet["D#{i}"]=val

end

worksheet.save

print "\nChanges has been made!\n\n"

worksheet.rows.first(10).each { |row| puts row.first(6).join(" | ")}

puts "\nOpening daily report in your browser."
system("xdg-open", "https://docs.google.com/spreadsheets/d/1j8OI826uuJN7VuOiiu3eJbsMo8UIGM5IJaS_wUjJhek")

puts "-"*START.length
