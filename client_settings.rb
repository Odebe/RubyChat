 # encoding: UTF-8
 require 'yaml'

 class ClientSettings < Qt::Dialog

  slots 'acceptSettings()'

  attr_reader :username,
              :password,
              :serverAddr,
              :serverPort
  
  def initialize
    super

    getSet
    #@mainWindow.setNewSettings(@serverAddr, @serverPort, @username, @password)
    createForms
  end

  def getChat(chat)
    @mainWindow = chat
    @mainWindow.getNewSettings
  end

  def startView

    @addrEditor.clear
    @portEditor.clear
    @usernameEditor.clear
    @passEditor.clear

    @addrEditor.insert(@serverAddr)
    @portEditor.insert(@serverPort)
    @usernameEditor.insert(@username)
    @passEditor.insert(@password)

    self.exec
  end

  def createForms
    setWindowTitle("Настройки")

    linesLayout = Qt::HBoxLayout.new
    labelsLayout = Qt::HBoxLayout.new
    usernameLayout = Qt::HBoxLayout.new
    passLayout = Qt::HBoxLayout.new

    userLabel = Qt::Label.new("Имя пользователя")
    passLabel = Qt::Label.new("Пароль")
    addrLabel = Qt::Label.new("Адресс")
    portLabel = Qt::Label.new("Порт")

    labelsLayout.addWidget(addrLabel)
    labelsLayout.addWidget(portLabel)

    @addrEditor = Qt::LineEdit.new
    @portEditor = Qt::LineEdit.new
    @usernameEditor = Qt::LineEdit.new
    @passEditor = Qt::LineEdit.new

    usernameLayout.addWidget(userLabel)
    usernameLayout.addWidget(@usernameEditor) 

    passLayout.addWidget(passLabel)
    passLayout.addWidget(@passEditor) 

    acceptButton = Qt::PushButton.new("Принять")
    denyButton = Qt::PushButton.new("Отмена")

    buttonsLayout = Qt::HBoxLayout.new do |lay|
      lay.addWidget(acceptButton)
      lay.addWidget(denyButton)
    end

    linesLayout.addWidget(@addrEditor)
    linesLayout.addWidget(@portEditor)

    self.layout = Qt::VBoxLayout.new do |n|
      n.addLayout(labelsLayout)
      n.addLayout(linesLayout)
      n.addLayout(usernameLayout)
      n.addLayout(passLayout)
      n.addLayout(buttonsLayout)
    end

    connect(acceptButton, SIGNAL('clicked()'), self, SLOT('acceptSettings()'))
    connect(denyButton, SIGNAL('clicked()'), self, SLOT('close()'))
  end

  def acceptSettings()
    @settings["login"] = @usernameEditor.text.to_s.force_encoding(Encoding::UTF_8)
    @settings["server"] =  @addrEditor.text.to_s
    @settings["port"] =   @portEditor.text.to_i
    @settings["password"] = @passEditor.text.to_s
    readSettings
    File.open("settings.yml", "w").write @settings.to_yaml
    @mainWindow.getNewSettings
    self.close
  end

  def getSet
    begin
     @settings = YAML::load_file "settings.yml"
    rescue 
      createSettings
    end
    readSettings

  end

  def readSettings
    puts "All keys: #{@settings}"
    @username =  @settings["login"].to_s
    @serverAddr = @settings["server"].to_s
    @serverPort =  @settings["port"].to_s
    @password = @settings["password"].to_s
  end

  def createSettings
    @settings = { "server" => "localhost",
                  "port" => 3000,
                  "login" => "guest",
                  "password" => ""}
    File.open("settings.yml", "w").write @settings.to_yaml
    readSettings
  end

 end