extends Node2D
class_name DebugShaderBuilder

var frameCount = 0

func makeAlways(node: Node):
	if node is GPUParticles2D:
		node.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		node.process_mode = Node.PROCESS_MODE_INHERIT
	for i in node.get_children():
		makeAlways(i)
func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	makeAlways(self )
func _physics_process(_delta):
	frameCount += 1
	if frameCount > 1: # 只是用来Web导出时编译着色器而已，只运行1帧
		queue_free()
