# encoding: utf-8



class Networking

  require 'socket'

  attr_accessor  :resp, :addr, :port, :con

  def initialize
 
  end

  def setServersInfo(addr, port)
    @addr = addr.chomp.to_s
    @port = port.to_i
  end

  def start(uname, pass)
      listen
      #@mainPr.start_chating
      start_mes = "#{uname}:#{pass}"
      sending(start_mes)
  end

  def connect (uname, pass)
    # сюда дописать в будущем всякие штуки с ssl 
      @server = TCPSocket.open(@addr, @port)
      start(uname, pass)
  end

  def setMainProgram(main)
    @chat = main
  end

  #EH03-61288

  def do_command(command)
    case command[0..-1]
    when ";;gb"
      @con = false
      @server.close
      @chat.addMessgeFserv("Closing connection. Good bye!")
    when ";;ce"
      @con = true
      @chat.addMessgeFserv("Connection established, Thank you for joining! Happy chatting")
    end
  end

  def listen
      @resp = Thread.new do |t|
        loop do
          mes = @server.gets.chomp
          if mes[0..1] == ";;"
            do_command(mes)
          else
            @chat.addMessgeFserv(mes)
          end
          #t[:mesFromServer] = @server.gets.chomp
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
          #data = gets.strip
          #@sock.send(data, 0, '127.0.0.1', 33333)
          @server.puts "#{mes} "
          puts "networking #{mes}"
  end

  def sockClose
      @server.close
  end
  
end



