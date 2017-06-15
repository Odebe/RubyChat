# encoding: utf-8

#require 'Qt'


class Chat < Qt::Widget

  require 'base64'
  # require './chat.rb' 
  require './client_settings.rb'
  require './networking.rb'
  require './chatTab.rb'
  require './onlineTab.rb'

    slots 'messend()',
          'connection()',
          'about()',
          'disconnection()',
          'clientSettings()',
          'serverSettings()',
          'destroyall()'

    attr_reader :message, :net

    def initialize
      super
    

      @clientSettingsDialog = ClientSettings.new
      @clientSettingsDialog.getChat(self)
      getNewSettings


      @net = Networking.new(self)
      #@net.setMainProgram(self)
      @net.setServersInfo(@serverAddr, @serverPort)

      @self = self
      @chats = {
        #{}"server" => ChatTab.new(@self)
      }
      @tabs =  Qt::TabWidget.new
      addNewTab("console")
      addNewTab("online")
      #addNewTab("admin")
      #@chats["admin"].addMessage("admin","Добро пожаловать!")
      #@chats["server"].getname(@userName, "server") 


      #@chatTab = ChatTab.new
      #self.addWidget(@chatTab)
      #@chatTab.show
=begin
      @smallEditor = Qt::TextEdit.new
      @smallEditor.setReadOnly(true)
      @smallEditor.setPlainText("Начало работы\n==========")

      @mesLine = Qt::TextEdit.new
      #@mesLine.setPlainText("Сообщение.".force_encoding('UTF-8'))
      @mesLine.setMaximumHeight(75)
      @mesLine.autoFormatting
=end      
      createMenu
=begin
      @sendButton = Qt::PushButton.new('Отправить')

      @buttonLayout = Qt::HBoxLayout.new do |b|
        #b.addStretch(1)
        b.addWidget(@mesLine)
        b.addWidget(@sendButton)
      end

=end
      self.setFixedSize(350, 300)
      puts self.size.to_s
      #makeTabs

      #addNewTab("mda")
      #lolButton = Qt::PushButton.new("Принять")

      lllayout = Qt::VBoxLayout.new do |m|
=begin
        @layout = Qt::VBoxLayout.new do |n|
          n.addWidget(@smallEditor)
          n.addLayout(@buttonLayout)
        end
=end
        #m.addWidget(lolButton)
        m.addWidget(@tabs)
        m.menuBar = @menuBar
      end

      #@sendButton.setShortcut(Qt::KeySequence.new(Qt::Key_Return))


      setLayout(lllayout)
      #connect(lolButton, SIGNAL('clicked()'), self, SLOT('destroyall()'))

      setWindowTitle("rbChat")

    end

    def destroyall
      @chats["destroy"] = ChatTab.new(@self)
      @chats["destroy"].owner = @userName
      @chats["destroy"].whom = "destroy"
      @tabs.addTab(@chats["destroy"], tr("destroy"))
    end

    def addNewTab(name)
      if name == "online"
        @chats[name] = OnlineTab.new(@self)
      else 
        @chats[name] = ChatTab.new(@self)
      end
      #name.equal?("online")? @chats[name] = OnlineTab.new(@self) : @chats[name] = ChatTab.new(@self)
      #@chats[name] = ChatTab.new(@self)
      @chats[name].owner = @userName
      @chats[name].whom = name
      @tabs.addTab(@chats[name], tr(name))
    end

    def makeTabs # вроде бы уже не нужно
      @tabs =  Qt::TabWidget.new
      #i = 0
      @chats.each do |key, value|
        @tabs.addTab(@chats[key], tr(key))
        #@tabs.setTabText(@chats[key], "#{i}")
       # i += 1
      end
     # @tabs.addTab(@chats["server"], tr("Server"))
    end

    def send_to_s(clientMes) #вроде как не нужна уже
      puts "#{clientMes}"
      @net.sending(clientMes) if clientMes != nil
    end

    def setMainProgram(main) #уже не нужна
      @mainProgram = main
    end

# уже не нужно
    def set_networking(networking)
      @net = networking
      @net.setServersInfo(@serverAddr, @serverPort)
    end

    def NetCheck
      @net.con
    end

    def getNewSettings
      @userName = @clientSettingsDialog.username
      @password = @clientSettingsDialog.password
      @serverAddr = @clientSettingsDialog.serverAddr
      @serverPort = @clientSettingsDialog.serverPort
      if @chats != nil
        @chats.each do |name, chat|
          chat.owner = @userName
        end
      end
    end


    def clientSettings()
      @clientSettingsDialog.startView
    end 

