
class ChatTab < Qt::Widget

	slots 'messend()'

  attr_accessor :owner, :whom, :smallEditor 

	def initialize(main)
		super

		@main = main


		  @smallEditor = Qt::TextEdit.new
	    @smallEditor.setReadOnly(true)
	    @mesLine = Qt::TextEdit.new
	    @mesLine.setMaximumHeight(75)
	    @mesLine.autoFormatting


	    @sendButton = Qt::PushButton.new('Отправить')

	    @buttonLayout = Qt::HBoxLayout.new do |b|
	    	b.addWidget(@mesLine)
	    	b.addWidget(@sendButton)
	    end

	    	@layout = Qt::VBoxLayout.new do |n|
	        	n.addWidget(@smallEditor)
	        	n.addLayout(@buttonLayout)
	        end

	    setLayout(@layout)
	    connect(@sendButton, SIGNAL('clicked()'), self, SLOT('messend()'))
	end
	def getname(owner, naame)
		@owner = owner
		@whom = naame
	end
	def sendmes

	end

    def addMessage(user, text)
      Qt.execute_in_main_thread{
        @smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + "#{user}: " + text.to_s.force_encoding(Encoding::UTF_8))
      }
    end

    def addMessgeFserv(text) # вполне уже может оказаться не нужной
      Qt.execute_in_main_thread{
        @smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + text.to_s.force_encoding(Encoding::UTF_8))}
    end

    
    def messend()
      if not (text = @mesLine.toPlainText.chomp).nil?
      	@main.mes_to_net(text, @whom)
        #@net.sending(text)
        #@message = text
        addMessage(@owner, text)
        #@smallEditor.append("[" + Time.now.strftime("%d/%m/%Y %H:%M")+"] " + "#{@userName}: " + text.to_s)
        @mesLine.clear
      end
    end

end