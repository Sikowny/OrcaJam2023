extends RichTextLabel

func _recv_time_left(t: int):
	self.text = "[center]{t}[/center]".format({"t": str(t)}) 
