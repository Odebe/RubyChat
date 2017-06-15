
class OnlineTab < Qt::Widget

  slots 'messend()'

  attr_accessor :owner, :whom, :smallEditor 

  def initialize(main)
    super

    @main = main
    @users = {}
    @buttons = {}
    @vbox = Qt::VBoxLayout.new
    users = ["user"]
    makeUsers(users)

  end
  def startChat

  end
  def askOnline
    @main.mes_to_net("lsu","online")
  end
  def removeUsers
    @users.each do |user, lay|

    end
  end

  def makeUsers(users)
    users.each do |user|
      @users[user] = Qt::HBoxLayout.new
      @users[user].addWidget(Qt::Label.new(user.to_s))
      @buttons[user] = Qt::PushButton.new("Чат")
      @users[user].addWidget(@buttons[user])
      @users[user].setAlignment(Qt::AlignTop)
      @vbox.addLayout(@users[user])
    end
    setLayout(@vbox)
  end


end
