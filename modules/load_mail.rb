require_relative('../module_med')
require 'net/imap'
require 'mail'

class LoadMail < ModuleMED

  def properties(memory,fdata)
    @memory = memory
    @server = fdata["server"]
    @username = fdata["username"]
    @password = fdata["password"]
    @directory = fdata["folder"]
    @subject_filter = fdata["subject"]
    @attachement_filter = fdata["attachment"]
    @store = @memory[fdata["store"]]

    @directory = 'INBOX' if @directory.nil?
    ''
  end

  def execute(fdata)
    files = Array.new
    imap = Net::IMAP.new(@server,{:port => 993,:ssl=>true})
    imap.authenticate('LOGIN',@username, @password)
    imap.examine(@directory)
    imap.search(["SUBJECT",@subject_filter]).reverse.each do |message_id|
      #envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
      body = imap.fetch(message_id, "BODY[]")[0].attr["BODY[]"]
      mail = Mail.new(body)
      mail.attachments.each do |a|
        next unless a.filename.include?(@attachement_filter)
        path = "/tmp/#{a.filename}"
        files.push(path)
        File.open(path, 'wb') do |file|
          file.write(a.body.decoded)
        end
      end
      break
      #puts "#{envelope.from[0].name}: \t#{envelope.subject}"
    end
  end

end