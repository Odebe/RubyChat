#!/usr/bin/env ruby -w
require "socket"

class Server


  def initialize( port, ip )
    @users = {
      "admin": "admin",
      "user": "user"}
    @states = {
      "menu": ["help", "lsu", "lsr", "jr"],
      "chatting": ["exit"]
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
        users_name = init_mes[0]
        users_pass = init_mes[1]

        if users_name == @users[users_name] || users_pass == @users[users_pass]

          @connections[:clients].each do |other_name, other_client|
            if nick_name == other_name || client == other_client
              client.puts "This username already exist"
              Thread.kill self
            end
          end

        puts "#{nick_name} #{client}"
        @connections[:clients][nick_name] = client
        client.puts "Connection established, Thank you for joining! Happy chatting"
        listen_user_messages( nick_name, client )

        end
      end
    }.join
  end

  def listen_user_messages( username, client )
    state = "menu"
    loop {
      msg = client.gets.chomp
      if msg[0..1] == ";;"
        command = mes.delete_at(0..1)
        check_command(state, command)
      else
        #послать сообщение всем в комнате
      end
    }
  end

  def do_command(command)
    case command
    when "lsu"

    when "lsr"

    when "help"

    when ""
  end

  def check_command(state, command)
    @states[state].each { |prob_comm| do_command(command) if prob_comm == command }
  end

  def set_state(state)
    case state
    when 2

    when 3

    end
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