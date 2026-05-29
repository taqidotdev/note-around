extends AudioStreamPlayer2D


var analyzer_effect: AudioEffectSpectrumAnalyzerInstance;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("analyzer ready")
	var bus_index = AudioServer.get_bus_index("Pitch");
	analyzer_effect = AudioServer.get_bus_effect_instance(bus_index, 0) as AudioEffectSpectrumAnalyzerInstance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#var frequencies = {
		#"C": 16.35,
		#"C#": 17.32,
		#"D": 18.35,
		#"D#": 19.45,
		#"E": 20.60,
		#"F": 21.83,
		#"F#": 23.12,
		#"G": 24.50,
		#"G#": 25.96,
		#"A": 27.50,
		#"A#": 29.14,
		#"B": 30.87,
	#}
	
	var frequencies = [
	{
		"note": "C",
		"min": 15.89,
		"max": 16.84
	},
	{
		"note": "C#",
		"min": 16.84,
		"max": 17.84
	},
	{
		"note": "D",
		"min": 17.84,
		"max": 18.90
	},
	{
		"note": "D#",
		"min": 18.90,
		"max": 20.02
	},
	{
		"note": "E",
		"min": 20.02,
		"max": 21.21
	},
	{
		"note": "F",
		"min": 21.21,
		"max": 22.48
	},
	{
		"note": "F#",
		"min": 22.48,
		"max": 23.81
	},
	{
		"note": "G",
		"min": 23.81,
		"max": 25.23
	},
	{
		"note": "G#",
		"min": 25.23,
		"max": 26.73
	},
	{
		"note": "A",
		"min": 26.73,
		"max": 28.32
	},
	{
		"note": "A#",
		"min": 28.32,
		"max": 30.01
	},
	{
		"note": "B",
		"min": 30.01,
		"max": 31.79
	}
]
	
	var max_magnitude = -9999.9;
	var note;
	
	for i in 9:
		for j in 12:	
			var magnitude = linear_to_db(analyzer_effect.get_magnitude_for_frequency_range(frequencies[j].min * pow(2, i), frequencies[j].max * pow(2, i)).length()) + 100;
			
			#print(magnitude, " note:", frequencies[j].note, " range: ", frequencies[j].min * pow(2, i) * i, "to", frequencies[j].max * pow(2, i))
			if magnitude > max_magnitude:
				max_magnitude = magnitude;
				note = frequencies[j].note
				
	print(max_magnitude, "note:", note)
	
	var magnitude = linear_to_db(analyzer_effect.get_magnitude_for_frequency_range(0, 200000000).length()) + 100;
	print(magnitude)
	pass
