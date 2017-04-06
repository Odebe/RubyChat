# encoding: utf-8

#require 'Qt'
require './client_settings.rb'

class Chat < Qt::Widget

  # require 'base64'
  require './chat.rb' 
  require './networking.rb'

    slots 'messend()',
          'connection()',
          'about()',
          'disconnection()',
          'clientSettings()',
          'serverSettings()'

    attr_reader :message 

    def initialize
      super

      @clientSettingsDialog = ClientSettings.new
      @clientSettingsDialog.getChat(self)
      getNewSettings

      @net = Networking.new
      @net.setMainProgram(self)
      @net.setServersInfo(@serverAddr, @serverPort)

      @smallEditor = Qt::TextEdit.new
      @smallEditor.setReadOnly(true)
      @smallEditor.setPlainText("Начало работы\n==========")

      @mesLine = Qt::TextEdit.new
      #@mesLine.setPlainText("Сообщение.".force_encoding('UTF-8'))
      @mesLine.setMaximumHeight(75)
      @mesLine.autoFormatting
      createMenu

      @sendButton = Qt::PushButton.new('Отправить')

      @buttonLayout = Qt::HBoxLayout.new do |b|
        #b.addStretch(1)
        b.addWidget(@mesLine)
        b.addWidget(@sendButton)
      end
      self.setFixedSize(350, 300)
      puts self.size.to_s

      lllayout = Qt::VBoxLayout.new do |m|
        @layout = Qt::VBoxLayout.new do |n|
          n.addWidget(@smallEditor)
          n.addLayout(@buttonLayout)
        end
        m.addLayout(@layout)
        m.menuBar = @menuBar
      end

      @sendButton.setShortcut(Qt::KeySequence.new(Qt::Key_Return))

      setLayout(lllayout)
      connect(@sendButton, SIGNAL('clicked()'), self, SLOT('messend()'))

      setWindowTitle("RubyChat_2.0")

    end

    def send_to_s(clientMes)
      puts "#{clientMes}"
      @net.sending(clientMes) if clientMes != nil
    end

    def setMainProgram(main)
      @mainProgram = main
    end

# уже не нужно
    def set_networking(networking)
      @net = networking
      @net.setServersInfo(@serverAddr, @serverPort)
    end



    def getNewSettings
      @userName = @clientSettingsDialog.username
      @password = @clientSettingsDialog.password
      @serverAddr = @clientSettingsDialog.serverAddr
      @serverPort = @clientSettingsDialog.serverPort

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
        @net.sending(";;es")
        #@mainProgram.stop_shatting
        #@net.sockClose

      rescue => err
        puts "Ошибка #{err}"
        Qt.execute_in_main_thread {@smallEditor.append("<b>Ошибка отключения:</b> #{err}".force_encoding(Encoding::UTF_8))}
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
          @smallEditor.append("<b>Ошибка подключения.</b> Проверьте правильность введённого адреса сервера.")
        #}
      end
    end

    def about()
      test = "Вот такой вот чатик.\nПока он работает плохо, но я стараюь это исправить.\nВерсия от 31.03.2017 13:26."
        Qt::MessageBox.about(self,"О программе",test)
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

    def addMessage(user, text)
      Qt.execute_in_main_thread{
        @smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + "#{user}: " + text.to_s.force_encoding(Encoding::UTF_8))}
    end

    def addMessgeFserv(text)
      Qt.execute_in_main_thread{
        @smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + text.to_s.force_encoding(Encoding::UTF_8))}
    end

    
    def messend()
      if not (text = @mesLine.toPlainText.chomp).nil? and @net.con
        @net.sending(text)
        #@message = text
        addMessage(@userName, text)
        #@smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + "#{@userName}: " + text.to_s)
        @mesLine.clear
      end
    end

end