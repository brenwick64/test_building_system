extends Node
class_name UIEffects

static func bounce_control(
	node: Control, 
	peak_scale: Vector2 = Vector2(1.65, 1.65),
	base_scale: Vector2 = Vector2.ONE,
	durations: Array[float] = [0.1, 0.08, 0.07, 0.06]
) -> void:
	node.pivot_offset = node.size / 2
	var tween: Tween = node.create_tween()

	tween.tween_property(node, "scale", peak_scale, durations[0])\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", base_scale * 0.9, durations[1])\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "scale", base_scale * 1.1, durations[2])\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", base_scale, durations[3])\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
