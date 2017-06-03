
class OnlineTab < Qt::Widget

  slots 'messend()'

  attr_accessor :owner, :whom, :smallEditor 

  def initialize(main)
    super

    @main = main

    table = Qt::TableWidget.new(self)
    table.setRowCount(2)
    table.setColumnCount(1)
    table.setEditTriggers(Qt::AbstractItemView.NoEditTriggers)
    #table.setHorizontalHeaderItem("lol")
    #table.setHorizontalHeaderLabels(["id","name"])
    table.verticalHeader.setVisible(false)
    table.horizontalHeader.setVisible(false)
    #table.setItem(0,1, ("Hello"))
  end
end