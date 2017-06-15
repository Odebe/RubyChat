# encoding: utf-8



class Networking
  require 'yaml'
  require 'socket'
  require 'base64'

  attr_accessor  :resp, :addr, :port, :con

  def initialize(main)
    @chat = main
    @con = false
  end

  def setServersInfo(addr, port)
    @addr = addr.chomp.to_s
    @port = port.to_i
  end

  def start(uname, pass)
      listen
      @uname = uname
      #@mainPr.start_chating
      start_mes = [uname, pass]
      makeYamlMes(start_mes, "connection", "server")
      
      #sending(start_mes)
  end

  def connect (uname, pass)
    # сюда дописать в будущем всякие штуки с ssl 
    if @con == false
      @server = TCPSocket.open(@addr, @port)
      start(uname, pass)
    end
  end
  
#уже не нужно
  def setMainProgram(main)
    @chat = main
  end

  #EH03-61288

  def do_command(command)
    case command
    when "disconnection"
      @con = false
      @server.close
      #@chat
      #@chat.addMessgeFserv("Closing connection. Good bye!") # <------ mes_from_net
      @chat.mes_from_net("console","Closing connection.")
    when "connection_established"
      @con = true
      @chat.mes_from_net("console","Connection established, Thank you for joining! Happy chatting")
      #@chat.addMessgeFserv("Connection established, Thank you for joining! Happy chatting") #< ------ mes_from_net
    end
=begin
    case command[0..-1]
    when ";;gb"
      @con = false
      @server.close
      #@chat
      @chat.addMessgeFserv("Closing connection. Good bye!") # <------ mes_from_net
    when ";;ce"
      @con = true
      @chat.addMessgeFserv("Connection established, Thank you for joining! Happy chatting") #< ------ mes_from_net
    end
=end
  end

  def parseYamlResponse(resp)
    puts mes = YAML.load(resp)
    if mes["func"] == "command" && mes["from"] == "server"
      do_command(mes["guts"])
    elsif mes["func"] == "message"
      @chat.mes_from_net(mes["whom"], mes["guts"])
    end
  end

  def listen
      @resp = Thread.new do |t|
        loop do
          # resp = mes
          resp = Base64.decode64(@server.gets)
          parseYamlResponse(resp)
          #if mes[0..1] == ";;"
            #do_command(mes)
          #else
            #@chat.mes_from_net()
            #@chat.addMessgeFserv(mes)
          end
          #t[:mesFromServer] = @server.gets.chomp
        end
  end

  def clearMesFromServer # уже не нужно
    @resp[:mesFromServer] = nil
  end

  def getMesFromServer# уже не нужно
    @mesFromServer
  end

  def makeYamlMes(guts, func, whom)
    message = {}
    message["func"] = func
    message["from"] = @uname
    message["whom"] = whom
    message["guts"] = guts
    sending(Base64.encode64(message.to_yaml).gsub(/\n/, ""))
  end

  def sending(mes)
    # rename mes to "guts"
    # from = uname
    #data = gets.strip
    #@sock.send(data, 0, '127.0.0.1', 33333)
    @server.puts mes
    #puts "#{mes}"
  end

  def sockClose
    @server.close if @server != nil
  end
end



