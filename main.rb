 # encoding: UTF-8

class MainProgram 

  require 'Qt'
  # require 'base64'
  require './chat.rb' 

  def initialize
    @app = Qt::Application.new(ARGV)
    @ch = Chat.new
    @ch.show
    @app.exec
  end


=begin

  def is_there_mes_from_server(servMes)
        unless servMes == nil
          @ch.addMessgeFserv("#{servMes}")
          @net.clearMesFromServer
                #servMes = Base64.decode64(servMes)
        end
  end


  def is_there_mes_from_client(clientMes)
        unless clientMes  == nil 
          #@ch.addMessage('main.rb', "Ответ на \"#{clientMes}\"")

          #@ch.addMessage('networking.rb', "Получен из сети: \"#{mesFromServer}\"")

          @net.sending(clientMes)

          clientMes = nil
          @ch.clearMessage
        end
  end

  def start_chating
    @thread = Thread.new do
      loop do
        is_there_mes_from_server(@net.resp[:mesFromServer])
        #servMes = @net.resp[:mesFromServer]
        is_there_mes_from_client(@ch.message)
        #clientMes = @ch.message 
      end
    end
  end

  def stop_shatting
    @thread.kill
  end
=end
end
m = MainProgram.new