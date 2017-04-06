
class ChatTab < Qt::Widget

	def initialize
		super

		@smallEditor = Qt::TextEdit.new
	    @smallEditor.setReadOnly(true)
	    #@smallEditor.setPlainText("Начало работы\n==========")

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

	    lllayout = Qt::VBoxLayout.new do |m|
	    	@layout = Qt::VBoxLayout.new do |n|
	        	n.addWidget(@smallEditor)
	        	n.addLayout(@buttonLayout)
	        end
	       	m.addLayout(@layout)
	        m.menuBar = @menuBar
	    end

	    setLayout(lllayout)
	    connect(@sendButton, SIGNAL('clicked()'), self, SLOT('messend()'))
	end
end