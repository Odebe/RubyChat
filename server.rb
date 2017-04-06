#!/usr/bin/env ruby -w
require "socket"
require "differ"

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

  def servers_command
    Thread.new do 
      loop {
        command = gets.chomp.split(' ')
        puts "#{command}"
        case command[0]
        when "ls"
          item = command[1]
          if item == "u"
            mes = Array.new
            @connections[:clients].each do |key, value|
              mes << key
            end
            puts "Online users: #{mes}"
          elsif item == "r"
            puts "#{@rooms}"
          else
            puts "You can use 'ls u(sers)' and 'ls r(ooms)'.5"
          end
        when "kick"
          username = command[1]
          if username != nil and @connections[:clients].include? username
            @connections[:clients][username].puts ";;gb"
            @connections[:clients].delete(username)
          end
        end
      }.join
    end
  end

  def run
    servers_command
    loop {
      Thread.start(@server.accept) do | client |

        init_mes = client.gets.chomp.to_s.split(":")
        #force_encoding(Encoding::UTF_8)
        users_name = init_mes[0]
        users_pass = init_mes[1]
      
        
            @connections[:clients].each do |other_name, other_client|
              if init_mes[0] == other_name || client == other_client
                client.puts "This username already exist"
                client.puts ";;gb"
                Thread.kill self
              end
            end

            if  @users[users_name] == users_pass[0..-2].to_s
              puts "#{users_name} #{client}"
              @connections[:clients][users_name] = client
              client.puts ";;ce"
              listen_user_messages( users_name, client )
            else
                client.puts "Wrong login or password."
                client.puts ";;gb"
            end

      end

    }.join
  end

    def do_command(command, client, username)
      case command[0..-2]
      when ";;lsu"
        mes = Array.new
        @connections[:clients].each do |key, value|
          mes << key
        end
        puts "Online users: #{mes}"
        client.puts "online users: #{mes}"

      when ";;lsr"
        client.puts "#{@connections[:rooms]}"

      when ";;es"
        client.puts ";;gb"
        @connections[:clients].delete(username)
        puts "#{username} off"
        Thread.kill self
      end
    end

  def listen_user_messages( username, client )
    loop {
      msg = client.gets.chomp
      puts msg[0..1] == ";;"
      if msg[0..1] == ";;"
        do_command(msg, client, username)
        puts "mda"
      else
        @connections[:clients].each do |cl_name, cl_client|
          unless cl_name == username
            cl_client.puts "#{username}: #{msg}"
          end
        end
        #послать сообщение всем в комнате
      end
    }
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