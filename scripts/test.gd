extends Node2D

const MULTIWORLD_URL := "wss://multiworld.gg:51558"
var multiworld_socket := WebSocketPeer.new()
var multiworld_connected := false
var multiworld_connected_to_lobby := false

var item1_collected := false
var item2_collected := false
var item3_collected := false

var button1_pressed := false
var button2_pressed := false

var door1_open := false
var door2_open := false

var pentagram_visible := false
var transformed := false

func send_command(command: Dictionary) -> void:
	multiworld_socket.send_text(JSON.stringify([command]))

func _process(_delta: float) -> void:
	if multiworld_connected:
		multiworld_socket.poll()
			
		var state := multiworld_socket.get_ready_state()
		if state == WebSocketPeer.STATE_OPEN:
			while multiworld_socket.get_available_packet_count() > 0:
				var packet: Dictionary = JSON.parse_string(multiworld_socket.get_packet().get_string_from_utf8())[0]
				match packet["cmd"]:
					"DataPackage":
						print(packet)
					"RoomInfo":
						if not multiworld_connected_to_lobby:						
							send_command({
								"cmd": "Connect",
								"password": "",
								"game": "3 Gems",
								"name": "Diane",
								"uuid": "775a79ad-2789-444c-8430-10054fc1b1db",
								"version": {"class": "Version", "major": 0, "minor": 7, "build": 0},
								"items_handling": 0b111,
								"tags": ["AP"],
								"slot_data": true,
							})
							
							multiworld_connected_to_lobby = true
							
							send_command({
								"cmd": "GetDataPackage",
							})
					"Connected":
						print("Connected to lobby.")
						var slot_data: Dictionary = packet["slot_data"]
						
						var favorite_number: int = slot_data.get("favorite_number", 0)
						set_favorite_number(favorite_number)
						
						var random_colors: bool = slot_data.get("random_colors", false)
						if random_colors:
							$Item1.modulate = Color(randf(), randf(), randf())
							$Item2.modulate = Color(randf(), randf(), randf())
							$Item3.modulate = Color(randf(), randf(), randf())
					"PrintJSON":
						var result := ""
						for part: Dictionary in packet["data"]:
							match part.get("type", "text"):
								"text":
									result += part["text"]
								
						print_rich(result)
						print(packet)
					_:
						print(packet)
		elif state == WebSocketPeer.STATE_CLOSED:
			multiworld_connected = false
			var code := multiworld_socket.get_close_code()
			print("Websocket closed with code %d: %s" % [code, multiworld_socket.get_close_reason()])
			
			
func _on_button_websocket_pressed() -> void:
	multiworld_socket.inbound_buffer_size = 256000
	var err := multiworld_socket.connect_to_url(MULTIWORLD_URL)
	if err == OK: 
		multiworld_connected = true
		print("Connected.")
	else:
		push_error("Failed to connect: %s" % err)


func _on_button_websocket_2_pressed() -> void:
	send_command({
		"cmd": "Connect",
		"password": "",
		"game": "The Legend of Zelda",
		"name": "Diane",
		"uuid": "775a79ad-2789-444c-8430-10054fc1b1db",
		"version": {"class": "Version", "major": 0, "minor": 7, "build": 0},
		"items_handling": 0b111,
		"tags": ["AP"],
		"slot_data": true,
	})

####################################################################################################

func set_favorite_number(number: int) -> void:
	$FavoriteNumber.text = str(number)


func _on_button_1_body_entered(_body: Node2D) -> void:
	if not button1_pressed:
		button1_pressed = true
		$Button1/ColorRect.color = Color.BLUE
		$Door.queue_free()
		$SoundButton.play()
		
		send_command({
			"cmd": "LocationChecks",
			"locations": [4],
		})


func _on_button_2_body_entered(_body: Node2D) -> void:
	if not button2_pressed:
		button2_pressed = true
		$Button2/ColorRect.color = Color.BLUE
		$Door2.queue_free()
		$SoundButton.play()
		
		send_command({
			"cmd": "LocationChecks",
			"locations": [5],
		})


func _on_item_1_body_entered(_body: Node2D) -> void:
	if not item1_collected:
		item1_collected = true
		$Item1.queue_free()
		$SoundCollect.play()
		
		if item1_collected and item2_collected and item3_collected:
			$Pentagram.show()
			
		send_command({
			"cmd": "LocationChecks",
			"locations": [1],
		})


func _on_item_2_body_entered(_body: Node2D) -> void:
	if not item2_collected:
		item2_collected = true
		$Item2.queue_free()
		$SoundCollect.play()
		
		if item1_collected and item2_collected and item3_collected:
			$Pentagram.show()
			
		send_command({
			"cmd": "LocationChecks",
			"locations": [2],
		})


func _on_item_3_body_entered(_body: Node2D) -> void:
	if not item3_collected:
		item3_collected = true
		$Item3.queue_free()
		$SoundCollect.play()
		
		if item1_collected and item2_collected and item3_collected:
			$Pentagram.show()
			
		send_command({
			"cmd": "LocationChecks",
			"locations": [3],
		})
