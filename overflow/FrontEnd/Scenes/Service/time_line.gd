class_name TimelineControl
extends PanelContainer

# Paramètres de rendu
@export var step_width: float = 60.0        # Distance en px entre 2 tours
@export var current_turn_x: float = 100.0   # Position X fixe de la ligne rouge
@export var turn_height: float = 20.0       # Taille des carrés de tour

# Textures des icônes d'événements
#@export var icons: Dictionary = {
	#"star_green": preload("res://assets/star_green.png"),
	#"star_yellow": preload("res://assets/star_yellow.png"),
	#"arrow_red": preload("res://assets/arrow_red.png")
#}

# Données du jeu
var current_turn: int = 0
var visual_offset: float = 0.0 # Décalage pour l'animation fluide
# Dictionnaire : turn_index -> type_evenement
var events: Dictionary = {
	1: "star_green",
	3: "star_yellow",
	4: "arrow_red",
	8: "arrow_red"
}

var speed : float = 0.0

func _ready() -> void:
	Signalbus.game_speed.connect(_on_game_speed)
	Signalbus.nouveau_tour.connect(_on_nouveau_tour)
	speed = GameLoop.TIME[GameLoop.GAME_TIME.NORMAL]

func _on_game_speed(_speed) -> void:
	speed = GameLoop.TIME[_speed]

func _on_nouveau_tour() -> void:
	advance_turn()

func _draw() -> void:
	var center_y = size.y / 2.0
	# 1. Ligne bleu clair de fond
	draw_line(Vector2(0, center_y), Vector2(size.x, center_y), Color.DEEP_SKY_BLUE, 3.0)
	
	# 2. Dessin des éléments (tours & événements)
	var max_visible_turns = int((size.x - current_turn_x) / step_width) + 2
	
	for i in range(-1, max_visible_turns):
		var turn_index = current_turn + i
		# Position X calculée en incluant le décalage animé (visual_offset)
		var x_pos = current_turn_x + (i * step_width) - visual_offset
		
		# On masque ce qui dépasse des bords du conteneur
		if x_pos < 0 or x_pos > size.x:
			continue
			
		# Dessin de l'événement ou du carré par défaut
		#if events.has(turn_index):
			#var icon_key = events[turn_index]
			#if icons.has(icon_key) and icons[icon_key]:
				#var texture = icons[icon_key] as Texture2D
				#var icon_pos = Vector2(x_pos - texture.get_width() / 2.0, center_y - texture.get_height() / 2.0)
				#draw_texture(texture, icon_pos)
		else:
			var rect = Rect2(x_pos - turn_height / 2.0, center_y - turn_height / 2.0, turn_height, turn_height)
			draw_rect(rect, Color.ROYAL_BLUE, false, 2.0)

	# 3. Ligne rouge fixe au premier plan
	draw_line(Vector2(current_turn_x, 0), Vector2(current_turn_x, size.y), Color.RED, 3.0)

# Appeler cette fonction pour passer au tour suivant
func advance_turn() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Anime le décalage de 0 à step_width et redessine à chaque étape
	tween.tween_method(
		func(val: float):
			visual_offset = val
			queue_redraw(),
		0.0,
		step_width,
		speed
	)
	
	# Une fois le glissement terminé, on incrémente le tour et on réinitialise l'offset
	tween.tween_callback(func():
		current_turn += 1
		visual_offset = 0.0
		queue_redraw()
	)

# Ajouter/Modifier un événement dynamiquement


func add_event(turn: int, event_type: String) -> void:
	events[turn] = event_type
	queue_redraw()
