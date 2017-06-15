#!/usr/bin/env ruby -w
require "socket"
#require "differ"
require 'yaml'
require 'base64'

class Server

  def initialize(port, ip)
    @users = {
      "admin" => "admin",
      "user" => "user"}
    @states = {
      "menu" => ["help", "lsu", "lsr", "jr"],
      "chatting" => ["exit"]
    }
    @server = TCPServer.open( ip, port )
    @connections = Hash.new
    @rooms = Array.new
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
            puts "You can use 'ls u(sers)' and 'ls r(ooms)'."
          end
        when "kick"
          username = command[1]
          if username != nil and @connections[:clients].include? username
            cl_puts(client, makeYamlResp("command","server","console","disconnection"))
            @connections[:clients].delete(username)
            puts "#{username} off"
            Thread.kill self
          end
        end
      }.join
    end
  end

  def makeYamlResp(func, from, whom, guts)
    message = {}
    message["func"] = func
    message["from"] = from
    message["whom"] = whom
    message["guts"] = guts
    message.to_yaml
  end
  def cl_puts(client, message)
    print "Sending to user: \n#{message} \n"
    client.puts Base64.encode64(message).gsub(/\n/, "")
  end

  def cl_mes_decode_base64(mes)

  end

  def run
    servers_command
    puts "starting"
    loop {
      puts "loop"

      Thread.start(@server.accept) do |client|
        
        init = client.gets #yaml-file
        #puts init
        #puts "after init"
        #puts Base64.decode64(init)
        #init = client.gets.to_s #yaml-file
        #puts Base64.decode64(init)
         init_mes = YAML.load(Base64.decode64(init))
       # puts client.gets
        #init_mes = {:login, :password}
        #force_encoding(Encoding::UTF_8)
        users_name = init_mes["guts"][0].chomp
         users_pass = init_mes["guts"][1].chomp

            @connections[:clients].each do |other_name, other_client|
              if users_name == other_name || client == other_client
                cl_puts(client, makeYamlResp("message","server","console","This username already exist"))
                cl_puts(client, makeYamlResp("command","server","console","disconnect"))
                Thread.kill self
              end
            end

            if @users[users_name] == users_pass 
              #@users[init_mes[guts][login]] == init_mes[guts][password]
              
              puts "#{users_name} #{client} Connected"
              @connections[:clients][users_name] = client
              #client.puts ";;ce"
             # Base64.encode64(message.to_yaml).gsub(/\n/, "")
              cl_puts(client, makeYamlResp("command","server","console","connection_established"))
              listen_user_messages( users_name, client )
            else
                cl_puts(client, makeYamlResp("message","server","console","Wrong login or password."))
                cl_puts(client, makeYamlResp("command","server","console","disconnect"))
            end

      end

    }.join
  end

    def do_command(command, client, username)
      case command
      when "lsu"
        mes = Array.new
        @connections[:clients].each do |key, value|
          mes << key
        end

        puts "Online users: #{mes}"
        cl_puts(client, makeYamlResp("message","server","console","online users: #{mes}"))
        

      when "lsr"
        cl_puts(client, makeYamlResp("message","server","console","#{@connections[:rooms]}"))
        #client.puts "#{@connections[:rooms]}"

      when "disconnection"
        cl_puts(client, makeYamlResp("command","server","console","disconnection"))
        @connections[:clients].delete(username)
        puts "#{username} off"
        Thread.kill self
      end
    end

  def listen_user_messages( username, client )
    loop {
     puts  msg = YAML.load(Base64.decode64(client.gets.chomp))
      #puts msg[0..1] == ";;"
      if msg["func"] == "command"
        do_command(msg["guts"], client, username)
      else
        @connections[:clients].each do |other_name, other_client|
          unless other_name == username
            other_client.puts makeYamlResp("message",username,other_name,msg["guts"])
          end
        end
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