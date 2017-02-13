require 'socket'


class Networking

  attr_accessor  :resp, :addr, :port

  def initialize
    @user = "User1"
    #sending(@user)
    @mesFromServer = nil
  end

  def start
      listen
      @mainPr.start_chating
      sending(@user)
  end

  def connect
      @server = TCPSocket.open("localhost", 3000)
  end

  def setMainProgram(main)
    @mainPr = main
  end

  def listen
      @resp = Thread.new do
        t = Thread.current
        loop do
          t[:mesFromServer] = @server.gets.chomp
        end
      end 
  end

  def clearMesFromServer
    @resp[:mesFromServer] = nil
  end

  def getMesFromServer
    @mesFromServer
  end

  def sending(mes)
        unless mes == nil
          #data = gets.strip
          #@sock.send(data, 0, '127.0.0.1', 33333)
          @server.puts (mes)
          puts "networking #{mes}"
          mes = nil
        end
  end

  def sockClose
      @server.close
  end
  
end



