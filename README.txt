iskr, is a simple binding to isk-daemon.
Isk daemon can search image in a library to find image via similarity see http://www.imgseek.net/isk-daemon/


iskr usage

require 'iskr'


data_dir = "../test/data/"

isk_server = Isk.new()
#or
#isk_server = Isk.new(1,"localhost","/RPC",31128)

isk_server.load_all_dbs
isk_server.create_create_db(1)

puts isk_server.get_db_img_count

isk_server.add_img(1, "#{data_dir}bla.gir") unless isk_server.is_img_on_db(1)

puts isk_server.get_db_img_count

isk_server.remove_img(1)

puts isk_server.get_db_img_count

# and so on !