# вроде бы тоже не нужно
    def setUserName()
      @userName = @clientSettingsDialog.username
      @password = @clientSettingsDialog.password
    end

    def disconnection()
      begin
        @net.makeYamlMes("disconnection", "command", "server")
        #@net.sending(";;es")
        #@mainProgram.stop_shatting
        #@net.sockClose

      rescue 
        #Qt.execute_in_main_thread {
          @chats["console"].addMessage("console","<b>Ошибка отключения.</b>".force_encoding(Encoding::UTF_8))
        #}
      end
    end

    def setVisTrue
      @setClientAct.setVisible(true)
    end

    def setVisFalse
      @setClientAct.setVisible(false)
    end

    def connection()
      begin
        @net.connect(@userName, @password)
        #@net.start(@userName, @password)
      rescue => err
        #puts "Ошибка #{err}"
        #Qt::MessageBox.about(self,"Ошибка!!!", "#{err}")
        #Qt.execute_in_main_thread {
          puts err
          @chats["console"].addMessage("console","<b>Ошибка подключения.</b> Проверьте правильность введённого адреса сервера.")
          #@chats["server"].smallEditor.append("<b>Ошибка подключения.</b> Проверьте правильность введённого адреса сервера.")
        #}
      end
    end

    def about()
      testt = "Вот такой вот чатик.\nПока он работает плохо, но я стараюь это исправить.\nВерсия от 31.03.2017 13:26."
        Qt::MessageBox.about(self,"О программе",testt)
    end

    def createMenu

      @menuBar = Qt::MenuBar.new

      @fileMenu = Qt::Menu.new("&Файл".force_encoding(Encoding::UTF_8), self)
      @helpMenu = Qt::Menu.new("&Помощь".force_encoding(Encoding::UTF_8), self)
      @setMenu = Qt::Menu.new("&Настройки".force_encoding(Encoding::UTF_8), self)

      @connectAct = Qt::Action.new("Подключиться".force_encoding(Encoding::UTF_8), self)
      connect(@connectAct, SIGNAL('triggered()'), self, SLOT('connection()'))

      @disconnectAct = Qt::Action.new("Отключиться".force_encoding(Encoding::UTF_8), self)
      connect(@disconnectAct, SIGNAL('triggered()'), self, SLOT('disconnection()'))

      @exitAct = Qt::Action.new("Закрыть".force_encoding(Encoding::UTF_8), self)
      @exitAct.shortcut = Qt::KeySequence.new( tr("Ctrl+Q") )
      connect(@exitAct, SIGNAL('triggered()'), self, SLOT('close()'))

      @aboutAct = Qt::Action.new("О программе".force_encoding(Encoding::UTF_8), self)
      @aboutAct.shortcut = Qt::KeySequence.new( tr("Ctrl+H") )
      connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))

      @setClientAct = Qt::Action.new("Клиент".force_encoding(Encoding::UTF_8),self)
      connect(@setClientAct, SIGNAL('triggered()'),self,SLOT('clientSettings()'))

      @fileMenu.addAction(@connectAct)
      @fileMenu.addAction(@disconnectAct)
      @fileMenu.addAction(@exitAct)

      @setMenu.addAction(@setClientAct)

      @helpMenu.addAction(@aboutAct)

      @menuBar.addMenu(@fileMenu)
      @menuBar.addMenu(@setMenu)
      @menuBar.addMenu(@helpMenu)

    end

    def mes_from_net(user, text)#вызывается в networking
                                # когда приходит сообще, которое не является командой
      #Qt.execute_in_main_thread{
        @chats[user].addMessage(user, text)
        #@chats["server"].smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + "#{user}: " + text.to_s.force_encoding(Encoding::UTF_8))}
    end

    def addMessgeFserv(text) #здесь уже не нужна
      #Qt.execute_in_main_thread{
        #@chats["server"].smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + text.to_s.force_encoding(Encoding::UTF_8))}
    end

    def mes_to_net(mes, whom) #вызывается из вкладки
      if @net.con == true
        #text = ";;to:#{whom};m:#{mes}"
        if whom == "console" or whom == "online"
          @net.makeYamlMes(mes, "command", whom)
        else
          @net.makeYamlMes(mes, "message", whom)
        end
        #@net.sending(text)
      end
    end

    def messend() #здесь уже не нужна
      if not (text = @mesLine.toPlainText.chomp).nil? and @net.con
        @net.sending(text)
        #@message = text
        addMessage(@userName, text) # mes_from_net
        #@smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + "#{@userName}: " + text.to_s)
        @mesLine.clear
      end
    end
    
end
