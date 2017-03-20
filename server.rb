#!/usr/bin/env ruby -w
require "socket"

class Server


  def initialize( port, ip )
    @users = {
      "admin" => "admin",
      "user" => "user"}
    @states = {
      "menu" => ["help", "lsu", "lsr", "jr"],
      "chatting" => ["exit"]
    }
    @server = TCPServer.open( ip, port )
    @connections = Hash.new
    @rooms = Hash.new
    @clients = Hash.new
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
    run
  end

  def run
    loop {
      Thread.start(@server.accept) do | client |
        init_mes = client.gets.chomp.to_s.split(":")
#force_encoding(Encoding::UTF_8)

        users_name = init_mes[0]
        users_pass = init_mes[1]
      
        
            @connections[:clients].each do |other_name, other_client|
              if init_mes[0] == other_name || client == other_client
                client.puts "This username already exist"
                Thread.kill self
              end
            end

            if  @users[users_name] == users_pass 
              puts "#{users_name} #{client}"
              @connections[:clients][users_name] = client
              client.puts "Connection established, Thank you for joining! Happy chatting"
              listen_user_messages( users_name, client )
            end
      end
    }.join
  end

  def listen_user_messages( username, client )
    loop {
      msg = client.gets.chomp
      if msg[0..1] == ";;"
        do_command(msg, client, username)
      else
        #послать сообщение всем в комнате
      end
    }
  end

  def do_command(command, client, username)
    case command
    when ";;lsu"
      client.puts "#{@connections[:clients]}"
    when ";;lsr"
      client.puts "#{@connections[:rooms]}"
    when ";;es"
      @connections[:clients].delete(username)
      puts "#{username} off"
      Thread.kill self
    end
  end


  def check_command(state, command) #уже не нужна эта функция, но может понадобиться в будущем
    @states[state].each { |prob_comm| do_command(command) if prob_comm == command }
  end


end

Server.new( 3000, "localhost" )

=begin

  def listen_user_messages( username, client )
    loop {
      msg = client.gets.chomp
      @connections[:clients].each do |other_name, other_client|
        unless other_name == username
          puts "#{username.to_s}: #{msg}"
          other_client.puts "#{username.to_s}: #{msg}"
        end
      end
    }
  end
=end