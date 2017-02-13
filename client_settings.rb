 # encoding: UTF-8
 
 class ClientSettings < Qt::Dialog

 	slots 'acceptSettings()'

	attr_reader :username,
							:serverAddr,
							:serverPort
	
	def initialize
		super

		@settings = Qt::Settings.new("chat.conf", "Chat")
		getSet

		createForms
	end

	def getChat(chat)
		@mainWindow = chat
	end

	def startView

		@addrEditor.clear
		@portEditor.clear
		@usernameEditor.clear

		@addrEditor.insert(@serverAddr)
		@portEditor.insert(@serverPort)
		@usernameEditor.insert(@username)


		self.exec
	end

	def createForms
		setWindowTitle("Настройки")

		linesLayout = Qt::HBoxLayout.new
		labelsLayout = Qt::HBoxLayout.new
		usernameLayout = Qt::HBoxLayout.new

		userLabel = Qt::Label.new("Имя пользователя")
		addrLabel = Qt::Label.new("Адресс")
		portLabel = Qt::Label.new("Порт")

		labelsLayout.addWidget(addrLabel)
		labelsLayout.addWidget(portLabel)

		@addrEditor = Qt::LineEdit.new
		@portEditor = Qt::LineEdit.new
		@usernameEditor = Qt::LineEdit.new

		usernameLayout.addWidget(userLabel)
		usernameLayout.addWidget(@usernameEditor)	

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
			n.addLayout(buttonsLayout)
		end

		connect(acceptButton, SIGNAL('clicked()'), self, SLOT('acceptSettings()'))
		connect(denyButton, SIGNAL('clicked()'), self, SLOT('close()'))
	end

	def acceptSettings()
		@settings.setValue("username", Qt::Variant.new(@usernameEditor.text.to_s.force_encoding('UTF-8')))
		@settings.setValue("addr", Qt::Variant.new(@addrEditor.text.to_s))
		@settings.setValue("port", Qt::Variant.new(@portEditor.text.to_i))
		readSettings
		@mainWindow.getNewSettings
		self.close
	end

	def getSet
		if @settings == nil
			createSettings
		else
			readSettings
		end
	end

	def readSettings
		puts "All keys: #{@settings.allKeys}"
		@username = @settings.value("username").toString.force_encoding('UTF-8')
		@serverAddr = @settings.value("addr").toString.force_encoding('UTF-8')
		@serverPort =  @settings.value("port").toString.force_encoding('UTF-8')
		@settings.sync()
	end

	def createSettings
		@settings.setValue("username", Qt::Variant.new("Админ"))
		@settings.setValue("addr", Qt::Variant.new("localhost"))
		@settings.setValue("port", Qt::Variant.new(3000))
		readSettings
	end

 end